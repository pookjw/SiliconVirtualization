//
//  EditMachineUSBControllersTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import "EditMachineUSBControllersTableViewController.h"
#import "EditMachineUSBControllersTableCellView.h"

@interface EditMachineUSBControllersTableViewController () <NSTableViewDataSource, NSTableViewDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@end

@implementation EditMachineUSBControllersTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineUSBControllersTableCellView class]);
}

- (void)dealloc {
    [_usbControllers release];
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

- (void)setUSBControllers:(NSArray<__kindof VZUSBController *> *)usbControllers {
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
    [delegate editMachineUSBControllersTableViewController:self didSelectAtIndex:selectedRow];
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
    
    _tableView = tableView;
    return tableView;
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.usbControllers.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineUSBControllersTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineUSBControllersTableViewController.cellItemIdentifier owner:nil];
    
    __kindof VZUSBController *usbControllers = self.usbControllers[row];
    
    if ([usbControllers isKindOfClass:[VZXHCIController class]]) {
        cell.textField.stringValue = @"XHCI Controller";
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
