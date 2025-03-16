//
//  MachinesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "MachinesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "CreateMachineWindow.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface MachinesViewController () <NSToolbarDelegate>
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@end

@implementation MachinesViewController
@synthesize toolbar = _toolbar;

- (void)dealloc {
    [_toolbar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _showCreateMachineWindow];
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
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Machines"];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSMenu *)_makeAddMachineMenu {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *createMenuItem = [NSMenuItem new];
    createMenuItem.title = @"Create a new machine...";
    createMenuItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    createMenuItem.target = self;
    createMenuItem.action = @selector(_didTriggerCreateMenuItem:);
    [menu addItem:createMenuItem];
    [createMenuItem release];
    
    return [menu autorelease];
}

- (void)_didTriggerAddMachineToolbarItem:(NSToolbarItem *)sender {
    NSView *_view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("_view"));
    
    [NSMenu popUpContextMenu:[self _makeAddMachineMenu]
                   withEvent:_view.window.currentEvent
                     forView:_view];
}

- (void)_didTriggerCreateMenuItem:(NSMenuItem *)sender {
    [self _showCreateMachineWindow];
}

- (void)_showCreateMachineWindow {
    CreateMachineWindow *window = [CreateMachineWindow new];
    [window makeKeyAndOrderFront:nil];
    [window release];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        @"AddMachine"
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        @"AddMachine"
    ];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:@"AddMachine"]) {
        NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        toolbarItem.target = self;
        toolbarItem.action = @selector(_didTriggerAddMachineToolbarItem:);
        toolbarItem.label = @"Add";
        toolbarItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
        return [toolbarItem autorelease];
    } else {
        abort();
    }
}

@end
