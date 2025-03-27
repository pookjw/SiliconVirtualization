//
//  VirtualMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "VirtualMachineViewController.h"
#import <Virtualization/Virtualization.h>
#import <objc/message.h>
#import <objc/runtime.h>
#import "NSStringFromVZVirtualMachineState.h"
#import "VirtualMachineViewModel.h"
#import "EditMachineViewController.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface VirtualMachineViewController () <NSToolbarDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_stopMenuItemTag) NSInteger stopMenuItemTag;
@property (class, nonatomic, readonly, getter=_requestStopMenuItemTag) NSInteger requestStopMenuItemTag;

@property (retain, nonatomic, readonly, getter=_virtualMachineView) VZVirtualMachineView *virtualMachineView;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;

@property (retain, nonatomic, readonly, getter=_startToolbarItem) NSToolbarItem *startToolbarItem;
@property (retain, nonatomic, readonly, getter=_resumeToolbarItem) NSToolbarItem *resumeToolbarItem;
@property (retain, nonatomic, readonly, getter=_stopMenuToolbarItem) NSMenuToolbarItem *stopMenuToolbarItem;
@property (retain, nonatomic, readonly, getter=_pauseToolbarItem) NSToolbarItem *pauseToolbarItem;

@property (retain, nonatomic, readonly, getter=_saveMachineStateToolbarItem) NSToolbarItem *saveMachineStateToolbarItem;
@property (retain, nonatomic, readonly, getter=_restoreMachineStateToolbarItem) NSToolbarItem *restoreMachineStateToolbarItem;

@property (retain, nonatomic, readonly, getter=_moreMenuToolbarItem) NSMenuToolbarItem *moreMenuToolbarItem;
@property (retain, nonatomic, readonly, getter=_stateToolbarItem) NSToolbarItem *stateToolbarItem;

@property (retain, nonatomic, readonly, getter=_editMachineToolbarItem) NSToolbarItem *editMachineToolbarItem;
@property (retain, nonatomic, readonly, getter=_editMachineViewController) EditMachineViewController *editMachineViewController;

@property (retain, nonatomic, readonly, getter=_viewModel) VirtualMachineViewModel *viewModel;
@end

@implementation VirtualMachineViewController
@synthesize virtualMachineView = _virtualMachineView;
@synthesize toolbar = _toolbar;
@synthesize startToolbarItem = _startToolbarItem;
@synthesize resumeToolbarItem = _resumeToolbarItem;
@synthesize stopMenuToolbarItem = _stopMenuToolbarItem;
@synthesize pauseToolbarItem = _pauseToolbarItem;
@synthesize saveMachineStateToolbarItem = _saveMachineStateToolbarItem;
@synthesize restoreMachineStateToolbarItem = _restoreMachineStateToolbarItem;
@synthesize moreMenuToolbarItem = _moreMenuToolbarItem;
@synthesize stateToolbarItem = _stateToolbarItem;
@synthesize editMachineToolbarItem = _editMachineToolbarItem;
@synthesize editMachineViewController = _editMachineViewController;
@synthesize viewModel = _viewModel;

+ (NSInteger)_stopMenuItemTag { return 1001; }
+ (NSInteger)_requestStopMenuItemTag { return 1002; }

- (void)dealloc {
    if (VZVirtualMachine *virtualMachine = _virtualMachineView.virtualMachine) {
        [virtualMachine removeObserver:self forKeyPath:@"state"];
    }
    [_virtualMachineView release];
    [_toolbar release];
    [_startToolbarItem release];
    [_resumeToolbarItem release];
    [_stopMenuToolbarItem release];
    [_pauseToolbarItem release];
    [_saveMachineStateToolbarItem release];
    [_restoreMachineStateToolbarItem release];
    [_moreMenuToolbarItem release];
    [_stateToolbarItem release];
    [_editMachineToolbarItem release];
    [_editMachineViewController release];
    [_viewModel release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([object isKindOfClass:[VZVirtualMachine class]]) {
        if ([keyPath isEqualToString:@"state"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self _updateToolbarItems];
            });
            return;
        }
    }
    
    return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)setVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject completionHandler:(void (^)())completionHandler {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        [viewModel isolated_setVirtualMachineObject:virtualMachineObject completionHandler:^{
            VZVirtualMachine *newVirtualMachine = viewModel.isolated_virtualMachine;
            assert(newVirtualMachine != nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
                
                if (VZVirtualMachine *oldVirtualMachine = virtualMachineView.virtualMachine) {
                    [oldVirtualMachine removeObserver:self forKeyPath:@"state"];
                }
                
                virtualMachineView.virtualMachine = newVirtualMachine;
                self.editMachineViewController.machine = newVirtualMachine;
                [newVirtualMachine addObserver:self forKeyPath:@"state" options:NSKeyValueObservingOptionNew context:NULL];
                [self _updateToolbarItems];
                
                if (completionHandler) completionHandler();
            });
        }];
    });
}

