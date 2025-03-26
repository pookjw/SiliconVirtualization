//
//  EditMachineConfigurationUSBDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineConfigurationUSBDevicesTableViewController.h"
#import "EditMachineConfigurationUSBDevicesTableCellView.h"
#import "DiskBlockDeviceStorageDeviceAttachmentConfigurationView.h"

@interface EditMachineConfigurationUSBDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineConfigurationUSBDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineConfigurationUSBDevicesTableCellView class]);
}

- (void)dealloc {
    [_usbDevices release];
    [_scrollView release];
    [_tableView release];
    [_createButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
    
    NSButton *createButton = self.createButton;
    createButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:createButton];
    [NSLayoutConstraint activateConstraints:@[
        [createButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [createButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
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
    [delegate editMachineConfigurationUSBDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineConfigurationUSBDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineConfigurationUSBDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineConfigurationUSBDevicesTableViewController.cellItemIdentifier];
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

- (NSButton *)_createButton {
    if (auto createButton = _createButton) return createButton;
    
    NSButton *createButton = [NSButton new];
    createButton.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    createButton.target = self;
    createButton.action = @selector(_didTriggerCreateButton:);
    
    _createButton = createButton;
    return createButton;
}

- (void)_didTriggerCreateButton:(NSButton *)sender {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *usbMassStorageItem = [NSMenuItem new];
    usbMassStorageItem.title = @"USB Mass Storage";
    usbMassStorageItem.target = self;
    usbMassStorageItem.action = @selector(_didTriggerUSBMassStorageItem:);
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
            
            NSArray<id<VZUSBDeviceConfiguration>> *usbDevices = self.usbDevices;
            if (usbDevices == nil) {
                usbDevices = @[configuration];
            } else {
                usbDevices = [usbDevices arrayByAddingObject:configuration];
            }
            [configuration release];
            
            self.usbDevices = usbDevices;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineConfigurationUSBDevicesTableViewController:self didUpdateUSBDevices:usbDevices];
            }
        }
    }];
    
    [accessoryView release];
    [alert release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.usbDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineConfigurationUSBDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineConfigurationUSBDevicesTableViewController.cellItemIdentifier owner:nil];
    
    id<VZUSBDeviceConfiguration> configuration = self.usbDevices[row];
    
    if ([configuration isKindOfClass:[VZUSBMassStorageDeviceConfiguration class]]) {
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
    
    NSMenuItem *deleteItem = [NSMenuItem new];
    deleteItem.title = @"Delete";
    deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash.fill" accessibilityDescription:nil];
    deleteItem.target = self;
    deleteItem.action = @selector(_didTriggerDeleteItem:);
    [menu addItem:deleteItem];
    [deleteItem release];
}

- (void)_didTriggerDeleteItem:(NSMenuItem *)sender {
    NSInteger clickedRow = self.tableView.clickedRow;
    assert((clickedRow != NSNotFound) and (clickedRow != -1));
    
    NSMutableArray<id<VZUSBDeviceConfiguration>> *usbDevices = [self.usbDevices mutableCopy];
    [usbDevices removeObjectAtIndex:clickedRow];
    
    self.usbDevices = usbDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationUSBDevicesTableViewController:self didUpdateUSBDevices:usbDevices];
    }
    
    [usbDevices release];
}

@end
