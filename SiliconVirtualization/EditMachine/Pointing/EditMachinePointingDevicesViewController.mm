//
//  EditMachinePointingDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "EditMachinePointingDevicesViewController.h"
#import "EditMachinePointingDevicesTableViewController.h"
#import "EditMachineMacTrackpadViewController.h"
#import "EditMachineUSBScreenCoordinatePointingDeviceViewController.h"

@interface EditMachinePointingDevicesViewController () <EditMachinePointingDevicesTableViewControllerDelegate, EditMachineMacTrackpadViewControllerDelegate, EditMachineUSBScreenCoordinatePointingDeviceViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_pointingDevicesTableViewController) EditMachinePointingDevicesTableViewController *pointingDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_pointingDevicesTableSplitViewItem) NSSplitViewItem *pointingDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_macTrackpadViewController) EditMachineMacTrackpadViewController *macTrackpadViewController;
@property (retain, nonatomic, readonly, getter=_macTrackpadSplitViewItem) NSSplitViewItem *macTrackpadSplitViewItem;

@property (retain, nonatomic, readonly, getter=_USBScreenCoordinatePointingDeviceViewController) EditMachineUSBScreenCoordinatePointingDeviceViewController *USBScreenCoordinatePointingDeviceViewController;
@property (retain, nonatomic, readonly, getter=_USBScreenCoordinatePointingDeviceSplitViewItem) NSSplitViewItem *USBScreenCoordinatePointingDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyPointingDeviceViewController) NSViewController *emptyPointingDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyPointingDeviceSplitViewItem) NSSplitViewItem *emptyPointingDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedPointingDeviceIndex, setter=_setSelectedPointingDeviceIndex:) NSInteger selectedPointingDeviceIndex;
@end

@implementation EditMachinePointingDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize pointingDevicesTableViewController = _pointingDevicesTableViewController;
@synthesize pointingDevicesTableSplitViewItem = _pointingDevicesTableSplitViewItem;
@synthesize macTrackpadViewController = _macTrackpadViewController;
@synthesize macTrackpadSplitViewItem = _macTrackpadSplitViewItem;
@synthesize USBScreenCoordinatePointingDeviceViewController = _USBScreenCoordinatePointingDeviceViewController;
@synthesize USBScreenCoordinatePointingDeviceSplitViewItem = _USBScreenCoordinatePointingDeviceSplitViewItem;
@synthesize emptyPointingDeviceViewController = _emptyPointingDeviceViewController;
@synthesize emptyPointingDeviceSplitViewItem = _emptyPointingDeviceSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedPointingDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_pointingDevicesTableViewController release];
    [_pointingDevicesTableSplitViewItem release];
    [_macTrackpadViewController release];
    [_macTrackpadSplitViewItem release];
    [_USBScreenCoordinatePointingDeviceViewController release];
    [_USBScreenCoordinatePointingDeviceSplitViewItem release];
    [_emptyPointingDeviceViewController release];
    [_emptyPointingDeviceSplitViewItem release];
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
    self.pointingDevicesTableViewController.pointingDevices = self.configuration.pointingDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.pointingDevicesTableSplitViewItem, self.emptyPointingDeviceSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachinePointingDevicesTableViewController *)_pointingDevicesTableViewController {
    if (auto pointingDevicesTableViewController = _pointingDevicesTableViewController) return pointingDevicesTableViewController;
    
    EditMachinePointingDevicesTableViewController *pointingDevicesTableViewController = [EditMachinePointingDevicesTableViewController new];
    pointingDevicesTableViewController.delegate = self;
    
    _pointingDevicesTableViewController = pointingDevicesTableViewController;
    return pointingDevicesTableViewController;
}

- (NSSplitViewItem *)_pointingDevicesTableSplitViewItem {
    if (auto pointingDevicesTableSplitViewItem = _pointingDevicesTableSplitViewItem) return pointingDevicesTableSplitViewItem;
    
    NSSplitViewItem *pointingDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.pointingDevicesTableViewController];
    
    _pointingDevicesTableSplitViewItem = [pointingDevicesTableSplitViewItem retain];
    return pointingDevicesTableSplitViewItem;
}

- (EditMachineMacTrackpadViewController *)_macTrackpadViewController {
    if (auto macTrackpadViewController = _macTrackpadViewController) return macTrackpadViewController;
    
    EditMachineMacTrackpadViewController *macTrackpadViewController = [EditMachineMacTrackpadViewController new];
    macTrackpadViewController.delegate = self;
    
    _macTrackpadViewController = macTrackpadViewController;
    return macTrackpadViewController;
}

- (NSSplitViewItem *)_macTrackpadSplitViewItem {
    if (auto macTrackpadSplitViewItem = _macTrackpadSplitViewItem) return macTrackpadSplitViewItem;
    
    NSSplitViewItem *macTrackpadSplitViewItem = [NSSplitViewItem contentListWithViewController:self.macTrackpadViewController];
    
    _macTrackpadSplitViewItem = [macTrackpadSplitViewItem retain];
    return macTrackpadSplitViewItem;
}

