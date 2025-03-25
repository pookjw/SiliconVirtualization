//
//  EditMachineKeyboardsTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "EditMachineKeyboardsTableViewController.h"
#import "EditMachineKeyboardsTableCellView.h"

@interface EditMachineKeyboardsTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineKeyboardsTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineKeyboardsTableCellView class]);
}

- (void)dealloc {
    [_keyboards release];
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

- (void)setKeyboards:(NSArray<__kindof VZKeyboardConfiguration *> *)keyboards {
    [_keyboards release];
    _keyboards = [keyboards copy];
    
    [self _didChangeKeyboards];
}

- (void)_didChangeKeyboards {
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    
    if (tableView.numberOfRows > 0) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    }
    
    [self _tableViewSelectionDidChange];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineKeyboardsTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineKeyboardsTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineKeyboardsTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *USBItem = [NSMenuItem new];
    USBItem.title = @"USB Keyboard";
    USBItem.target = self;
    USBItem.action = @selector(_didTriggerUSBItem:);
    [menu addItem:USBItem];
    [USBItem release];
    
    NSMenuItem *macItem = [NSMenuItem new];
    macItem.title = @"Mac Keyboard";
    macItem.target = self;
    macItem.action = @selector(_didTriggerMacItem:);
    [menu addItem:macItem];
    [macItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerUSBItem:(NSMenuItem *)sender {
    VZUSBKeyboardConfiguration *USBKeyboardConfiguration = [[VZUSBKeyboardConfiguration alloc] init];
    
    NSArray<__kindof VZKeyboardConfiguration *> *keyboards = self.keyboards;
    if (keyboards == nil) {
        keyboards = @[USBKeyboardConfiguration];
    } else {
        keyboards = [keyboards arrayByAddingObject:USBKeyboardConfiguration];
    }
    [USBKeyboardConfiguration release];
    
    self.keyboards = keyboards;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineKeyboardsTableViewController:self didUpdateKeyboards:keyboards];
    }
}

- (void)_didTriggerMacItem:(NSMenuItem *)sender {
    VZMacKeyboardConfiguration *macKeyboardConfiguration = [[VZMacKeyboardConfiguration alloc] init];
    
    NSArray<__kindof VZKeyboardConfiguration *> *keyboards = self.keyboards;
    if (keyboards == nil) {
        keyboards = @[macKeyboardConfiguration];
    } else {
        keyboards = [keyboards arrayByAddingObject:macKeyboardConfiguration];
    }
    [macKeyboardConfiguration release];
    
    self.keyboards = keyboards;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineKeyboardsTableViewController:self didUpdateKeyboards:keyboards];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.keyboards.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineKeyboardsTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineKeyboardsTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZKeyboardConfiguration *keyboardConfiguration = self.keyboards[row];
    
    if ([keyboardConfiguration isKindOfClass:[VZUSBKeyboardConfiguration class]]) {
        cell.textField.stringValue = @"USB Keyboard";
    } else if ([keyboardConfiguration isKindOfClass:[VZMacKeyboardConfiguration class]]) {
        cell.textField.stringValue = @"Mac Keyboard";
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

- (void)_tableViewSelectionDidChange {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    NSInteger selectedRow = self.tableView.selectedRow;
    [delegate editMachineKeyboardsTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSMutableArray<__kindof VZKeyboardConfiguration *> *keyboards = [self.keyboards mutableCopy];
    [keyboards removeObjectAtIndex:clickedRow];
    
    self.keyboards = keyboards;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineKeyboardsTableViewController:self didUpdateKeyboards:keyboards];
    }
    
    [keyboards release];
}

@end
