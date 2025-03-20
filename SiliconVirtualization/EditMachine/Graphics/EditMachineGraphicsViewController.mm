//
//  EditMachineGraphicsViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineGraphicsViewController.h"
#import "EditMachineGraphicsDevicesViewController.h"
#import "EditMachineMacGraphicsDeviceViewController.h"
#import "EditMachineMacGraphicsDisplayViewController.h"

@interface EditMachineGraphicsViewController () <EditMachineGraphicsDevicesViewControllerDelegate, EditMachineMacGraphicsDeviceViewControllerDelegate, EditMachineMacGraphicsDisplayViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_devicesViewController) EditMachineGraphicsDevicesViewController *devicesViewController;
@property (retain, nonatomic, readonly, getter=_devicesSplitViewItem) NSSplitViewItem *devicesSplitViewItem;

@property (assign, nonatomic, getter=_selectedDeviceIndex, setter=_setSelectedDeviceIndex:) NSInteger selectedDeviceIndex;
@property (assign, nonatomic, getter=_selectedDisplayIndex, setter=_setSelectedDisplayIndex:) NSInteger selectedDisplayIndex;

@property (retain, nonatomic, readonly, getter=_emptyDeviceSplitViewItem) NSSplitViewItem *emptyDeviceSplitViewItem;
@property (retain, nonatomic, readonly, getter=_macGraphicsDeviceViewController) EditMachineMacGraphicsDeviceViewController *macGraphicsDeviceViewController;
@property (retain, nonatomic, readonly, getter=_macGraphicsDeviceSplitViewItem) NSSplitViewItem *macGraphicsDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyDetailSplitViewItem) NSSplitViewItem *emptyDetailSplitViewItem;
@property (retain, nonatomic, readonly, getter=_macGraphicsDisplayViewController) EditMachineMacGraphicsDisplayViewController *macGraphicsDisplayViewController;
@property (retain, nonatomic, readonly, getter=_macGraphicsDisplaySplitViewItem) NSSplitViewItem *macGraphicsDisplaySplitViewItem;
@end

@implementation EditMachineGraphicsViewController
@synthesize splitViewController = _splitViewController;
@synthesize devicesViewController = _devicesViewController;
@synthesize devicesSplitViewItem = _devicesSplitViewItem;
@synthesize emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem;
@synthesize macGraphicsDeviceViewController = _macGraphicsDeviceViewController;
@synthesize macGraphicsDeviceSplitViewItem = _macGraphicsDeviceSplitViewItem;
@synthesize emptyDetailSplitViewItem = _emptyDetailSplitViewItem;
@synthesize macGraphicsDisplayViewController = _macGraphicsDisplayViewController;
@synthesize macGraphicsDisplaySplitViewItem = _macGraphicsDisplaySplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedDeviceIndex = NSNotFound;
        _selectedDisplayIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_devicesViewController release];
    [_devicesSplitViewItem release];
    [_emptyDeviceSplitViewItem release];
    [_macGraphicsDeviceViewController release];
    [_macGraphicsDeviceSplitViewItem release];
    [_emptyDetailSplitViewItem release];
    [_macGraphicsDisplayViewController release];
    [_macGraphicsDisplaySplitViewItem release];
    [super dealloc];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    VZVirtualMachineConfiguration *configuration = self.configuration;
    
    self.devicesViewController.graphicsDevices = self.configuration.graphicsDevices;
    
    NSInteger selectedDeviceIndex = self.selectedDeviceIndex;
    if ((selectedDeviceIndex == NSNotFound) or (selectedDeviceIndex == -1)) {
        self.macGraphicsDeviceViewController.macGraphicsDeviceConfiguration = nil;
    } else {
        self.macGraphicsDeviceViewController.macGraphicsDeviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(configuration.graphicsDevices[selectedDeviceIndex]);
    }
    
    NSInteger selectedDisplayIndex = self.selectedDisplayIndex;
    if ((selectedDisplayIndex == NSNotFound) or (selectedDisplayIndex == -1)) {
        self.macGraphicsDisplayViewController.configuration = nil;
    } else {
        auto deviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(configuration.graphicsDevices[selectedDeviceIndex]);
        self.macGraphicsDisplayViewController.configuration = deviceConfiguration.displays[selectedDisplayIndex];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    
    [self _didChangeConfiguration];
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.devicesSplitViewItem, self.emptyDeviceSplitViewItem, self.emptyDetailSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineGraphicsDevicesViewController *)_devicesViewController {
    if (auto devicesViewController = _devicesViewController) return devicesViewController;
    
    EditMachineGraphicsDevicesViewController *devicesViewController = [[EditMachineGraphicsDevicesViewController alloc] initWithGraphicsDevices:self.configuration.graphicsDevices];
    devicesViewController.delegate = self;
    
    _devicesViewController = devicesViewController;
    return devicesViewController;
}

