//
//  EditMachineGraphicsDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineGraphicsDevicesViewController.h"
#import "EditMachineGraphicsDevicesCellView.h"

@interface EditMachineGraphicsDevicesViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellIdentifier) NSUserInterfaceItemIdentifier cellIdentifier;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineGraphicsDevicesViewController
@synthesize tableView = _tableView;
@synthesize scrollView = _scrollView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellIdentifier {
    return NSStringFromClass([EditMachineGraphicsDevicesCellView class]);
}

- (instancetype)initWithGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _graphicsDevices = [graphicsDevices copy];
    }
    
    return self;
}

- (void)dealloc {
    [_graphicsDevices release];
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

- (void)setGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    [_graphicsDevices release];
    _graphicsDevices = [graphicsDevices copy];
    
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    
    if (tableView.numberOfRows > 0) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    }
    
    [self _tableViewSelectionDidChange];
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsEmptySelection = YES;
    tableView.style = NSTableViewStyleFullWidth;
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineGraphicsDevicesCellView class]) bundle:[NSBundle bundleForClass:[EditMachineGraphicsDevicesCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineGraphicsDevicesViewController.cellIdentifier];
    [cellNib release];
    
    NSTableColumn *typeColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    typeColumn.title = @"Type";
    [tableView addTableColumn:typeColumn];
    [typeColumn release];
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    tableView.menu = menu;
    [menu release];
    
    _tableView = tableView;
    return tableView;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    
    _scrollView = scrollView;
    return scrollView;
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
    [NSMenu popUpContextMenu:[self _makeCreateButtonMenu] withEvent:sender.window.currentEvent forView:sender];
}

- (NSMenu *)_makeCreateButtonMenu {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *macItem = [NSMenuItem new];
    macItem.title = @"Mac";
    macItem.image = [NSImage imageWithSystemSymbolName:@"apple.logo" accessibilityDescription:nil];
    macItem.target = self;
    macItem.action = @selector(_didTriggerMacItem:);
    [menu addItem:macItem];
    [macItem release];
    
    NSMenuItem *virtioItem = [NSMenuItem new];
    virtioItem.title = @"Virtio (Linux)";
    virtioItem.image = [NSImage imageWithSystemSymbolName:@"ellipsis" accessibilityDescription:nil];
    virtioItem.target = self;
    virtioItem.action = @selector(_didTriggerVirtioItem:);
    [menu addItem:virtioItem];
    [virtioItem release];
    
    return [menu autorelease];
}

- (void)_didTriggerMacItem:(NSMenuItem *)sender {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    VZMacGraphicsDeviceConfiguration *configuration = [[VZMacGraphicsDeviceConfiguration alloc] init];
    NSArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [self.graphicsDevices arrayByAddingObject:configuration];
    self.graphicsDevices = graphicsDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsDevicesViewController:self didUpdateGraphicsDevices:graphicsDevices];
    }
    
    [configuration release];
}

- (void)_didTriggerVirtioItem:(NSMenuItem *)sender {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    VZVirtioGraphicsDeviceConfiguration *configuration = [[VZVirtioGraphicsDeviceConfiguration alloc] init];
    NSArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [self.graphicsDevices arrayByAddingObject:configuration];
    self.graphicsDevices = graphicsDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsDevicesViewController:self didUpdateGraphicsDevices:graphicsDevices];
    }
    
    [configuration release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.graphicsDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineGraphicsDevicesCellView *cell = [tableView makeViewWithIdentifier:EditMachineGraphicsDevicesViewController.cellIdentifier owner:nil];
    
    __kindof VZGraphicsDeviceConfiguration *graphicsDeviceConfiguration = self.graphicsDevices[row];
    
    if ([graphicsDeviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Mac";
    } else if ([graphicsDeviceConfiguration isKindOfClass:[VZVirtioGraphicsDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Virtio";
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
    [delegate editMachineGraphicsDevicesViewController:self didSelectAtIndex:selectedRow];
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
    
    NSMutableArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [self.graphicsDevices mutableCopy];
    [graphicsDevices removeObjectAtIndex:clickedRow];
    
    self.graphicsDevices = graphicsDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsDevicesViewController:self didUpdateGraphicsDevices:graphicsDevices];
    }
    
    [graphicsDevices release];
}

@end
