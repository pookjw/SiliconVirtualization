//
//  EditMachineStoragesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "EditMachineStoragesViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#import "EditMachineStorageControl.h"
#include <sys/fcntl.h>
#include <unistd.h>
#import <objc/runtime.h>

@interface EditMachineStoragesViewController ()
@property (class, nonatomic, readonly) void *progressIndicatorKey;
@property (retain, nonatomic, readonly, getter=_addButton) NSButton *addButton;
@end

@implementation EditMachineStoragesViewController
@synthesize addButton = _addButton;

+ (void *)progressIndicatorKey {
    static void *key = &key;
    return key;
}

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
    
    EditMachineStorageControl *accessoryView = [EditMachineStorageControl new];
    [accessoryView sizeToFit];
    panel.accessoryView = accessoryView;
    
    panel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.disk-image-udif"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            [self _presentProgressIndicatorViewController];
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [EditMachineStoragesViewController _createEmptyDiskImageIntoURL:panel.URL bytesSize:accessoryView.unsignedInt64Value];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _dismissProgressIndicatorViewControllers];
                });
            });
        }
    }];
    
    [accessoryView release];
    [panel release];
}

- (void)_didTriggerUSBItem:(NSMenuItem *)sender {
    abort();
}

- (void)_didTriggerNVMExpressItem:(NSMenuItem *)sender {
    abort();
}

- (void)_presentProgressIndicatorViewController {
    NSViewController *viewController = [NSViewController new];
    NSProgressIndicator *progressIndicator = [NSProgressIndicator new];
    progressIndicator.style = NSProgressIndicatorStyleSpinning;
    [progressIndicator startAnimation:nil];
    [progressIndicator sizeToFit];
    viewController.view = progressIndicator;
    [progressIndicator release];
    
    objc_setAssociatedObject(viewController, EditMachineStoragesViewController.progressIndicatorKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self presentViewControllerAsSheet:viewController];
    [viewController release];
}

- (void)_dismissProgressIndicatorViewControllers {
    for (NSViewController *presentedViewController in self.presentedViewControllers) {
        if (objc_getAssociatedObject(presentedViewController, EditMachineStoragesViewController.progressIndicatorKey)) {
            [self dismissViewController:presentedViewController];
        }
    }
}

+ (void)_createEmptyDiskImageIntoURL:(NSURL *)URL bytesSize:(uint64_t)bytesSize {
    assert(!NSThread.isMainThread);
    
    int fd = open(URL.fileSystemRepresentation, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR);
    assert(fd != -1);
    
    int result = ftruncate(fd, bytesSize);
    assert(result == 0);
    
    result = close(fd);
    assert(result == 0);
}

@end
