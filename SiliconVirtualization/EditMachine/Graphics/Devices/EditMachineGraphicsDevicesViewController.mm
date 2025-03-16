//
//  EditMachineGraphicsDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineGraphicsDevicesViewController.h"
#import "EditMachineGraphicsDevicesCellView.h"

@interface EditMachineGraphicsDevicesViewController () <NSTableViewDataSource, NSTableViewDelegate>
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
    [_tableView release];
    [_graphicsDevices release];
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
    
    [self _didChangeDelegate];
}

- (void)setGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    [_graphicsDevices release];
    _graphicsDevices = [graphicsDevices copy];
    
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
}

- (void)setDelegate:(id<EditMachineGraphicsDevicesViewControllerDelegate>)delegate {
    _delegate = delegate;
    [self _didChangeDelegate];
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsEmptySelection = YES;
    tableView.style = NSTableViewStyleFullWidth;
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineGraphicsDevicesCellView class]) bundle:[NSBundle bundleForClass:[self class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineGraphicsDevicesViewController.cellIdentifier];
    [cellNib release];
    
    NSTableColumn *typeColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    typeColumn.title = @"Type";
    [tableView addTableColumn:typeColumn];
    [typeColumn release];
    
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

- (void)_didChangeDelegate {
    self.createButton.hidden = (self.delegate == nil);
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
    [delegate editMachineGraphicsDevicesViewController:self didUpdateGraphicsDevices:graphicsDevices];
    [configuration release];
}

- (void)_didTriggerVirtioItem:(NSMenuItem *)sender {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    VZVirtioGraphicsDeviceConfiguration *configuration = [[VZVirtioGraphicsDeviceConfiguration alloc] init];
    NSArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [self.graphicsDevices arrayByAddingObject:configuration];
    self.graphicsDevices = graphicsDevices;
    [delegate editMachineGraphicsDevicesViewController:self didUpdateGraphicsDevices:graphicsDevices];
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
        auto delegate = self.delegate;
        if (delegate == nil) return;
        
        NSInteger selectedRow = self.tableView.selectedRow;
        [delegate editMachineGraphicsDevicesViewController:self didSelectAtIndex:selectedRow];
    }
}

@end
