//
//  EditMachineVirtioSoundDeviceStreamsTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineVirtioSoundDeviceStreamsTableViewController.h"
#import "EditMachineVirtioSoundDeviceStreamsTableCellView.h"

@interface EditMachineVirtioSoundDeviceStreamsTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineVirtioSoundDeviceStreamsTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineVirtioSoundDeviceStreamsTableCellView class]);
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
}

- (void)setStreams:(NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *)streams {
    [_streams release];
    _streams = [streams copy];
    
    [self _didChangeStreams];
}

- (void)_didChangeStreams {
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
    [delegate editMachineVirtioSoundDeviceStreamsViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineVirtioSoundDeviceStreamsTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineVirtioSoundDeviceStreamsTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineVirtioSoundDeviceStreamsTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *outputItem = [NSMenuItem new];
    outputItem.title = @"Output";
    outputItem.target = self;
    outputItem.action = @selector(_didTriggerOutputItem:);
    [menu addItem:outputItem];
    [outputItem release];
    
    NSMenuItem *inputItem = [NSMenuItem new];
    inputItem.title = @"Input";
    inputItem.target = self;
    inputItem.action = @selector(_didTriggerInputItem:);
    [menu addItem:inputItem];
    [inputItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerOutputItem:(NSMenuItem *)sender {
    VZVirtioSoundDeviceOutputStreamConfiguration *configuration = [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
    
    NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams = self.streams;
    if (streams == nil) {
        streams = @[configuration];
    } else {
        streams = [streams arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.streams = streams;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioSoundDeviceStreamsViewController:self didUpdateStreams:streams];
    }
}

- (void)_didTriggerInputItem:(NSMenuItem *)sender {
    VZVirtioSoundDeviceInputStreamConfiguration *configuration = [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
    
    NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams = self.streams;
    if (streams == nil) {
        streams = @[configuration];
    } else {
        streams = [streams arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.streams = streams;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioSoundDeviceStreamsViewController:self didUpdateStreams:streams];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.streams.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineVirtioSoundDeviceStreamsTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineVirtioSoundDeviceStreamsTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZVirtioSoundDeviceStreamConfiguration *configuration = self.streams[row];
    
    if ([configuration isKindOfClass:[VZVirtioSoundDeviceOutputStreamConfiguration class]]) {
        cell.textField.stringValue = @"Output";
    } else if ([configuration isKindOfClass:[VZVirtioSoundDeviceInputStreamConfiguration class]]) {
        cell.textField.stringValue = @"Input";
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
    
    NSMutableArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams = [self.streams mutableCopy];
    [streams removeObjectAtIndex:clickedRow];
    
    self.streams = streams;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioSoundDeviceStreamsViewController:self didUpdateStreams:streams];
    }
    
    [streams release];
}

@end