- (VirtualMachineViewModel *)_viewModel {
    dispatch_assert_queue(dispatch_get_main_queue());
    
    if (auto viewModel = _viewModel) return viewModel;
    
    VirtualMachineViewModel *viewModel = [VirtualMachineViewModel new];
    
    _viewModel = viewModel;
    return viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
    virtualMachineView.frame = self.view.bounds;
    virtualMachineView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:virtualMachineView];
    
    [self _updateToolbarItems];
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
    startToolbarItem.image = [NSImage imageWithSystemSymbolName:@"power" accessibilityDescription:nil];
    startToolbarItem.label = @"Start";
    startToolbarItem.target = self;
    startToolbarItem.action = @selector(_didTriggerStartToolbarItem:);
    startToolbarItem.autovalidates = NO;
    startToolbarItem.hidden = YES;
    
    _startToolbarItem = startToolbarItem;
    return startToolbarItem;
}

- (NSToolbarItem *)_resumeToolbarItem {
    if (auto resumeToolbarItem = _resumeToolbarItem) return resumeToolbarItem;
    
    NSToolbarItem *resumeToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Resume"];
    resumeToolbarItem.image = [NSImage imageWithSystemSymbolName:@"play.fill" accessibilityDescription:nil];
    resumeToolbarItem.label = @"Resume";
    resumeToolbarItem.target = self;
    resumeToolbarItem.action = @selector(_didTriggerResumeToolbarItem:);
    resumeToolbarItem.autovalidates = NO;
    resumeToolbarItem.hidden = YES;
    
    _resumeToolbarItem = resumeToolbarItem;
    return resumeToolbarItem;
}

- (NSMenuToolbarItem *)_stopMenuToolbarItem {
    if (auto stopMenuToolbarItem = _stopMenuToolbarItem) return stopMenuToolbarItem;
    
    NSMenuToolbarItem *stopMenuToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:@"Stop"];
    stopMenuToolbarItem.image = [NSImage imageWithSystemSymbolName:@"stop.fill" accessibilityDescription:nil];
    stopMenuToolbarItem.label = @"Stop";
    stopMenuToolbarItem.hidden = YES;
    
    {
        NSMenu *menu = [NSMenu new];
        
        NSMenuItem *stopMenuItem = [NSMenuItem new];
        stopMenuItem.title = @"Force Stop";
        stopMenuItem.image = [NSImage imageWithSystemSymbolName:@"xmark" accessibilityDescription:nil];
        stopMenuItem.target = self;
        stopMenuItem.action = @selector(_didTriggerStopMenuItem:);
        stopMenuItem.tag = VirtualMachineViewController.stopMenuItemTag;
        [menu addItem:stopMenuItem];
        [stopMenuItem release];
        
        NSMenuItem *requestStopMenuItem = [NSMenuItem new];
        requestStopMenuItem.title = @"Request Stop";
        requestStopMenuItem.image = [NSImage imageWithSystemSymbolName:@"power.dotted" accessibilityDescription:nil];
        requestStopMenuItem.target = self;
        requestStopMenuItem.action = @selector(_didTriggerRequestStopMenuItem:);
        requestStopMenuItem.tag = VirtualMachineViewController.requestStopMenuItemTag;
        [menu addItem:requestStopMenuItem];
        [requestStopMenuItem release];
        
        stopMenuToolbarItem.menu = menu;
        [menu release];
    }
    
    _stopMenuToolbarItem = stopMenuToolbarItem;
    return stopMenuToolbarItem;
}

