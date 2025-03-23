//
//  EditMachineDirectorySharingDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineDirectorySharingDevicesTableViewController.h"
#import "EditMachineDirectorySharingDevicesTableCellView.h"
#import "EditMachineDirectorySharingDevicesTagView.h"

@interface EditMachineDirectorySharingDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;

@end

@implementation EditMachineDirectorySharingDevicesTableViewController

@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineDirectorySharingDevicesTableCellView class]);
}

- (void)dealloc {
    [_directorySharingDevices release];
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

- (void)setDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices {
    [_directorySharingDevices release];
    _directorySharingDevices = [directorySharingDevices copy];
    
    [self _didChangeDirectorySharingDevices];
}

- (void)_didChangeDirectorySharingDevices {
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
    [delegate editMachineDirectorySharingDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineDirectorySharingDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineDirectorySharingDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineDirectorySharingDevicesTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *virtioFileSystemItem = [NSMenuItem new];
    virtioFileSystemItem.title = @"Virtio File System Device";
    virtioFileSystemItem.target = self;
    virtioFileSystemItem.action = @selector(_didTriggerVirtioFileSystemItem:);
    [menu addItem:virtioFileSystemItem];
    [virtioFileSystemItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerVirtioFileSystemItem:(NSMenuItem *)sender {
    NSAlert *alert = [NSAlert new];
    
    alert.messageText = @"Tag";
    
    EditMachineDirectorySharingDevicesTagView *accessoryView = [EditMachineDirectorySharingDevicesTagView new];
    NSSize fittingSize = accessoryView.fittingSize;
    accessoryView.frame = NSMakeRect(0., 0., fittingSize.width, fittingSize.height);
    alert.accessoryView = accessoryView;
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        NSString *tag = accessoryView.deviceTag;
        if ([VZVirtioFileSystemDeviceConfiguration validateTag:tag error:NULL]) {
            NSMutableArray<__kindof VZDirectorySharingDeviceConfiguration *> *directorySharingDevices = [self.directorySharingDevices mutableCopy];
            
            VZVirtioFileSystemDeviceConfiguration *configuration = [[VZVirtioFileSystemDeviceConfiguration alloc] initWithTag:tag];
            [directorySharingDevices addObject:configuration];
            [configuration release];
            
            self.directorySharingDevices = directorySharingDevices;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineDirectorySharingDevicesTableViewController:self didUpdateDirectorySharingDevices:directorySharingDevices];
            }
            
            [directorySharingDevices release];
        }
    }];
    
    [accessoryView release];
    
    [alert release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.directorySharingDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineDirectorySharingDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineDirectorySharingDevicesTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZDirectorySharingDeviceConfiguration *configuration = self.directorySharingDevices[row];
    
    if ([configuration isKindOfClass:[VZVirtioFileSystemDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Virtio File System Device";
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
    
    NSMutableArray<__kindof VZDirectorySharingDeviceConfiguration *> *directorySharingDevices = [self.directorySharingDevices mutableCopy];
    [directorySharingDevices removeObjectAtIndex:clickedRow];
    
    self.directorySharingDevices = directorySharingDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineDirectorySharingDevicesTableViewController:self didUpdateDirectorySharingDevices:directorySharingDevices];
    }
    
    [directorySharingDevices release];
}

@end
