//
//  EditMachineBiometricDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineBiometricDevicesTableViewController.h"
#import "EditMachineBiometricDevicesTableCellView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineBiometricDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineBiometricDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineBiometricDevicesTableCellView class]);
}

- (void)dealloc {
    [_biometricDevices release];
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

- (void)setBiometricDevices:(NSArray *)biometricDevices {
    [_biometricDevices release];
    _biometricDevices = [biometricDevices copy];
    
    [self _didChangeBiometricDevices];
}

- (void)_didChangeBiometricDevices {
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
    [delegate editMachineBiometricDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineBiometricDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineBiometricDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineBiometricDevicesTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *macTouchIDItem = [NSMenuItem new];
    macTouchIDItem.title = @"Mac Touch ID";
    macTouchIDItem.target = self;
    macTouchIDItem.action = @selector(_didTriggerMacTouchIDItem:);
    [menu addItem:macTouchIDItem];
    [macTouchIDItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerMacTouchIDItem:(NSMenuItem *)sender {
    id configuration = [objc_lookUpClass("_VZMacTouchIDDeviceConfiguration") new];
    
    NSArray *biometricDevices = self.biometricDevices;
    if (biometricDevices == nil) {
        biometricDevices = @[configuration];
    } else {
        biometricDevices = [biometricDevices arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.biometricDevices = biometricDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesTableViewController:self didUpdateBiometricDevices:biometricDevices];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.biometricDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineBiometricDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineBiometricDevicesTableViewController.cellItemIdentifier owner:nil];
    
    id configuration = self.biometricDevices[row];
    
    if ([configuration isKindOfClass:objc_lookUpClass("_VZMacTouchIDDeviceConfiguration")]) {
        cell.textField.stringValue = @"Mac Touch ID Device";
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
    
    NSMutableArray *biometricDevices = [self.biometricDevices mutableCopy];
    [biometricDevices removeObjectAtIndex:clickedRow];
    
    self.biometricDevices = biometricDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesTableViewController:self didUpdateBiometricDevices:biometricDevices];
    }
    
    [biometricDevices release];
}

@end