- (NSToolbarItem *)_pauseToolbarItem {
    if (auto pauseToolbarItem = _pauseToolbarItem) return pauseToolbarItem;
    
    NSToolbarItem *pauseToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Pause"];
    pauseToolbarItem.image = [NSImage imageWithSystemSymbolName:@"pause.fill" accessibilityDescription:nil];
    pauseToolbarItem.label = @"Pause";
    pauseToolbarItem.target = self;
    pauseToolbarItem.action = @selector(_didTriggerPauseToolbarItem:);
    pauseToolbarItem.hidden = YES;
    
    _pauseToolbarItem = pauseToolbarItem;
    return pauseToolbarItem;
}

- (NSToolbarItem *)_saveMachineStateToolbarItem {
    if (auto saveMachineStateToolbarItem = _saveMachineStateToolbarItem) return saveMachineStateToolbarItem;
    
    NSToolbarItem *saveMachineStateToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Save Machine State"];
    saveMachineStateToolbarItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.up" accessibilityDescription:nil];
    saveMachineStateToolbarItem.label = @"Save";
    saveMachineStateToolbarItem.toolTip = @"Save Machine State";
    saveMachineStateToolbarItem.target = self;
    saveMachineStateToolbarItem.action = @selector(_didTriggerSaveMachineStateToolbarItem:);
    saveMachineStateToolbarItem.hidden = YES;
    
    _saveMachineStateToolbarItem = saveMachineStateToolbarItem;
    return saveMachineStateToolbarItem;
}

- (NSToolbarItem *)_restoreMachineStateToolbarItem {
    if (auto restoreMachineStateToolbarItem = _restoreMachineStateToolbarItem) return restoreMachineStateToolbarItem;
    
    NSToolbarItem *restoreMachineStateToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Restore Machine State"];
    restoreMachineStateToolbarItem.image = [NSImage imageWithSystemSymbolName:@"square.and.arrow.down" accessibilityDescription:nil];
    restoreMachineStateToolbarItem.label = @"Restore";
    restoreMachineStateToolbarItem.toolTip = @"Restore Machine State";
    restoreMachineStateToolbarItem.target = self;
    restoreMachineStateToolbarItem.action = @selector(_didTriggerRestoreMachineStateToolbarItem:);
    restoreMachineStateToolbarItem.hidden = YES;
    
    _restoreMachineStateToolbarItem = restoreMachineStateToolbarItem;
    return restoreMachineStateToolbarItem;
}

- (NSMenuToolbarItem *)_moreMenuToolbarItem {
    if (auto moreMenuToolbarItem = _moreMenuToolbarItem) return moreMenuToolbarItem;
    
    NSMenuToolbarItem *moreMenuToolbarItem = [[NSMenuToolbarItem alloc] initWithItemIdentifier:@"More Menu"];
    moreMenuToolbarItem.image = [NSImage imageWithSystemSymbolName:@"ellipsis" accessibilityDescription:nil];
    moreMenuToolbarItem.label = @"More";
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    moreMenuToolbarItem.menu = menu;
    [menu release];
    
    _moreMenuToolbarItem = moreMenuToolbarItem;
    return moreMenuToolbarItem;
}

- (NSToolbarItem *)_stateToolbarItem {
    if (auto stateToolbarItem = _stateToolbarItem) return stateToolbarItem;
    
    NSToolbarItem *stateToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"State"];
    stateToolbarItem.enabled = NO;
    stateToolbarItem.autovalidates = NO;
    
    _stateToolbarItem = stateToolbarItem;
    return stateToolbarItem;
}

- (NSToolbarItem *)_editMachineToolbarItem {
    if (auto editMachineToolbarItem = _editMachineToolbarItem) return editMachineToolbarItem;
    
    NSToolbarItem *editMachineToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Edit Machine"];
    editMachineToolbarItem.label = @"Edit";
    editMachineToolbarItem.image = [NSImage imageWithSystemSymbolName:@"gear" accessibilityDescription:nil];
    editMachineToolbarItem.target = self;
    editMachineToolbarItem.action = @selector(_didTriggerEditMachineToolbarItem:);
    
    _editMachineToolbarItem = editMachineToolbarItem;
    return editMachineToolbarItem;
}

- (EditMachineViewController *)_editMachineViewController {
    if (auto editMachineViewController = _editMachineViewController) return editMachineViewController;
    
    EditMachineViewController *editMachineViewController = [EditMachineViewController new];
    
    _editMachineViewController = editMachineViewController;
    return editMachineViewController;
}

