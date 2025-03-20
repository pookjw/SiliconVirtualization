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
#import "EditMachineStoragesCellView.h"

@interface EditMachineStoragesViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly, getter=_imageCreationProgressKey) void *imageCreationProgressKey;
@property (class, nonatomic, readonly, getter=_installationProgressKey) void *installationProgressKey;
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_addButton) NSButton *addButton;
@end

@implementation EditMachineStoragesViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize addButton = _addButton;

+ (void *)_imageCreationProgressKey {
    static void *key = &key;
    return key;
}

+ (void *)_installationProgressKey {
    static void *key = &key;
    return key;
}

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineStoragesCellView class]);
}

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_scrollView release];
    [_tableView release];
    [_addButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
    
    NSButton *addButton = self.addButton;
    addButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:addButton];
    [NSLayoutConstraint activateConstraints:@[
        [addButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [addButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    [self.tableView reloadData];
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    NSNib *cellViewNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineStoragesCellView class]) bundle:[NSBundle bundleForClass:[EditMachineStoragesCellView class]]];
    [tableView registerNib:cellViewNib forIdentifier:EditMachineStoragesViewController.cellItemIdentifier];
    [cellViewNib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    _tableView = tableView;
    return tableView;
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
    NSOpenPanel *panel = [NSOpenPanel new];
    
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.resolvesAliases = YES;
    panel.allowsMultipleSelection = NO;
//    panel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.disk-image-udif"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (NSURL *URL = panel.URL) {
            [self _addStorageURLIntoConfiguration:URL];
        }
    }];
    
    [panel release];
}

- (void)_didTriggerVirtioCreateNewItem:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel new];
    
    EditMachineStorageControl *accessoryView = [EditMachineStorageControl new];
    [accessoryView sizeToFit];
    panel.accessoryView = accessoryView;
    
    panel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.disk-image-udif"]];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK) {
            [self _presentImageCreationProgressController];
            
            NSURL *URL = panel.URL;
            assert(URL != nil);
            
            uint64_t unsignedInt64Value = accessoryView.unsignedInt64Value;
            assert(unsignedInt64Value >= 50 * 1024ull * 1024ull * 1024ull);
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [EditMachineStoragesViewController _createEmptyDiskImageIntoURL:URL bytesSize:unsignedInt64Value];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self _dismissProgressIndicatorViewControllers];
                    [self _addStorageURLIntoConfiguration:URL];
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

- (void)_addStorageURLIntoConfiguration:(NSURL *)URL {
    dispatch_assert_queue(dispatch_get_main_queue());
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    NSError * _Nullable error = nil;
    VZDiskImageStorageDeviceAttachment *attachment = [[VZDiskImageStorageDeviceAttachment alloc] initWithURL:URL readOnly:NO error:&error];
    assert(error == nil);
    
    VZVirtioBlockDeviceConfiguration *virtioBlockDeviceConfiguration = [[VZVirtioBlockDeviceConfiguration alloc] initWithAttachment:attachment];
    [attachment release];
    
    configuration.storageDevices = [configuration.storageDevices arrayByAddingObject:virtioBlockDeviceConfiguration];
    [virtioBlockDeviceConfiguration release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate EditMachineStoragesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)_presentImageCreationProgressController {
    NSViewController *viewController = [NSViewController new];
    NSProgressIndicator *progressIndicator = [NSProgressIndicator new];
    progressIndicator.style = NSProgressIndicatorStyleSpinning;
    [progressIndicator startAnimation:nil];
    [progressIndicator sizeToFit];
    viewController.view = progressIndicator;
    [progressIndicator release];
    
    objc_setAssociatedObject(viewController, EditMachineStoragesViewController.imageCreationProgressKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self presentViewControllerAsSheet:viewController];
    [viewController release];
}

- (void)_dismissProgressIndicatorViewControllers {
    for (NSViewController *presentedViewController in self.presentedViewControllers) {
        if (objc_getAssociatedObject(presentedViewController, EditMachineStoragesViewController.imageCreationProgressKey)) {
            [self dismissViewController:presentedViewController];
        }
    }
}

- (void)_presentInstallationProgressControllerWithProgress:(NSProgress *)progress {
    NSViewController *viewController = [NSViewController new];
    NSProgressIndicator *progressIndicator = [NSProgressIndicator new];
    progressIndicator.style = NSProgressIndicatorStyleBar;
    progressIndicator.observedProgress = progress;
    [progressIndicator startAnimation:nil];
    progressIndicator.frame = NSMakeRect(0., 0., 300., progressIndicator.fittingSize.height);
    viewController.view = progressIndicator;
    [progressIndicator release];
    
    objc_setAssociatedObject(viewController, EditMachineStoragesViewController.installationProgressKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self presentViewControllerAsSheet:viewController];
    [viewController release];
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.configuration.storageDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineStoragesCellView *view = [tableView makeViewWithIdentifier:EditMachineStoragesViewController.cellItemIdentifier owner:nil];
    
    auto deviceConfiguration = static_cast<VZVirtioBlockDeviceConfiguration *>(self.configuration.storageDevices[row]);
    __kindof VZStorageDeviceAttachment *attachment = deviceConfiguration.attachment;
    
    if ([attachment isKindOfClass:[VZDiskImageStorageDeviceAttachment class]]) {
        auto casted = static_cast<VZDiskImageStorageDeviceAttachment *>(attachment);
        view.textField.stringValue = casted.URL.path;
    } else {
        abort();
    }
    
    return view;
}

@end
