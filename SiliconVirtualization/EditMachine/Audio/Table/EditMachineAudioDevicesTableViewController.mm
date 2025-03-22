//
//  EditMachineAudioDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineAudioDevicesTableViewController.h"
#import "EditMachineAudioDevicesTableCellView.h"

@interface EditMachineAudioDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineAudioDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineAudioDevicesTableCellView class]);
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

- (void)setAudioDevices:(NSArray<__kindof VZAudioDeviceConfiguration *> *)audioDevices {
    [_audioDevices release];
    _audioDevices = [audioDevices copy];
    
    [self _didChangeAudioDevices];
}

- (void)_didChangeAudioDevices {
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
    [delegate editMachineAudioDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineAudioDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineAudioDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineAudioDevicesTableViewController.cellItemIdentifier];
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
    
    NSMenuItem *virtioItem = [NSMenuItem new];
    virtioItem.title = @"Virtio";
    virtioItem.target = self;
    virtioItem.action = @selector(_didTriggerVirtioItem:);
    [menu addItem:virtioItem];
    [virtioItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerVirtioItem:(NSMenuItem *)sender {
    VZVirtioSoundDeviceConfiguration *configuration = [[VZVirtioSoundDeviceConfiguration alloc] init];
    
    NSArray<__kindof VZAudioDeviceConfiguration *> *audioDevices = self.audioDevices;
    if (audioDevices == nil) {
        audioDevices = @[configuration];
    } else {
        audioDevices = [audioDevices arrayByAddingObject:configuration];
    }
    [configuration release];
    
    self.audioDevices = audioDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesTableViewController:self didUpdateAudioDevices:audioDevices];
    }
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.audioDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineAudioDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineAudioDevicesTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZAudioDeviceConfiguration *configuration = self.audioDevices[row];
    
    if ([configuration isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]) {
        cell.textField.stringValue = @"Virtio Sound Device";
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
    
    NSMutableArray<__kindof VZAudioDeviceConfiguration *> *audioDevices = [self.audioDevices mutableCopy];
    [audioDevices removeObjectAtIndex:clickedRow];
    
    self.audioDevices = audioDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesTableViewController:self didUpdateAudioDevices:audioDevices];
    }
    
    [audioDevices release];
}

@end