- (void)_didTriggerStartToolbarItem:(NSToolbarItem *)sender {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        assert(virtualMachine != nil);
        
        [self _queue_startAccessingSecurityScopedResourcesWithVirtualMachine:virtualMachine];
        
        VZMacOSVirtualMachineStartOptions *options = [VZMacOSVirtualMachineStartOptions new];
        options.startUpFromMacOSRecovery = viewModel.startUpFromMacOSRecovery;
        [virtualMachine startWithOptions:options completionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
        }];
        [options release];
    });
}

- (void)_didTriggerResumeToolbarItem:(NSToolbarItem *)sender {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        assert(virtualMachine != nil);
        
        [virtualMachine resumeWithCompletionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
        }];
    });
}

- (void)_didTriggerStopMenuItem:(NSMenuItem *)sender {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        assert(virtualMachine != nil);
        
        [virtualMachine stopWithCompletionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
        }];
    });
}

- (void)_didTriggerRequestStopMenuItem:(NSMenuItem *)sender {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        assert(virtualMachine != nil);
        
        NSError * _Nullable error = nil;
        [virtualMachine requestStopWithError:&error];
        assert(error == nil);
    });
}

- (void)_didTriggerPauseToolbarItem:(NSMenuItem *)sender {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        assert(virtualMachine != nil);
        
        [virtualMachine pauseWithCompletionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
        }];
    });
}

- (void)_didTriggerSaveMachineStateToolbarItem:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel new];
    panel.canCreateDirectories = YES;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            VirtualMachineViewModel *viewModel = self.viewModel;
            
            dispatch_async(viewModel.queue, ^{
                VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
                assert(virtualMachine != nil);
                
                NSFileManager *fileManager = NSFileManager.defaultManager;
                if ([fileManager fileExistsAtPath:URL.path]) {
                    NSError * _Nullable error = nil;
                    [fileManager removeItemAtURL:URL error:&error];
                    assert(error == nil);
                }
                
                [virtualMachine saveMachineStateToURL:URL completionHandler:^(NSError * _Nullable errorOrNil) {
                    assert(errorOrNil == nil);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [NSAlert new];
                        alert.messageText = @"Saved!";
                        alert.informativeText = URL.path;
                        
                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                            
                        }];
                        [alert release];
                    });
                }];
            });
        }
    }];
    
    [panel release];
}

- (void)_didTriggerRestoreMachineStateToolbarItem:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel new];
    panel.canChooseFiles = YES;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            VirtualMachineViewModel *viewModel = self.viewModel;
            
            dispatch_async(viewModel.queue, ^{
                VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
                assert(virtualMachine != nil);
                
                [virtualMachine restoreMachineStateFromURL:URL completionHandler:^(NSError * _Nullable errorOrNil) {
                    assert(errorOrNil == nil);
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSAlert *alert = [NSAlert new];
                        alert.messageText = @"Restored!";
                        alert.informativeText = URL.path;
                        
                        [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                            
                        }];
                        [alert release];
                    });
                }];
            });
        }
    }];
    
    [panel release];
}

- (void)_didTriggerEditMachineToolbarItem:(NSToolbarItem *)sender {
    self.editMachineViewController.machine = self.virtualMachineView.virtualMachine;
    
    NSPopover *popover = [NSPopover new];
    popover.behavior = NSPopoverBehaviorSemitransient;
    popover.contentViewController = self.editMachineViewController;
    [popover showRelativeToToolbarItem:sender];
    [popover release];
}

- (void)_queue_startAccessingSecurityScopedResourcesWithVirtualMachine:(VZVirtualMachine *)virtualMachine {
    VZVirtualMachineConfiguration *_currentConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachine, sel_registerName("_currentConfiguration"));
    
    {
        __kindof VZPlatformConfiguration *platform = _currentConfiguration.platform;
        if ([platform isKindOfClass:[VZMacPlatformConfiguration class]]) {
            auto casted = static_cast<VZMacPlatformConfiguration *>(platform);
            if (NSURL *URL = casted.auxiliaryStorage.URL) {
                assert([URL startAccessingSecurityScopedResource]);
            }
        }
        
        for (__kindof VZStorageDeviceConfiguration *storageDevice in _currentConfiguration.storageDevices) {
            if ([storageDevice isKindOfClass:[VZStorageDeviceConfiguration class]]) {
                auto casted = static_cast<VZStorageDeviceConfiguration *>(storageDevice);
                __kindof VZStorageDeviceAttachment *attachment = casted.attachment;
                
                if ([attachment isKindOfClass:[VZDiskImageStorageDeviceAttachment class]]) {
                    auto casted = static_cast<VZDiskImageStorageDeviceAttachment *>(attachment);
                    assert([casted.URL startAccessingSecurityScopedResource]);
                }
            }
        }
    }
}