- (EditMachineUSBScreenCoordinatePointingDeviceViewController *)_USBScreenCoordinatePointingDeviceViewController {
    if (auto USBScreenCoordinatePointingDeviceViewController = _USBScreenCoordinatePointingDeviceViewController) return USBScreenCoordinatePointingDeviceViewController;
    
    EditMachineUSBScreenCoordinatePointingDeviceViewController *USBScreenCoordinatePointingDeviceViewController = [EditMachineUSBScreenCoordinatePointingDeviceViewController new];
    USBScreenCoordinatePointingDeviceViewController.delegate = self;
    
    _USBScreenCoordinatePointingDeviceViewController = USBScreenCoordinatePointingDeviceViewController;
    return USBScreenCoordinatePointingDeviceViewController;
}

- (NSSplitViewItem *)_USBScreenCoordinatePointingDeviceSplitViewItem {
    if (auto USBScreenCoordinatePointingDeviceSplitViewItem = _USBScreenCoordinatePointingDeviceSplitViewItem) return USBScreenCoordinatePointingDeviceSplitViewItem;
    
    NSSplitViewItem *USBScreenCoordinatePointingDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.USBScreenCoordinatePointingDeviceViewController];
    
    _USBScreenCoordinatePointingDeviceSplitViewItem = [USBScreenCoordinatePointingDeviceSplitViewItem retain];
    return USBScreenCoordinatePointingDeviceSplitViewItem;
}

- (NSViewController *)_emptyPointingDeviceViewController {
    if (auto emptyPointingDeviceViewController = _emptyPointingDeviceViewController) return emptyPointingDeviceViewController;
    
    NSViewController *emptyPointingDeviceViewController = [NSViewController new];
    
    _emptyPointingDeviceViewController = emptyPointingDeviceViewController;
    return emptyPointingDeviceViewController;
}

- (NSSplitViewItem *)_emptyPointingDeviceSplitViewItem {
    if (auto emptyPointingDeviceSplitViewItem = _emptyPointingDeviceSplitViewItem) return emptyPointingDeviceSplitViewItem;
    
    NSSplitViewItem *emptyPointingDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyPointingDeviceViewController];
    
    _emptyPointingDeviceSplitViewItem = [emptyPointingDeviceSplitViewItem retain];
    return emptyPointingDeviceSplitViewItem;
}

- (void)editMachinePointingDevicesTableViewController:(EditMachinePointingDevicesTableViewController *)editMachinePointingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedPointingDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.pointingDevicesTableSplitViewItem, self.emptyPointingDeviceSplitViewItem];
        return;
    }
    
    __kindof VZPointingDeviceConfiguration *pointingDevice = self.configuration.pointingDevices[selectedIndex];
    
    if ([pointingDevice isKindOfClass:[VZUSBScreenCoordinatePointingDeviceConfiguration class]]) {
        auto casted = static_cast<VZUSBScreenCoordinatePointingDeviceConfiguration *>(pointingDevice);
        self.USBScreenCoordinatePointingDeviceViewController.USBScreenCoordinatePointingDeviceConfiguration = casted;
        self.splitViewController.splitViewItems = @[self.pointingDevicesTableSplitViewItem, self.USBScreenCoordinatePointingDeviceSplitViewItem];
    } else if ([pointingDevice isKindOfClass:[VZMacTrackpadConfiguration class]]) {
        auto casted = static_cast<VZMacTrackpadConfiguration *>(pointingDevice);
        self.macTrackpadViewController.macTrackpadConfiguration = casted;
        self.splitViewController.splitViewItems = @[self.pointingDevicesTableSplitViewItem, self.macTrackpadSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachinePointingDevicesTableViewController:(EditMachinePointingDevicesTableViewController *)editMachinePointingDevicesTableViewController didUpdatePointingDevices:(NSArray<__kindof VZPointingDeviceConfiguration *> *)pointingDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.pointingDevices = pointingDevices;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePointingDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineMacTrackpadViewController:(EditMachineMacTrackpadViewController *)editMachineMacTrackpadViewController didUpdateMacTrackpadConfiguration:(VZMacTrackpadConfiguration *)macTrackpadConfiguration {
    [self _updateMachineConfigurationWithPointingDevice:macTrackpadConfiguration];
}

- (void)editMachineUSBScreenCoordinatePointingDeviceViewController:(EditMachineUSBScreenCoordinatePointingDeviceViewController *)editMachineUSBScreenCoordinatePointingDeviceViewController didUpdateUSBScreenCoordinatePointingDeviceConfiguration:(VZUSBScreenCoordinatePointingDeviceConfiguration *)USBScreenCoordinatePointingDeviceConfiguration {
    [self _updateMachineConfigurationWithPointingDevice:USBScreenCoordinatePointingDeviceConfiguration];
}

- (void)_updateMachineConfigurationWithPointingDevice:(__kindof VZPointingDeviceConfiguration *)pointingDevice {
    NSInteger selectedPointingDeviceIndex = self.selectedPointingDeviceIndex;
    assert((selectedPointingDeviceIndex != NSNotFound) and (selectedPointingDeviceIndex != -1));
    
    VZVirtualMachineConfiguration *machineConfiguration = [self.configuration copy];
    
    NSMutableArray<__kindof VZPointingDeviceConfiguration *> *pointingDevices = [machineConfiguration.pointingDevices mutableCopy];
    [pointingDevices removeObjectAtIndex:selectedPointingDeviceIndex];
    [pointingDevices insertObject:pointingDevice atIndex:selectedPointingDeviceIndex];
    machineConfiguration.pointingDevices = pointingDevices;
    [pointingDevices release];
    
    self.configuration = machineConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePointingDevicesViewController:self didUpdateConfiguration:machineConfiguration];
    }
    
    [machineConfiguration release];
}

@end
