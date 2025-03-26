//
//  EditMachineMemoryBalloonDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineMemoryBalloonDevicesViewController.h"
#import "EditMachineMemoryBalloonDevicesTableViewController.h"
#import "EditMachineVirtioTraditionalMemoryBalloonDeviceViewController.h"

@interface EditMachineMemoryBalloonDevicesViewController () <EditMachineMemoryBalloonDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableViewController) EditMachineMemoryBalloonDevicesTableViewController *memoryBalloonDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesTableSplitViewItem) NSSplitViewItem *memoryBalloonDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioTraditionalMemoryBalloonDeviceViewController) EditMachineVirtioTraditionalMemoryBalloonDeviceViewController *virtioTraditionalMemoryBalloonDeviceViewController;
@property (retain, nonatomic, readonly, getter=_virtioTraditionalMemoryBalloonDeviceSplitViewItem) NSSplitViewItem *virtioTraditionalMemoryBalloonDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyDeviceViewController) NSViewController *emptyDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyDeviceSplitViewItem) NSSplitViewItem *emptyDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedDeviceIndex, setter=_setSelectedDeviceIndex:) NSInteger selectedDeviceIndex;
@end

@implementation EditMachineMemoryBalloonDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize memoryBalloonDevicesTableViewController = _memoryBalloonDevicesTableViewController;
@synthesize memoryBalloonDevicesTableSplitViewItem = _memoryBalloonDevicesTableSplitViewItem;
@synthesize virtioTraditionalMemoryBalloonDeviceViewController = _virtioTraditionalMemoryBalloonDeviceViewController;
@synthesize virtioTraditionalMemoryBalloonDeviceSplitViewItem = _virtioTraditionalMemoryBalloonDeviceSplitViewItem;
@synthesize emptyDeviceViewController = _emptyDeviceViewController;
@synthesize emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_memoryBalloonDevices release];
    [_splitViewController release];
    [_memoryBalloonDevicesTableViewController release];
    [_memoryBalloonDevicesTableSplitViewItem release];
    [_virtioTraditionalMemoryBalloonDeviceViewController release];
    [_virtioTraditionalMemoryBalloonDeviceSplitViewItem release];
    [_emptyDeviceViewController release];
    [_emptyDeviceSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    
    [self _didChangeMemoryBalloonDevices];
}

- (void)setMemoryBalloonDevices:(NSArray<__kindof VZMemoryBalloonDevice *> *)memoryBalloonDevices {
    [_memoryBalloonDevices release];
    _memoryBalloonDevices = [memoryBalloonDevices copy];
    
    [self _didChangeMemoryBalloonDevices];
}

- (void)_didChangeMemoryBalloonDevices {
    self.memoryBalloonDevicesTableViewController.memoryBalloonDevices = self.memoryBalloonDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.memoryBalloonDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
    
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

- (EditMachineVirtioTraditionalMemoryBalloonDeviceViewController *)_virtioTraditionalMemoryBalloonDeviceViewController {
    if (auto virtioTraditionalMemoryBalloonDeviceViewController = _virtioTraditionalMemoryBalloonDeviceViewController) return virtioTraditionalMemoryBalloonDeviceViewController;
    
    EditMachineVirtioTraditionalMemoryBalloonDeviceViewController *virtioTraditionalMemoryBalloonDeviceViewController = [EditMachineVirtioTraditionalMemoryBalloonDeviceViewController new];
    
    _virtioTraditionalMemoryBalloonDeviceViewController = virtioTraditionalMemoryBalloonDeviceViewController;
    return virtioTraditionalMemoryBalloonDeviceViewController;
}

- (NSSplitViewItem *)_virtioTraditionalMemoryBalloonDeviceSplitViewItem {
    if (auto virtioTraditionalMemoryBalloonDeviceSplitViewItem = _virtioTraditionalMemoryBalloonDeviceSplitViewItem) return virtioTraditionalMemoryBalloonDeviceSplitViewItem;
    
    NSSplitViewItem *virtioTraditionalMemoryBalloonDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.virtioTraditionalMemoryBalloonDeviceViewController];
    
    _virtioTraditionalMemoryBalloonDeviceSplitViewItem = [virtioTraditionalMemoryBalloonDeviceSplitViewItem retain];
    return virtioTraditionalMemoryBalloonDeviceSplitViewItem;
}

- (NSViewController *)_emptyDeviceViewController {
    if (auto emptyDeviceViewController = _emptyDeviceViewController) return emptyDeviceViewController;
    
    NSViewController *emptyDeviceViewController = [NSViewController new];
    
    _emptyDeviceViewController = emptyDeviceViewController;
    return emptyDeviceViewController;
}

- (NSSplitViewItem *)_emptyDeviceSplitViewItem {
    if (auto emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem) return emptyDeviceSplitViewItem;
    
    NSSplitViewItem *emptyDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyDeviceViewController];
    
    _emptyDeviceSplitViewItem = [emptyDeviceSplitViewItem retain];
    return emptyDeviceSplitViewItem;
}

- (void)editMachineMemoryBalloonDevicesTableViewController:(EditMachineMemoryBalloonDevicesTableViewController *)editMachineMemoryBalloonDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.memoryBalloonDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
        return;
    }
    
    __kindof VZMemoryBalloonDevice *configuration = self.memoryBalloonDevices[selectedIndex];
    
    if ([configuration isKindOfClass:[VZVirtioTraditionalMemoryBalloonDevice class]]) {
        auto casted = static_cast<VZVirtioTraditionalMemoryBalloonDevice *>(configuration);
        self.virtioTraditionalMemoryBalloonDeviceViewController.virtioTraditionalMemoryBalloonDevice = casted;
        self.splitViewController.splitViewItems = @[self.memoryBalloonDevicesTableSplitViewItem, self.virtioTraditionalMemoryBalloonDeviceSplitViewItem];
    } else {
        abort();
    }
}

@end