- (void)_queue_stopAccessingSecurityScopedResourcesWithVirtualMachine:(VZVirtualMachine *)virtualMachine {
    VZVirtualMachineConfiguration *_currentConfiguration = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachine, sel_registerName("_currentConfiguration"));
    
    {
        __kindof VZPlatformConfiguration *platform = _currentConfiguration.platform;
        if ([platform isKindOfClass:[VZMacPlatformConfiguration class]]) {
            auto casted = static_cast<VZMacPlatformConfiguration *>(platform);
            if (NSURL *URL = casted.auxiliaryStorage.URL) {
                [URL stopAccessingSecurityScopedResource];
            }
        }
        
        for (__kindof VZStorageDeviceConfiguration *storageDevice in _currentConfiguration.storageDevices) {
            if ([storageDevice isKindOfClass:[VZStorageDeviceConfiguration class]]) {
                auto casted = static_cast<VZStorageDeviceConfiguration *>(storageDevice);
                __kindof VZStorageDeviceAttachment *attachment = casted.attachment;
                
                if ([attachment isKindOfClass:[VZDiskImageStorageDeviceAttachment class]]) {
                    auto casted = static_cast<VZDiskImageStorageDeviceAttachment *>(attachment);
                    [casted.URL stopAccessingSecurityScopedResource];
                }
            }
        }
    }
}

