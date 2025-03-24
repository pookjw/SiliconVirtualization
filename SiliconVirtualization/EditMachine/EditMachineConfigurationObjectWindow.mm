//
//  EditMachineConfigurationObjectWindow.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachineConfigurationObjectWindow.h"
#import "EditMachineViewController.h"
#import "SVCoreDataStack+VirtualizationSupport.h"

@interface EditMachineConfigurationObjectWindow () <NSToolbarDelegate>
@property (retain, nonatomic, readonly, getter=_machineConfigurationObject) SVVirtualMachineConfiguration *machineConfigurationObject;
@property (retain, nonnull, readonly, getter=_saveToolbarItem) NSToolbarItem *saveToolbarItem;
@property (nonatomic, retain, nullable, getter=_editMachineViewController) EditMachineViewController *editMachineViewController;
@end

@implementation EditMachineConfigurationObjectWindow
@synthesize saveToolbarItem = _saveToolbarItem;

- (instancetype)initWithMachineConfigurationObject:(SVVirtualMachineConfiguration *)machineConfigurationObject {
    if (self = [self init]) {
        _machineConfigurationObject = [machineConfigurationObject retain];
        
        NSManagedObjectContext *context = machineConfigurationObject.managedObjectContext;
        assert(context != nil);
        [context performBlock:^{
            VZVirtualMachineConfiguration *configuration = [SVCoreDataStack.sharedInstance isolated_makeVirtualMachineConfigurationFromManagedObject:machineConfigurationObject];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                EditMachineViewController *contentViewController = [[EditMachineViewController alloc] initWithConfiguration:configuration];
                self.contentViewController = contentViewController;
                [contentViewController release];
                
                self.saveToolbarItem.enabled = YES;
            });
        }];
    }
    
    return self;
}

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 400, 200.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Edit";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(400., 200.);
        
        NSViewController *contentViewController = [NSViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
        
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"EditMachine"];
        toolbar.delegate = self;
        self.toolbar = toolbar;
        [toolbar release];
    }
    
    return self;
}

- (void)dealloc {
    [_machineConfigurationObject release];
    [_saveToolbarItem release];
    [_editMachineViewController release];
    [super dealloc];
}

- (NSToolbarItem *)_saveToolbarItem {
    if (auto saveToolbarItem = _saveToolbarItem) return saveToolbarItem;
    
    NSToolbarItem *saveToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Save"];
    saveToolbarItem.label = @"Save";
    saveToolbarItem.image = [NSImage imageWithSystemSymbolName:@"checkmark" accessibilityDescription:nil];
    saveToolbarItem.target = self;
    saveToolbarItem.action = @selector(_didTriggerSaveToolbarItem:);
    saveToolbarItem.enabled = NO;
    saveToolbarItem.autovalidates = NO;
    
    _saveToolbarItem = saveToolbarItem;
    return saveToolbarItem;
}

- (void)_didTriggerSaveToolbarItem:(NSToolbarItem *)sender {
    SVVirtualMachineConfiguration *machineConfigurationObject = self.machineConfigurationObject;
    assert(machineConfigurationObject != nil);
    
    VZVirtualMachineConfiguration *configuration = self.editMachineViewController.configuration;
    assert(configuration != nil);
    
    SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
    NSManagedObjectContext *context = stack.backgroundContext;
    [context performBlock:^{
        [stack isolated_updateManagedObject:machineConfigurationObject withMachineConfiguration:configuration];
        
        NSError * _Nullable error = nil;
        [context save:&error];
        assert(error == nil);
    }];
}

- (EditMachineViewController *)_editMachineViewController {
    auto contentViewController = static_cast<EditMachineViewController *>(self.contentViewController);
    
    if ([contentViewController isKindOfClass:[EditMachineViewController class]]) {
        return contentViewController;
    }
    
    return nil;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.saveToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([self.saveToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.saveToolbarItem;
    } else {
        abort();
    }
}

@end
