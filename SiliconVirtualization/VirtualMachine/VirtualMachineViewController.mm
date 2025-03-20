//
//  VirtualMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "VirtualMachineViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface VirtualMachineViewController () <VZVirtualMachineDelegate, NSToolbarDelegate>
@property (retain, nonatomic, readonly, getter=_virtualMachineView) VZVirtualMachineView *virtualMachineView;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (retain, nonatomic, readonly, getter=_startToolbarItem) NSToolbarItem *startToolbarItem;

@property (nonatomic, readonly, nullable, getter=_virtualMachineQueue) dispatch_queue_t virtualMachineQueue;
@end

@implementation VirtualMachineViewController
@synthesize virtualMachineView = _virtualMachineView;
@synthesize toolbar = _toolbar;
@synthesize startToolbarItem = _startToolbarItem;

- (void)dealloc {
    if (VZVirtualMachine *virtualMachine = _virtualMachineView.virtualMachine) {
        [virtualMachine removeObserver:self forKeyPath:@"state"];
    }
    [_virtualMachineView release];
    [_toolbar release];
    [_startToolbarItem release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[VZVirtualMachine class]]) {
        if ([keyPath isEqualToString:@"state"]) {
            // Main Thread가 아닐 수 있음
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
            return;
        }
    }
    
    return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (VZVirtualMachine *)virtualMachine {
    return self.virtualMachineView.virtualMachine;
}

- (void)setVirtualMachine:(VZVirtualMachine *)virtualMachine {
    VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
    
    if (VZVirtualMachine *oldVirtualMachine = virtualMachineView.virtualMachine) {
        [oldVirtualMachine removeObserver:self forKeyPath:@"state"];
        [oldVirtualMachine release];
    }
    
    self.virtualMachineView.virtualMachine = virtualMachine;
    
    if (virtualMachine != nil) {
        assert(virtualMachine.delegate == nil);
        virtualMachine.delegate = self;
        [virtualMachine addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (dispatch_queue_t)_virtualMachineQueue {
    VZVirtualMachine *virtualMachine = self.virtualMachineView.virtualMachine;
    if (virtualMachine == nil) return nil;
    
    dispatch_queue_t _queue = nil;
    assert(object_getInstanceVariable(virtualMachine, "_queue", reinterpret_cast<void **>(&_queue)) != NULL);
    return _queue;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
    virtualMachineView.frame = self.view.bounds;
    virtualMachineView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:virtualMachineView];
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

- (VZVirtualMachineView *)_virtualMachineView {
    if (auto virtualMachineView = _virtualMachineView) return virtualMachineView;
    
    VZVirtualMachineView *virtualMachineView = [VZVirtualMachineView new];
    virtualMachineView.automaticallyReconfiguresDisplay = YES;
    virtualMachineView.capturesSystemKeys = YES;
    
    _virtualMachineView = virtualMachineView;
    return virtualMachineView;
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Virtual Machine"];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSToolbarItem *)_startToolbarItem {
    if (auto startToolbarItem = _startToolbarItem) return startToolbarItem;
    
    NSToolbarItem *startToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Start"];
    startToolbarItem.label = @"Start";
    startToolbarItem.image = [NSImage imageWithSystemSymbolName:@"play.fill" accessibilityDescription:nil];
    startToolbarItem.target = self;
    startToolbarItem.action = @selector(_didTriggerStartToolbarItem:);
    
    _startToolbarItem = startToolbarItem;
    return startToolbarItem;
}

- (void)_didTriggerStartToolbarItem:(NSToolbarItem *)sender {
    VZVirtualMachine *virtualMachine = self.virtualMachine;
    assert(virtualMachine != nil);
    
    dispatch_async(self.virtualMachineQueue, ^{
        VZMacOSVirtualMachineStartOptions *options = [VZMacOSVirtualMachineStartOptions new];
        options.startUpFromMacOSRecovery = YES;
        [virtualMachine startWithOptions:options completionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
        }];
        [options release];
    });
}

- (void)guestDidStopVirtualMachine:(VZVirtualMachine *)virtualMachine {
    abort();
}

- (void)virtualMachine:(VZVirtualMachine *)virtualMachine didStopWithError:(NSError *)error {
    abort();
}

- (void)virtualMachine:(VZVirtualMachine *)virtualMachine networkDevice:(VZNetworkDevice *)networkDevice attachmentWasDisconnectedWithError:(NSError *)error {
    abort();
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.startToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([self.startToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.startToolbarItem;
    } else {
        abort();
    }
}

@end