- (NSSplitViewItem *)_devicesSplitViewItem {
    if (auto devicesSplitViewItem = _devicesSplitViewItem) return devicesSplitViewItem;
    
    NSSplitViewItem *devicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.devicesViewController];
    
    _devicesSplitViewItem = [devicesSplitViewItem retain];
    return devicesSplitViewItem;
}
- (NSSplitViewItem *)_emptyDeviceSplitViewItem {
    if (auto emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem) return emptyDeviceSplitViewItem;
    
    NSViewController *viewController = [NSViewController new];
    NSSplitViewItem *emptyDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:viewController];
    [viewController release];
    
    _emptyDeviceSplitViewItem = [emptyDeviceSplitViewItem retain];
    return emptyDeviceSplitViewItem;
}

- (EditMachineMacGraphicsDeviceViewController *)_macGraphicsDeviceViewController {
    if (auto macGraphicsDeviceViewController = _macGraphicsDeviceViewController) return macGraphicsDeviceViewController;
    
    EditMachineMacGraphicsDeviceViewController *macGraphicsDeviceViewController = [EditMachineMacGraphicsDeviceViewController new];
    macGraphicsDeviceViewController.delegate = self;
    
    _macGraphicsDeviceViewController = macGraphicsDeviceViewController;
    return macGraphicsDeviceViewController;
}

- (NSSplitViewItem *)_macGraphicsDeviceSplitViewItem {
    if (auto macGraphicsDeviceSplitViewItem = _macGraphicsDeviceSplitViewItem) return macGraphicsDeviceSplitViewItem;
    
    NSSplitViewItem *macGraphicsDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.macGraphicsDeviceViewController];
    
    _macGraphicsDeviceSplitViewItem = [macGraphicsDeviceSplitViewItem retain];
    return macGraphicsDeviceSplitViewItem;
}

- (NSSplitViewItem *)_emptyDetailSplitViewItem {
    if (auto emptyDetailSplitViewItem = _emptyDetailSplitViewItem) return emptyDetailSplitViewItem;
    
    NSViewController *viewController = [NSViewController new];
    NSSplitViewItem *emptyDetailSplitViewItem = [NSSplitViewItem contentListWithViewController:viewController];
    [viewController release];
    
    _emptyDetailSplitViewItem = [emptyDetailSplitViewItem retain];
    return emptyDetailSplitViewItem;
}

- (EditMachineMacGraphicsDisplayViewController *)_macGraphicsDisplayViewController {
    if (auto macGraphicsDisplayViewController = _macGraphicsDisplayViewController) return macGraphicsDisplayViewController;
    
    EditMachineMacGraphicsDisplayViewController *macGraphicsDisplayViewController = [EditMachineMacGraphicsDisplayViewController new];
    macGraphicsDisplayViewController.delegate = self;
    
    _macGraphicsDisplayViewController = macGraphicsDisplayViewController;
    return  macGraphicsDisplayViewController;
}

- (NSSplitViewItem *)_macGraphicsDisplaySplitViewItem {
    if (auto macGraphicsDisplaySplitViewItem = _macGraphicsDisplaySplitViewItem) return macGraphicsDisplaySplitViewItem;
    
    NSSplitViewItem *macGraphicsDisplaySplitViewItem = [NSSplitViewItem contentListWithViewController:self.macGraphicsDisplayViewController];
    
    _macGraphicsDisplaySplitViewItem = [macGraphicsDisplaySplitViewItem retain];
    return macGraphicsDisplaySplitViewItem;
}

