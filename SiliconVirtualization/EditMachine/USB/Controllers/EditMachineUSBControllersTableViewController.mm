//
//  EditMachineUSBControllersTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineUSBControllersTableViewController.h"
#import "EditMachineUSBControllersTableCellView.h"

@interface EditMachineUSBControllersTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineUSBControllersTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineUSBControllersTableCellView class]);
}

- (void)dealloc {
    [_usbControllers release];
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

- (void)setUSBControllers:(NSArray<__kindof VZUSBControllerConfiguration *> *)usbControllers {
    [_usbControllers release];
    _usbControllers = [usbControllers copy];
    
    [self _didChangeUSBControllers];
}

- (void)_didChangeUSBControllers {
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
    [delegate editMachineUSBControllersTableViewControllerDelegate:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineUSBControllersTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineUSBControllersTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineUSBControllersTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *XHCIItem = [NSMenuItem new];
    XHCIItem.title = @"XHCI Controller";
    XHCIItem.target = self;
    XHCIItem.action = @selector(_didTriggerXHCIItem:);
    [menu addItem:XHCIItem];
    [XHCIItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerXHCIItem:(NSMenuItem *)sender {
    VZXHCIControllerConfiguration *configuration = [[VZXHCIControllerConfiguration alloc] init];
    
    NSArray<__kindof VZUSBControllerConfiguration *> *usbControllers = self.usbControllers;
    if (usbControllers == nil) {
        usbControllers = @[configuration];
    } else {
        usbControllers = [usbControllers arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.usbControllers = usbControllers;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineUSBControllersTableViewControllerDelegate:self didUpdateUSBControllers:usbControllers];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.usbControllers.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineUSBControllersTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineUSBControllersTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZUSBControllerConfiguration *configuration = self.usbControllers[row];
    
    if ([configuration isKindOfClass:[VZXHCIControllerConfiguration class]]) {
        cell.textField.stringValue = @"XHCI";
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
    
    NSMutableArray<__kindof VZUSBControllerConfiguration *> *usbControllers = [self.usbControllers mutableCopy];
    [usbControllers removeObjectAtIndex:clickedRow];
    
    self.usbControllers = usbControllers;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineUSBControllersTableViewControllerDelegate:self didUpdateUSBControllers:usbControllers];
    }
    
    [usbControllers release];
}

@end
