//
//  EditMachineConfigurationMemoryBalloonDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineConfigurationMemoryBalloonDevicesViewController.h"
#import "EditMachineConfigurationMemoryBalloonDevicesTableViewController.h"

@interface EditMachineConfigurationMemoryBalloonDevicesViewController () <EditMachineConfigurationMemoryBalloonDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableViewController) EditMachineConfigurationMemoryBalloonDevicesTableViewController *memoryBalloonDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableSplitViewItem) NSSplitViewItem *memoryBalloonDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyMemoryBalloonDeviceViewController) NSViewController *emptyMemoryBalloonDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyMemoryBalloonDeviceSplitViewItem) NSSplitViewItem *emptyMemoryBalloonDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedMemoryBalloonDeviceIndex, setter=_setSelectedMemoryBalloonDeviceIndex:) NSInteger selectedMemoryBalloonDeviceIndex;
@end

@implementation EditMachineConfigurationMemoryBalloonDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize memoryBalloonDevicesTableViewController = _memoryBalloonDevicesTableViewController;
@synthesize memoryBalloonDevicesTableSplitViewItem = _memoryBalloonDevicesTableSplitViewItem;
@synthesize emptyMemoryBalloonDeviceViewController = _emptyMemoryBalloonDeviceViewController;
@synthesize emptyMemoryBalloonDeviceSplitViewItem = _emptyMemoryBalloonDeviceSplitViewItem;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedMemoryBalloonDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_memoryBalloonDevices release];
    [_splitViewController release];
    [_memoryBalloonDevicesTableViewController release];
    [_memoryBalloonDevicesTableSplitViewItem release];
    [_emptyMemoryBalloonDeviceViewController release];
    [_emptyMemoryBalloonDeviceSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
}

- (void)setMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices {
    [_memoryBalloonDevices release];
    _memoryBalloonDevices = [memoryBalloonDevices copy];
    
    self.memoryBalloonDevicesTableViewController.memoryBalloonDevices = memoryBalloonDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[
        self.memoryBalloonDevicesTableSplitViewItem,
        self.emptyMemoryBalloonDeviceSplitViewItem
    ];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineConfigurationMemoryBalloonDevicesTableViewController *)_memoryBalloonDevicesTableViewController {
    if (auto memoryBalloonDevicesTableViewController = _memoryBalloonDevicesTableViewController) return memoryBalloonDevicesTableViewController;
    
    EditMachineConfigurationMemoryBalloonDevicesTableViewController *memoryBalloonDevicesTableViewController = [EditMachineConfigurationMemoryBalloonDevicesTableViewController new];
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

- (NSViewController *)_emptyMemoryBalloonDeviceViewController {
    if (auto emptyMemoryBalloonDeviceViewController = _emptyMemoryBalloonDeviceViewController) return emptyMemoryBalloonDeviceViewController;
    
    NSViewController *emptyMemoryBalloonDeviceViewController = [NSViewController new];
    
    _emptyMemoryBalloonDeviceViewController = emptyMemoryBalloonDeviceViewController;
    return emptyMemoryBalloonDeviceViewController;
}

- (NSSplitViewItem *)_emptyMemoryBalloonDeviceSplitViewItem {
    if (auto emptyMemoryBalloonDeviceSplitViewItem = _emptyMemoryBalloonDeviceSplitViewItem) return emptyMemoryBalloonDeviceSplitViewItem;
    
    NSSplitViewItem *emptyMemoryBalloonDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyMemoryBalloonDeviceViewController];
    
    _emptyMemoryBalloonDeviceSplitViewItem = [emptyMemoryBalloonDeviceSplitViewItem retain];
    return emptyMemoryBalloonDeviceSplitViewItem;
}

- (void)editMachineConfigurationMemoryBalloonDevicesTableViewController:(EditMachineConfigurationMemoryBalloonDevicesTableViewController *)editMachineConfigurationMemoryBalloonDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedMemoryBalloonDeviceIndex = selectedIndex;
    
    if ((selectedIndex != NSNotFound) or (selectedIndex != -1)) {
        self.splitViewController.splitViewItems = @[self.memoryBalloonDevicesTableSplitViewItem, self.emptyMemoryBalloonDeviceSplitViewItem];
        return;
    }
}

- (void)editMachineConfigurationMemoryBalloonDevicesTableViewController:(EditMachineConfigurationMemoryBalloonDevicesTableViewController *)editMachineConfigurationMemoryBalloonDevicesTableViewController didUpateMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices {
    self.memoryBalloonDevices = memoryBalloonDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationMemoryBalloonDevicesViewController:self didUpateMemoryBalloonDevices:memoryBalloonDevices];
    }
}

@end
