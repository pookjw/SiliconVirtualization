//
//  CreateMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "CreateMachineViewController.h"
#import <Virtualization/Virtualization.h>
#import "EditMachineViewController.h"
#import "SVCoreDataStack+VirtualizationSupport.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface CreateMachineViewController () <EditMachineViewControllerDelegate, NSToolbarDelegate>
@property (copy, nonatomic, getter=_machineConfiguration, setter=_setMachineConfiguration:) VZVirtualMachineConfiguration *machineConfiguration;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (retain, nonatomic, readonly, getter=_nextToolbarItem) NSToolbarItem *nextToolbarItem;
@end

@implementation CreateMachineViewController
@synthesize toolbar = _toolbar;
@synthesize nextToolbarItem = _nextToolbarItem;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _machineConfiguration = [VZVirtualMachineConfiguration new];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_machineConfiguration release];
    [_toolbar release];
    [_nextToolbarItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EditMachineViewController *editMachineViewController = [[EditMachineViewController alloc] initWithConfiguration:self.machineConfiguration];
    editMachineViewController.delegate = self;
    editMachineViewController.view.frame = self.view.bounds;
    editMachineViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:editMachineViewController.view];
    [self addChildViewController:editMachineViewController];
    [editMachineViewController release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didInitializeCoreDataStack:) name:SVCoreDataStackDidInitializeNotification object:SVCoreDataStack.sharedInstance];
    if (SVCoreDataStack.sharedInstance.initialized) {
        self.nextToolbarItem.enabled = YES;
    }
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    
    if (oldWindow) {
        oldWindow.toolbar = nil;
    }
    
    if (newWindow) {
        newWindow.toolbar = self.toolbar;
    }
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"CreateMachine"];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSToolbarItem *)_nextToolbarItem {
    if (auto nextToolbarItem = _nextToolbarItem) return nextToolbarItem;
    
    NSToolbarItem *nextToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Next"];
    nextToolbarItem.label = @"Next";
    nextToolbarItem.image = [NSImage imageWithSystemSymbolName:@"arrow.right" accessibilityDescription:nil];
    nextToolbarItem.target = self;
    nextToolbarItem.action = @selector(_didTriggerNextToolbarItem:);
    nextToolbarItem.enabled = NO;
    nextToolbarItem.autovalidates = NO;
    
    _nextToolbarItem = nextToolbarItem;
    return nextToolbarItem;
}

- (void)_didTriggerNextToolbarItem:(NSToolbarItem *)sender {
    VZVirtualMachineConfiguration *machineConfiguration = self.machineConfiguration;
    assert(machineConfiguration != nil);
    
    SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
    NSManagedObjectContext *context = stack.backgroundContext;
    
    [context performBlock:^{
        SVVirtualMachineConfiguration *configuration = [stack isolated_makeManagedObjectFromVirtualMachineConfiguration:machineConfiguration];
        configuration.timestamp = NSDate.now;
        NSError * _Nullable error = nil;
        // 이걸 해줘야 NSFetchedResultsController에서 이상한 Object ID가 안 날라옴
        [context obtainPermanentIDsForObjects:@[configuration] error:&error];
        assert(error == nil);
        [context save:&error];
        assert(error == nil);
    }];
}

- (void)_didInitializeCoreDataStack:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nextToolbarItem.enabled = SVCoreDataStack.sharedInstance.initialized;
    });
}

- (void)editMachineViewController:(EditMachineViewController *)editMachineViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.machineConfiguration = configuration;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.nextToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([self.nextToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.nextToolbarItem;
    } else {
        abort();
    }
}

@end