- (void)_updateToolbarItems {
    VirtualMachineViewModel *viewModel = self.viewModel;
    
    dispatch_async(viewModel.queue, ^{
        VZVirtualMachine *virtualMachine = viewModel.isolated_virtualMachine;
        
        if (virtualMachine == nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.stateToolbarItem.hidden = YES;
                self.startToolbarItem.hidden = YES;
                self.resumeToolbarItem.hidden = YES;
                self.stopMenuToolbarItem.hidden = YES;
                self.pauseToolbarItem.hidden = YES;
                self.saveMachineStateToolbarItem.hidden = YES;
                self.restoreMachineStateToolbarItem.hidden = YES;
            });
        } else {
            VZVirtualMachineState state = virtualMachine.state;
            NSString *stateString = NSStringFromVZVirtualMachineState(state);
            BOOL canStart = virtualMachine.canStart;
            BOOL canResume = virtualMachine.canResume;
            BOOL canStop = virtualMachine.canStop;
            BOOL canRequestStop = virtualMachine.canRequestStop;
            BOOL canPause = virtualMachine.canPause;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSToolbarItem *stateToolbarItem = self.stateToolbarItem;
                stateToolbarItem.hidden = NO;
                stateToolbarItem.title = stateString;
                
                self.startToolbarItem.hidden = !canStart;
                self.resumeToolbarItem.hidden = !canResume;
                
                NSMenuToolbarItem *stopMenuToolbarItem = self.stopMenuToolbarItem;
                [stopMenuToolbarItem.menu itemWithTag:VirtualMachineViewController.stopMenuItemTag].hidden = !canStop;
                [stopMenuToolbarItem.menu itemWithTag:VirtualMachineViewController.requestStopMenuItemTag].hidden = !canRequestStop;
                stopMenuToolbarItem.hidden = !canStop && !canRequestStop;
                
                self.pauseToolbarItem.hidden = !canPause;
                
                self.saveMachineStateToolbarItem.hidden = (state != VZVirtualMachineStatePaused);
                self.restoreMachineStateToolbarItem.hidden = (state != VZVirtualMachineStateStopped);
            });
        }
    });
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.startToolbarItem.itemIdentifier,
        self.restoreMachineStateToolbarItem.itemIdentifier,
        self.saveMachineStateToolbarItem.itemIdentifier,
        self.stopMenuToolbarItem.itemIdentifier,
        self.resumeToolbarItem.itemIdentifier,
        self.pauseToolbarItem.itemIdentifier,
        @"Separator",
        self.editMachineToolbarItem.itemIdentifier,
        self.moreMenuToolbarItem.itemIdentifier,
        self.stateToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([self.startToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.startToolbarItem;
    } else if ([self.resumeToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.resumeToolbarItem;
    } else if ([self.stopMenuToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.stopMenuToolbarItem;
    } else if ([self.pauseToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.pauseToolbarItem;
    } else if ([self.editMachineToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.editMachineToolbarItem;
    } else if ([self.saveMachineStateToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.saveMachineStateToolbarItem;
    } else if ([self.restoreMachineStateToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.restoreMachineStateToolbarItem;
    } else if ([self.moreMenuToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.moreMenuToolbarItem;
    } else if ([self.stateToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.stateToolbarItem;
    } else if ([itemIdentifier isEqualToString:@"Separator"]) {
        return reinterpret_cast<id (*)(Class, SEL, id, id, NSInteger)>(objc_msgSend)(objc_lookUpClass("NSSeparatorToolbarItem"), sel_registerName("separatorToolbarItemWithIdentifier:trackingSplitView:dividerIndex:"), itemIdentifier, nil, NSNotFound);
    } else {
        abort();
    }
}

- (void)menuWillOpen:(NSMenu *)menu {
    if ([menu isEqual:self.moreMenuToolbarItem.menu]) {
        [menu removeAllItems];
        
        NSMenuItem *automaticallyReconfiguresDisplayItem = [NSMenuItem new];
        automaticallyReconfiguresDisplayItem.title = @"Automatically Reconfigures Display";
        automaticallyReconfiguresDisplayItem.target = self;
        automaticallyReconfiguresDisplayItem.action = @selector(_didTriggerAutomaticallyReconfiguresDisplayItem:);
        automaticallyReconfiguresDisplayItem.state = self.virtualMachineView.automaticallyReconfiguresDisplay ? NSControlStateValueOn : NSControlStateValueOff;
        [menu addItem:automaticallyReconfiguresDisplayItem];
        // https://x.com/_silgen_name/status/1902723721158369352
        automaticallyReconfiguresDisplayItem.hidden = NO;
        [automaticallyReconfiguresDisplayItem release];
        
        NSMenuItem *capturesSystemKeysItem = [NSMenuItem new];
        capturesSystemKeysItem.title = @"Captures System Keys";
        capturesSystemKeysItem.target = self;
        capturesSystemKeysItem.action = @selector(_didTriggerCapturesSystemKeysItem:);
        capturesSystemKeysItem.state = self.virtualMachineView.capturesSystemKeys ? NSControlStateValueOn : NSControlStateValueOff;
        [menu addItem:capturesSystemKeysItem];
        [capturesSystemKeysItem release];
        
        [menu addItem:[NSMenuItem separatorItem]];
        
        NSMenuItem *startUpFromMacOSRecoveryItem = [NSMenuItem new];
        startUpFromMacOSRecoveryItem.title = @"Start Up From macOS Recovery";
        startUpFromMacOSRecoveryItem.target = self;
        startUpFromMacOSRecoveryItem.action = @selector(_didTriggerStartUpFromMacOSRecoveryItem:);
        startUpFromMacOSRecoveryItem.state = self.viewModel.startUpFromMacOSRecovery ? NSControlStateValueOn : NSControlStateValueOff;
        [menu addItem:startUpFromMacOSRecoveryItem];
        [startUpFromMacOSRecoveryItem release];
    } else {
        abort();
    }
}

- (void)_didTriggerAutomaticallyReconfiguresDisplayItem:(NSMenuItem *)sender {
    VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
    virtualMachineView.automaticallyReconfiguresDisplay = (sender.state != NSControlStateValueOn);
}

- (void)_didTriggerCapturesSystemKeysItem:(NSMenuItem *)sender {
    VZVirtualMachineView *virtualMachineView = self.virtualMachineView;
    virtualMachineView.capturesSystemKeys = (sender.state != NSControlStateValueOn);
}

- (void)_didTriggerStartUpFromMacOSRecoveryItem:(NSMenuItem *)sender {
    self.viewModel.startUpFromMacOSRecovery = (sender.state != NSControlStateValueOn);
}

@end
