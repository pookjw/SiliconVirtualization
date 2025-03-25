//
//  EditMachineConfigurationMemoryBalloonDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineConfigurationMemoryBalloonDevicesTableViewController.h"
#import "EditMachineConfigurationMemoryBalloonDevicesTableCellView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface EditMachineConfigurationMemoryBalloonDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineConfigurationMemoryBalloonDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineConfigurationMemoryBalloonDevicesTableCellView class]);
}

- (void)dealloc {
    [_memoryBalloonDevices release];
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

- (void)setMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices {
    [_memoryBalloonDevices release];
    _memoryBalloonDevices = [memoryBalloonDevices copy];
    
    [self _didChangeMemoryBalloonDevices];
}

- (void)_didChangeMemoryBalloonDevices {
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
    [delegate editMachineConfigurationMemoryBalloonDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineConfigurationMemoryBalloonDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineConfigurationMemoryBalloonDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineConfigurationMemoryBalloonDevicesTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *virtioTraditionalMemoryBalloonDeviceItem = [NSMenuItem new];
    virtioTraditionalMemoryBalloonDeviceItem.title = @"Virtio Traditional Memory Balloon";
    virtioTraditionalMemoryBalloonDeviceItem.target = self;
    virtioTraditionalMemoryBalloonDeviceItem.action = @selector(_didTriggerVirtioTraditionalMemoryBalloonItem:);
    [menu addItem:virtioTraditionalMemoryBalloonDeviceItem];
    [virtioTraditionalMemoryBalloonDeviceItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerVirtioTraditionalMemoryBalloonItem:(NSMenuItem *)sender {
    VZVirtioTraditionalMemoryBalloonDeviceConfiguration *configuration = [[VZVirtioTraditionalMemoryBalloonDeviceConfiguration alloc] init];
    NSArray<VZMemoryBalloonDeviceConfiguration *> *memoryBalloonDevices = [self.memoryBalloonDevices arrayByAddingObject:configuration];
    [configuration release];
    
    self.memoryBalloonDevices = memoryBalloonDevices;
    
    if (auto delegate = self.delegate) {
        [self.delegate editMachineConfigurationMemoryBalloonDevicesTableViewController:self didUpateMemoryBalloonDevices:memoryBalloonDevices];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.memoryBalloonDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineConfigurationMemoryBalloonDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineConfigurationMemoryBalloonDevicesTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZMemoryBalloonDeviceConfiguration *configuration = self.memoryBalloonDevices[row];
    
    if ([configuration isKindOfClass:[VZVirtioTraditionalMemoryBalloonDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Virtio Traditional Memory Balloon";
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
    
    NSMutableArray<__kindof VZMemoryBalloonDeviceConfiguration *> *memoryBalloonDevices = [self.memoryBalloonDevices mutableCopy];
    [memoryBalloonDevices removeObjectAtIndex:clickedRow];
    
    self.memoryBalloonDevices = memoryBalloonDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationMemoryBalloonDevicesTableViewController:self didUpateMemoryBalloonDevices:memoryBalloonDevices];
    }
    
    [memoryBalloonDevices release];
}

@end
