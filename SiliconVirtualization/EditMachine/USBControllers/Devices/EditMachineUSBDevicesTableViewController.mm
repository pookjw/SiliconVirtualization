//
//  EditMachineUSBDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import "EditMachineUSBDevicesTableViewController.h"
#import "EditMachineUSBDevicesTableCellView.h"
#import "DiskBlockDeviceStorageDeviceAttachmentConfigurationView.h"

@interface EditMachineUSBDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_attachButton) NSButton *attachButton;
@end

@implementation EditMachineUSBDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize attachButton = _attachButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineUSBDevicesTableCellView class]);
}

- (void)dealloc {
    [_usbDevices release];
    [_scrollView release];
    [_tableView release];
    [_attachButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
    
    NSButton *attachButton = self.attachButton;
    attachButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:attachButton];
    [NSLayoutConstraint activateConstraints:@[
        [attachButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [attachButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (void)setUSBDevices:(NSArray<id<VZUSBDeviceConfiguration>> *)usbDevices {
    [_usbDevices release];
    _usbDevices = [usbDevices copy];
    
    [self _didChangeUSBDevices];
}

- (void)_didChangeUSBDevices {
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    
    if (tableView.numberOfRows > 0) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    }
    
    [self _tableViewSelectionDidChange];
}

- (void)_tableViewSelectionDidChange {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    NSInteger selectedRow = self.tableView.selectedRow;
    [delegate editMachineUSBDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineUSBDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineUSBDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineUSBDevicesTableViewController.cellItemIdentifier];
    [cellNib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    tableView.allowsEmptySelection = YES;
    tableView.allowsMultipleSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    tableView.menu = menu;
    [menu release];
    
    _tableView = tableView;
    return tableView;
}

- (NSButton *)_attachButton {
    if (auto attachButton = _attachButton) return attachButton;
    
    NSButton *attachButton = [NSButton new];
    attachButton.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    attachButton.target = self;
    attachButton.action = @selector(_didTriggerattachButton:);
    
    _attachButton = attachButton;
    return attachButton;
}

- (void)_didTriggerattachButton:(NSButton *)sender {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *usbMassStorageItem = [NSMenuItem new];
    usbMassStorageItem.title = @"USB Mass Storage";
    usbMassStorageItem.target = self;
    usbMassStorageItem.action = @selector(_didTriggerUSBMassStorageItem:);
    usbMassStorageItem.enabled = (self.delegate != nil);
    [menu addItem:usbMassStorageItem];
    [usbMassStorageItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerUSBMassStorageItem:(NSMenuItem *)sender {
    NSAlert *alert = [NSAlert new];
    
    alert.messageText = @"USB Mass Storage";
    
    DiskBlockDeviceStorageDeviceAttachmentConfigurationView *accessoryView = [DiskBlockDeviceStorageDeviceAttachmentConfigurationView new];
    NSSize fittingSize = accessoryView.fittingSize;
    accessoryView.frame = NSMakeRect(0., 0., fittingSize.width, fittingSize.height);
    alert.accessoryView = accessoryView;
    
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            id<EditMachineUSBDevicesTableViewControllerDelegate> delegate = self.delegate;
            if (delegate == nil) return;
            
            NSFileHandle *fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:accessoryView.fileDescriptor closeOnDealloc:NO];
            
            NSError * _Nullable error = nil;
            VZDiskBlockDeviceStorageDeviceAttachment *attachment = [[VZDiskBlockDeviceStorageDeviceAttachment alloc] initWithFileHandle:fileHandle readOnly:accessoryView.readOnly synchronizationMode:accessoryView.synchronizationMode error:&error];
            [fileHandle release];
            
            if (error != nil) {
                NSLog(@"%@", error);
                [attachment release];
                return;
            }
            
            VZUSBMassStorageDeviceConfiguration *configuration = [[VZUSBMassStorageDeviceConfiguration alloc] initWithAttachment:attachment];
            [attachment release];
            
            VZUSBMassStorageDevice *device = [[VZUSBMassStorageDevice alloc] initWithConfiguration:configuration];
            [configuration  release];
            
            [delegate editMachineUSBDevicesTableViewController:self attachUSBDevice:device];
            [device release];
        }
    }];
    
    [accessoryView release];
    [alert release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.usbDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineUSBDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineUSBDevicesTableViewController.cellItemIdentifier owner:nil];
    
    id<VZUSBDevice> device = self.usbDevices[row];
    
    if ([device isKindOfClass:[VZUSBMassStorageDevice class]]) {
        cell.textField.stringValue = @"USB Mass Storage";
    } else {
        abort();
    }
    
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([notification.object isEqual:self.tableView]) {
        [self _tableViewSelectionDidChange];
    }
}

- (void)menuWillOpen:(NSMenu *)menu {
    [menu removeAllItems];
    
    NSInteger clickedRow = self.tableView.clickedRow;
    if ((clickedRow == NSNotFound) or (clickedRow == -1)) return;
    
    NSMenuItem *detachItem = [NSMenuItem new];
    detachItem.title = @"Detach";
    detachItem.image = [NSImage imageWithSystemSymbolName:@"eject.fill" accessibilityDescription:nil];
    detachItem.target = self;
    detachItem.action = @selector(_didTriggerDetachItem:);
    detachItem.enabled = (self.delegate != nil);
    [menu addItem:detachItem];
    [detachItem release];
}

- (void)_didTriggerDetachItem:(NSMenuItem *)sender {
    NSInteger clickedRow = self.tableView.clickedRow;
    assert((clickedRow != NSNotFound) and (clickedRow != -1));
    
    id<VZUSBDevice> device = self.usbDevices[clickedRow];
    
    if (auto delegate = self.delegate) {
        [delegate editMachineUSBDevicesTableViewController:self detachUSBDevice:device];
    }
}

@end
