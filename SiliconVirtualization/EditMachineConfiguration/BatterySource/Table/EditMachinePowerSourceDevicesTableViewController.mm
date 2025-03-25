//
//  EditMachinePowerSourceDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "EditMachinePowerSourceDevicesTableViewController.h"
#import "EditMachinePowerSourceDevicesTableCellView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface EditMachinePowerSourceDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachinePowerSourceDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachinePowerSourceDevicesTableCellView class]);
}

- (void)dealloc {
    [_powerSourceDevices release];
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

- (void)setPowerSourceDevices:(NSArray *)powerSourceDevices {
    [_powerSourceDevices release];
    _powerSourceDevices = [powerSourceDevices copy];
    
    [self _didChangePowerSourceDevices];
}

- (void)_didChangePowerSourceDevices {
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
    [delegate editMachinePowerSourceDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachinePowerSourceDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachinePowerSourceDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachinePowerSourceDevicesTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *macBatteryPowerSourceItem = [NSMenuItem new];
    macBatteryPowerSourceItem.title = @"Mac Battery Power Source";
    macBatteryPowerSourceItem.target = self;
    macBatteryPowerSourceItem.action = @selector(_didTriggerMacBatteryPowerSourceItem:);
    [menu addItem:macBatteryPowerSourceItem];
    [macBatteryPowerSourceItem release];
    
    NSMenuItem *macWallPowerSourceItem = [NSMenuItem new];
    macWallPowerSourceItem.title = @"Mac Wall Power Source";
    macWallPowerSourceItem.target = self;
    macWallPowerSourceItem.action = @selector(_didTriggerMacWallPowerSourceItem:);
    [menu addItem:macWallPowerSourceItem];
    [macWallPowerSourceItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerMacBatteryPowerSourceItem:(NSMenuItem *)sender {
    id macBatteryPowerSourceDeviceConfiguration = [objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration") new];
    NSArray *powerSourceDevices = [self.powerSourceDevices arrayByAddingObject:macBatteryPowerSourceDeviceConfiguration];
    [macBatteryPowerSourceDeviceConfiguration release];
    
    self.powerSourceDevices = powerSourceDevices;
    
    if (auto delegate = self.delegate) {
        [self.delegate editMachinePowerSourceDevicesTableViewController:self didUpdatePowerSourceDevices:powerSourceDevices];
    }
}

- (void)_didTriggerMacWallPowerSourceItem:(NSMenuItem *)sender {
    id macWallPowerSourceDeviceConfiguration = [objc_lookUpClass("_VZMacWallPowerSourceDeviceConfiguration") new];
    NSArray *powerSourceDevices = [self.powerSourceDevices arrayByAddingObject:macWallPowerSourceDeviceConfiguration];
    [macWallPowerSourceDeviceConfiguration release];
    
    self.powerSourceDevices = powerSourceDevices;
    
    if (auto delegate = self.delegate) {
        [self.delegate editMachinePowerSourceDevicesTableViewController:self didUpdatePowerSourceDevices:powerSourceDevices];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.powerSourceDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachinePowerSourceDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachinePowerSourceDevicesTableViewController.cellItemIdentifier owner:nil];
    
    id configuration = self.powerSourceDevices[row];
    
    if ([configuration isKindOfClass:objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration")]) {
        cell.textField.stringValue = @"Mac Battery Power Source";
    } else if ([configuration isKindOfClass:objc_lookUpClass("_VZMacWallPowerSourceDeviceConfiguration")]) {
        cell.textField.stringValue = @"Mac Wall Power Source";
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
    
    NSMutableArray *powerSourceDevices = [self.powerSourceDevices mutableCopy];
    [powerSourceDevices removeObjectAtIndex:clickedRow];
    
    self.powerSourceDevices = powerSourceDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePowerSourceDevicesTableViewController:self didUpdatePowerSourceDevices:powerSourceDevices];
    }
    
    [powerSourceDevices release];
}

@end
