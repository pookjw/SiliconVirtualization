//
//  EditMachineStoragesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "EditMachineStoragesViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface EditMachineStoragesViewController ()
@property (retain, nonatomic, readonly, getter=_addButton) NSButton *addButton;
@end

@implementation EditMachineStoragesViewController
@synthesize addButton = _addButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_addButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *addButton = self.addButton;
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:addButton];
    [NSLayoutConstraint activateConstraints:@[
        [addButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [addButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (NSButton *)_addButton {
    if (auto addButton = _addButton) return addButton;
    
    NSButton *addButton = [NSButton new];
    addButton.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    addButton.target = self;
    addButton.action = @selector(_didTriggerAddButton:);
    
    _addButton = addButton;
    return addButton;
}

- (void)_didTriggerAddButton:(NSButton *)sender {
    [NSMenu popUpContextMenu:[self _makeAddButtonMenu] withEvent:sender.window.currentEvent forView:sender];
}

- (NSMenu *)_makeAddButtonMenu {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *virtioItem;
    {
        virtioItem = [NSMenuItem new];
        virtioItem.title = @"Virtio Block";
        
        NSMenu *submenu = [NSMenu new];
        
        NSMenuItem *addExistingItem = [NSMenuItem new];
        addExistingItem.title = @"Add Existing...";
        addExistingItem.target = self;
        addExistingItem.action = @selector(_didTriggerVirtioAddExistingItem:);
        [submenu addItem:addExistingItem];
        [addExistingItem release];
        
        NSMenuItem *createNewItem = [NSMenuItem new];
        createNewItem.title = @"Create new...";
        createNewItem.target = self;
        createNewItem.action = @selector(_didTriggerVirtioCreateNewItem:);
        [submenu addItem:createNewItem];
        [createNewItem release];
        
        virtioItem.submenu = submenu;
        [submenu release];
        [menu addItem:virtioItem];
        [virtioItem release];
    }
    
    NSMenuItem *usbItem = [NSMenuItem new];
    usbItem.title = @"USB Mass Storage";
    usbItem.target = self;
    usbItem.action = @selector(_didTriggerUSBItem:);
    [menu addItem:usbItem];
    [usbItem release];
    
    NSMenuItem *NVMExpressItem = [NSMenuItem new];
    NVMExpressItem.title = @"NVMExpress Controller";
    NVMExpressItem.target = self;
    NVMExpressItem.action = @selector(_didTriggerNVMExpressItem:);
    [menu addItem:NVMExpressItem];
    [NVMExpressItem release];
    
    return [menu autorelease];
}

- (void)_didTriggerVirtioAddExistingItem:(NSMenuItem *)sender {
}

- (void)_didTriggerVirtioCreateNewItem:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel new];
    
    panel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.disk-image-udif"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        
    }];
    [panel release];
}

- (void)_didTriggerUSBItem:(NSMenuItem *)sender {
    abort();
}

- (void)_didTriggerNVMExpressItem:(NSMenuItem *)sender {
    abort();
}

@end
