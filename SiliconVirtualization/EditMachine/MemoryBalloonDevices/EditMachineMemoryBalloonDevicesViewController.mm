//
//  EditMachineMemoryBalloonDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineMemoryBalloonDevicesViewController.h"
#import "EditMachineMemoryBalloonDevicesTableViewController.h"

@interface EditMachineMemoryBalloonDevicesViewController () <EditMachineMemoryBalloonDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableViewController) EditMachineMemoryBalloonDevicesTableViewController *memoryBalloonDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableSplitViewItem) NSSplitViewItem *memoryBalloonDevicesTableSplitViewItem;
@end

@implementation EditMachineMemoryBalloonDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize memoryBalloonDevicesTableViewController = _memoryBalloonDevicesTableViewController;
@synthesize memoryBalloonDevicesTableSplitViewItem = _memoryBalloonDevicesTableSplitViewItem;

- (void)dealloc {
    [_memoryBalloonDevices release];
    [_splitViewController release];
    [_memoryBalloonDevicesTableViewController release];
    [_memoryBalloonDevicesTableSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    
    [self _didChangeConfiguration];
}

- (void)setMemoryBalloonDevices:(NSArray<__kindof VZMemoryBalloonDevice *> *)memoryBalloonDevices {
    [_memoryBalloonDevices release];
    _memoryBalloonDevices = [memoryBalloonDevices copy];
    
    self.memoryBalloonDevicesTableViewController.memoryBalloonDevices = memoryBalloonDevices;
}

- (void)_didChangeConfiguration {
    self.memoryBalloonDevicesTableViewController.memoryBalloonDevices = self.memoryBalloonDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.memoryBalloonDevicesTableSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineMemoryBalloonDevicesTableViewController *)_memoryBalloonDevicesTableViewController {
    if (auto memoryBalloonDevicesTableViewController = _memoryBalloonDevicesTableViewController) return memoryBalloonDevicesTableViewController;
    
    EditMachineMemoryBalloonDevicesTableViewController *memoryBalloonDevicesTableViewController = [EditMachineMemoryBalloonDevicesTableViewController new];
    memoryBalloonDevicesTableViewController.delegate = self;
    
    _memoryBalloonDevicesTableViewController = memoryBalloonDevicesTableViewController;
    return memoryBalloonDevicesTableViewController;
}

- (NSSplitViewItem *)_memoryBalloonDevicesTableSplitViewItem {
    if (auto memoryBalloonDevicesTableSplitViewItem = _memoryBalloonDevicesTableSplitViewItem) return memoryBalloonDevicesTableSplitViewItem;
    
    NSSplitViewItem *memoryBalloonDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.memoryBalloonDevicesTableViewController];
    
    _memoryBalloonDevicesTableSplitViewItem = [memoryBalloonDevicesTableSplitViewItem retain];
    return memoryBalloonDevicesTableSplitViewItem;
}

- (void)editMachineMemoryBalloonDevicesTableViewController:(EditMachineMemoryBalloonDevicesTableViewController *)editMachineMemoryBalloonDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    
}

@end
