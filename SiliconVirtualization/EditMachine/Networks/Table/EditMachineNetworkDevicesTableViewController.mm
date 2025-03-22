//
//  EditMachineNetworkDevicesTableViewController.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineNetworkDevicesTableViewController.h"
#import "EditMachineNetworkDevicesTableCellView.h"

@interface EditMachineNetworkDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineNetworkDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineNetworkDevicesTableCellView class]);
}

- (void)dealloc {
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
    
    [self _didChangeNetworkDevices];
}

- (void)setNetworkDevices:(NSArray<__kindof VZNetworkDeviceConfiguration *> *)networkDevices {
    [_networkDevices release];
    _networkDevices = [networkDevices copy];
    
    [self _didChangeNetworkDevices];
}

- (void)_didChangeNetworkDevices {
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
    [delegate editMachineNetworkDevicesViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineNetworkDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineNetworkDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineNetworkDevicesTableViewController.cellItemIdentifier];
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
    VZVirtioNetworkDeviceConfiguration *configuration = [[VZVirtioNetworkDeviceConfiguration alloc] init];
    
    NSArray<__kindof VZNetworkDeviceConfiguration *> *networkDevices = self.networkDevices;
    if (networkDevices == nil) {
        networkDevices = @[configuration];
    } else {
        networkDevices = [networkDevices arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.networkDevices = networkDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineNetworkDevicesViewController:self didUpdateNetworkDevices:networkDevices];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.networkDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineNetworkDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineNetworkDevicesTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZNetworkDeviceConfiguration *configuration = self.networkDevices[row];
    
    if ([configuration isKindOfClass:[VZVirtioNetworkDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Virtio Network Device";
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
    
    NSMutableArray<__kindof VZNetworkDeviceConfiguration *> *networkDevices = [self.networkDevices mutableCopy];
    [networkDevices removeObjectAtIndex:clickedRow];
    
    self.networkDevices = networkDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineNetworkDevicesViewController:self didUpdateNetworkDevices:networkDevices];
    }
    
    [networkDevices release];
}

@end