- (void)editMachineGraphicsDevicesViewController:(EditMachineGraphicsDevicesViewController *)editMachineGraphicsDevicesViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDeviceIndex = selectedIndex;
    
    if (selectedIndex == NSNotFound || selectedIndex == -1) {
        self.selectedDisplayIndex = NSNotFound;
        self.splitViewController.splitViewItems = @[self.devicesSplitViewItem, self.emptyDeviceSplitViewItem, self.emptyDetailSplitViewItem];
        return;
    }
    
    __kindof VZGraphicsDeviceConfiguration *configuration = self.configuration.graphicsDevices[selectedIndex];
    
    if ([configuration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]) {
        self.macGraphicsDeviceViewController.macGraphicsDeviceConfiguration = configuration;
        self.splitViewController.splitViewItems = @[self.devicesSplitViewItem, self.macGraphicsDeviceSplitViewItem, self.emptyDetailSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachineGraphicsDevicesViewController:(EditMachineGraphicsDevicesViewController *)editMachineGraphicsDevicesViewController didUpdateGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.graphicsDevices = graphicsDevices;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsViewController:self didUpdateConfiguration:configuration];
    }
    
    self.configuration = configuration;
    [configuration release];
}

- (void)editMachineMacGraphicsDeviceViewController:(EditMachineMacGraphicsDeviceViewController *)editMachineMacGraphicsDeviceViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDisplayIndex = selectedIndex;
    if (selectedIndex == NSNotFound || selectedIndex == -1) {
        self.splitViewController.splitViewItems = @[self.devicesSplitViewItem, self.macGraphicsDeviceSplitViewItem, self.emptyDetailSplitViewItem];
        return;
    }
    
    auto deviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(self.configuration.graphicsDevices[self.selectedDeviceIndex]);
    assert([deviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]);
    
    auto displayConfiguration = deviceConfiguration.displays[selectedIndex];
    self.macGraphicsDisplayViewController.configuration = displayConfiguration;
    self.splitViewController.splitViewItems = @[self.devicesSplitViewItem, self.macGraphicsDeviceSplitViewItem, self.macGraphicsDisplaySplitViewItem];
}

- (void)editMachineMacGraphicsDeviceViewController:(EditMachineMacGraphicsDeviceViewController *)editMachineMacGraphicsDeviceViewController didUpdateConfiguration:(VZMacGraphicsDeviceConfiguration *)configuration {
    NSInteger selectedDeviceIndex = self.selectedDeviceIndex;
    assert((selectedDeviceIndex != NSNotFound) and (selectedDeviceIndex != -1));
    
    VZVirtualMachineConfiguration *_configuration = [self.configuration copy];
    NSMutableArray<VZGraphicsDeviceConfiguration *> *graphicsDevices = [_configuration.graphicsDevices mutableCopy];
    [graphicsDevices removeObjectAtIndex:selectedDeviceIndex];
    [graphicsDevices insertObject:configuration atIndex:selectedDeviceIndex];
    _configuration.graphicsDevices = graphicsDevices;
    [graphicsDevices release];
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsViewController:self didUpdateConfiguration:_configuration];
    }
    
    self.configuration = _configuration;
    [_configuration release];
}

- (void)editMachineMacGraphicsDisplayViewController:(EditMachineMacGraphicsDisplayViewController *)editMachineMacGraphicsDisplayViewController didUpdateConfiguration:(VZMacGraphicsDisplayConfiguration *)configuration {
    NSInteger selectedDeviceIndex = self.selectedDeviceIndex;
    assert((selectedDeviceIndex != NSNotFound) and (selectedDeviceIndex != -1));
    NSInteger selectedDisplayIndex = self.selectedDisplayIndex;
    assert((selectedDisplayIndex != NSNotFound) and (selectedDisplayIndex != -1));
    
    VZVirtualMachineConfiguration *_configuration = [self.configuration copy];
    auto deviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(_configuration.graphicsDevices[selectedDeviceIndex]);
    assert([deviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]);
    NSMutableArray<VZMacGraphicsDisplayConfiguration *> *displays = [deviceConfiguration.displays mutableCopy];
    [displays removeObjectAtIndex:selectedDisplayIndex];
    [displays insertObject:configuration atIndex:selectedDeviceIndex];
    deviceConfiguration.displays = displays;
    [displays release];
    
    if (auto delegate = self.delegate) {
        [delegate editMachineGraphicsViewController:self didUpdateConfiguration:_configuration];
    }
    
    self.configuration = _configuration;
    [_configuration release];
}

@end
