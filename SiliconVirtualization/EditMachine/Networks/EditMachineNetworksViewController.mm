//
//  EditMachineNetworksViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineNetworksViewController.h"
#import "EditMachineNetworkDevicesTableViewController.h"
#import "EditMachineNetworkDeviceViewController.h"

@interface EditMachineNetworksViewController () <EditMachineNetworkDevicesViewControllerDelegate, EditMachineNetworkDeviceViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_networkDevicesTableViewController) EditMachineNetworkDevicesTableViewController *networkDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_networkDevicesTableSplitViewItem) NSSplitViewItem *networkDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_networkDeviceViewController) EditMachineNetworkDeviceViewController *networkDeviceViewController;
@property (retain, nonatomic, readonly, getter=_networkDeviceSplitViewItem) NSSplitViewItem *networkDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyNetworkDeviceViewController) NSViewController *emptyNetworkDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyNetworkDeviceSplitViewItem) NSSplitViewItem *emptyNetworkDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedNetworkDeviceIndex, setter=_setSelectedNetworkDeviceIndex:) NSInteger selectedNetworkDeviceIndex;
@end

@implementation EditMachineNetworksViewController
@synthesize splitViewController = _splitViewController;
@synthesize networkDevicesTableViewController = _networkDevicesTableViewController;
@synthesize networkDevicesTableSplitViewItem = _networkDevicesTableSplitViewItem;
@synthesize networkDeviceViewController = _networkDeviceViewController;
@synthesize networkDeviceSplitViewItem = _networkDeviceSplitViewItem;
@synthesize emptyNetworkDeviceViewController = _emptyNetworkDeviceViewController;
@synthesize emptyNetworkDeviceSplitViewItem = _emptyNetworkDeviceSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _selectedNetworkDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_networkDevicesTableViewController release];
    [_networkDevicesTableSplitViewItem release];
    [_networkDeviceViewController release];
    [_networkDeviceSplitViewItem release];
    [_emptyNetworkDeviceViewController release];
    [_emptyNetworkDeviceSplitViewItem release];
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

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    self.networkDevicesTableViewController.networkDevices = self.configuration.networkDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.networkDevicesTableSplitViewItem, self.emptyNetworkDeviceSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineNetworkDevicesTableViewController *)_networkDevicesTableViewController {
    if (auto networkDevicesViewController = _networkDevicesTableViewController) return networkDevicesViewController;
    
    EditMachineNetworkDevicesTableViewController *networkDevicesViewController = [EditMachineNetworkDevicesTableViewController new];
    networkDevicesViewController.delegate = self;
    
    _networkDevicesTableViewController = networkDevicesViewController;
    return networkDevicesViewController;
}

- (NSSplitViewItem *)_networkDevicesTableSplitViewItem {
    if (auto networkDevicesSplitViewItem = _networkDevicesTableSplitViewItem) return networkDevicesSplitViewItem;
    
    NSSplitViewItem *networkDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.networkDevicesTableViewController];
    
    _networkDevicesTableSplitViewItem = [networkDevicesSplitViewItem retain];
    return networkDevicesSplitViewItem;
}

- (EditMachineNetworkDeviceViewController *)_networkDeviceViewController {
    if (auto networkDeviceViewController = _networkDeviceViewController) return networkDeviceViewController;
    
    EditMachineNetworkDeviceViewController *networkDeviceViewController = [EditMachineNetworkDeviceViewController new];
    networkDeviceViewController.delegate = self;
    
    _networkDeviceViewController = networkDeviceViewController;
    return networkDeviceViewController;
}

- (NSSplitViewItem *)_networkDeviceSplitViewItem {
    if (auto networkDeviceSplitViewItem = _networkDeviceSplitViewItem) return networkDeviceSplitViewItem;
    
    NSSplitViewItem *networkDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.networkDeviceViewController];
    
    _networkDeviceSplitViewItem = [networkDeviceSplitViewItem retain];
    return networkDeviceSplitViewItem;
}

- (NSViewController *)_emptyNetworkDeviceViewController {
    if (auto emptyNetworkDeviceViewController = _emptyNetworkDeviceViewController) return emptyNetworkDeviceViewController;
    
    NSViewController *emptyNetworkDeviceViewController = [NSViewController new];
    
    _emptyNetworkDeviceViewController = emptyNetworkDeviceViewController;
    return emptyNetworkDeviceViewController;
}

- (NSSplitViewItem *)_emptyNetworkDeviceSplitViewItem {
    if (auto emptyNetworkDeviceSplitViewItem = _emptyNetworkDeviceSplitViewItem) return emptyNetworkDeviceSplitViewItem;
    
    NSSplitViewItem *emptyNetworkDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyNetworkDeviceViewController];
    
    _emptyNetworkDeviceSplitViewItem = [emptyNetworkDeviceSplitViewItem retain];
    return emptyNetworkDeviceSplitViewItem;
}

- (void)editMachineNetworkDevicesViewController:(EditMachineNetworkDevicesTableViewController *)editMachineNetworkDevicesViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedNetworkDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.networkDevicesTableSplitViewItem, self.emptyNetworkDeviceSplitViewItem];
        return;
    }
    
    __kindof VZNetworkDeviceConfiguration *networkDevice = self.configuration.networkDevices[selectedIndex];
    self.networkDeviceViewController.networkDevice = networkDevice;
    self.splitViewController.splitViewItems = @[self.networkDevicesTableSplitViewItem, self.networkDeviceSplitViewItem];
}

- (void)editMachineNetworkDevicesViewController:(EditMachineNetworkDevicesTableViewController *)editMachineNetworkDevicesViewController didUpdateNetworkDevices:(NSArray<__kindof VZNetworkDeviceConfiguration *> *)networkDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.networkDevices = networkDevices;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineNetworksViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineNetworkDeviceViewController:(EditMachineNetworkDeviceViewController *)editMachineNetworkDeviceViewController didUpdateNetworkDevice:(__kindof VZNetworkDeviceConfiguration *)networkDevice {
    NSInteger selectedNetworkDeviceIndex = self.selectedNetworkDeviceIndex;
    assert((selectedNetworkDeviceIndex != NSNotFound) and (selectedNetworkDeviceIndex != -1));
    
    VZVirtualMachineConfiguration *machineConfiguration = [self.configuration copy];
    
    NSMutableArray<__kindof VZNetworkDeviceConfiguration *> *networkDevices = [machineConfiguration.networkDevices mutableCopy];
    [networkDevices removeObjectAtIndex:selectedNetworkDeviceIndex];
    [networkDevices insertObject:networkDevice atIndex:selectedNetworkDeviceIndex];
    machineConfiguration.networkDevices = networkDevices;
    [networkDevices release];
    
    self.configuration = machineConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineNetworksViewController:self didUpdateConfiguration:machineConfiguration];
    }
    
    [machineConfiguration release];
}

@end
