//
//  EditMachineDirectorySharingDevicesTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import "EditMachineDirectorySharingDevicesTableViewController.h"
#import "EditMachineDirectorySharingDevicesTableCellView.h"

@interface EditMachineDirectorySharingDevicesTableViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@end

@implementation EditMachineDirectorySharingDevicesTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineDirectorySharingDevicesTableCellView class]);
}

- (void)dealloc {
    [_directorySharingDevices release];
    [_scrollView release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
}

- (void)setDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDevice *> *)directorySharingDevices {
    [_directorySharingDevices release];
    _directorySharingDevices = [directorySharingDevices copy];
    
    [self _didChangeDirectorySharingDevices];
}

- (void)_didChangeDirectorySharingDevices {
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
    [delegate editMachineDirectorySharingDevicesTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineDirectorySharingDevicesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineDirectorySharingDevicesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineDirectorySharingDevicesTableViewController.cellItemIdentifier];
    [cellNib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
    tableView.allowsEmptySelection = YES;
    tableView.allowsMultipleSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    _tableView = tableView;
    return tableView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.directorySharingDevices.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineDirectorySharingDevicesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineDirectorySharingDevicesTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZDirectorySharingDevice *directorySharingDevice = self.directorySharingDevices[row];
    
    if ([directorySharingDevice isKindOfClass:[VZVirtioFileSystemDevice class]]) {
        cell.textField.stringValue = @"Virtio File System Device";
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

@end
