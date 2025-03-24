//
//  EditMachinePowerSourceDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "EditMachinePowerSourceDevicesViewController.h"
#import "EditMachinePowerSourceDevicesTableViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "EditMachineMacBatteryPowerSourceDeviceViewController.h"

@interface EditMachinePowerSourceDevicesViewController () <EditMachinePowerSourceDevicesTableViewControllerDelegate, EditMachineMacBatteryPowerSourceDeviceViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_powerSourceDevicesTableViewController) EditMachinePowerSourceDevicesTableViewController *powerSourceDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_powerSourceDevicesTableSplitViewItem) NSSplitViewItem *powerSourceDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_macBatteryPowerSourceDeviceViewController) EditMachineMacBatteryPowerSourceDeviceViewController *macBatteryPowerSourceDeviceViewController;
@property (retain, nonatomic, readonly, getter=_macBatteryPowerSourceDeviceSplitViewItem) NSSplitViewItem *macBatteryPowerSourceDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyPowerSourceDeviceViewController) NSViewController *emptyPowerSourceDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyPowerSourceDeviceSplitViewItem) NSSplitViewItem *emptyPowerSourceDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedPowerSourceIndex, setter=_setSelectePowerSourceDeviceIndex:) NSInteger selectedPowerSourceIndex;
@end

@implementation EditMachinePowerSourceDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize powerSourceDevicesTableViewController = _powerSourceDevicesTableViewController;
@synthesize powerSourceDevicesTableSplitViewItem = _powerSourceDevicesTableSplitViewItem;
@synthesize macBatteryPowerSourceDeviceViewController = _macBatteryPowerSourceDeviceViewController;
@synthesize macBatteryPowerSourceDeviceSplitViewItem = _macBatteryPowerSourceDeviceSplitViewItem;
@synthesize emptyPowerSourceDeviceViewController = _emptyPowerSourceDeviceViewController;
@synthesize emptyPowerSourceDeviceSplitViewItem = _emptyPowerSourceDeviceSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedPowerSourceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_powerSourceDevicesTableViewController release];
    [_powerSourceDevicesTableSplitViewItem release];
    [_macBatteryPowerSourceDeviceViewController release];
    [_macBatteryPowerSourceDeviceSplitViewItem release];
    [_emptyPowerSourceDeviceViewController release];
    [_emptyPowerSourceDeviceSplitViewItem release];
    [super dealloc];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    self.powerSourceDevicesTableViewController.powerSourceDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_powerSourceDevices"));
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
    splitViewController.splitViewItems = @[
        self.powerSourceDevicesTableSplitViewItem,
        self.emptyPowerSourceDeviceSplitViewItem
    ];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachinePowerSourceDevicesTableViewController *)_powerSourceDevicesTableViewController {
    if (auto powerSourceDevicesTableViewController = _powerSourceDevicesTableViewController) return powerSourceDevicesTableViewController;
    
    EditMachinePowerSourceDevicesTableViewController *powerSourceDevicesTableViewController = [EditMachinePowerSourceDevicesTableViewController new];
    powerSourceDevicesTableViewController.powerSourceDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_powerSourceDevices"));
    powerSourceDevicesTableViewController.delegate = self;
    
    _powerSourceDevicesTableViewController = powerSourceDevicesTableViewController;
    return powerSourceDevicesTableViewController;
}

- (NSSplitViewItem *)_powerSourceDevicesTableSplitViewItem {
    if (auto powerSourceDevicesTableSplitViewItem = _powerSourceDevicesTableSplitViewItem) return powerSourceDevicesTableSplitViewItem;
    
    NSSplitViewItem *powerSourceDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.powerSourceDevicesTableViewController];
    
    _powerSourceDevicesTableSplitViewItem = [powerSourceDevicesTableSplitViewItem retain];
    return powerSourceDevicesTableSplitViewItem;
}

- (EditMachineMacBatteryPowerSourceDeviceViewController *)_macBatteryPowerSourceDeviceViewController {
    if (auto macBatteryPowerSourceDeviceViewController = _macBatteryPowerSourceDeviceViewController) return macBatteryPowerSourceDeviceViewController;
    
    EditMachineMacBatteryPowerSourceDeviceViewController *macBatteryPowerSourceDeviceViewController = [EditMachineMacBatteryPowerSourceDeviceViewController new];
    macBatteryPowerSourceDeviceViewController.delegate = self;
    
    _macBatteryPowerSourceDeviceViewController = macBatteryPowerSourceDeviceViewController;
    return macBatteryPowerSourceDeviceViewController;
}

- (NSSplitViewItem *)_macBatteryPowerSourceDeviceSplitViewItem {
    if (auto macBatteryPowerSourceDeviceSplitViewItem = _macBatteryPowerSourceDeviceSplitViewItem) return macBatteryPowerSourceDeviceSplitViewItem;
    
    NSSplitViewItem *macBatteryPowerSourceDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.macBatteryPowerSourceDeviceViewController];
    
    _macBatteryPowerSourceDeviceSplitViewItem = [macBatteryPowerSourceDeviceSplitViewItem retain];
    return macBatteryPowerSourceDeviceSplitViewItem;
}

- (NSViewController *)_emptyPowerSourceDeviceViewController {
    if (auto emptyPowerSourceDeviceViewController = _emptyPowerSourceDeviceViewController) return emptyPowerSourceDeviceViewController;
    
    NSViewController *emptyPowerSourceDeviceViewController = [NSViewController new];
    
    _emptyPowerSourceDeviceViewController = emptyPowerSourceDeviceViewController;
    return emptyPowerSourceDeviceViewController;
}

- (NSSplitViewItem *)_emptyPowerSourceDeviceSplitViewItem {
    if (auto emptyPowerSourceDeviceSplitViewItem = _emptyPowerSourceDeviceSplitViewItem) return emptyPowerSourceDeviceSplitViewItem;
    
    NSSplitViewItem *emptyPowerSourceDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyPowerSourceDeviceViewController];
    
    _emptyPowerSourceDeviceSplitViewItem = [emptyPowerSourceDeviceSplitViewItem retain];
    return emptyPowerSourceDeviceSplitViewItem;
}

- (void)editMachinePowerSourceDevicesTableViewController:(EditMachinePowerSourceDevicesTableViewController *)editMachinePowerSourceDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedPowerSourceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[
            self.powerSourceDevicesTableSplitViewItem,
            self.emptyPowerSourceDeviceSplitViewItem
        ];
        return;
    }
    
    NSArray *powerSourceDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_powerSourceDevices"));
    id powerSourceDevice = powerSourceDevices[selectedIndex];
    
    if ([powerSourceDevice isKindOfClass:objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration")]) {
        self.macBatteryPowerSourceDeviceViewController.powerSourceDevice = powerSourceDevice;
        
        self.splitViewController.splitViewItems = @[
            self.powerSourceDevicesTableSplitViewItem,
            self.macBatteryPowerSourceDeviceSplitViewItem
        ];
    } else if ([powerSourceDevice isKindOfClass:objc_lookUpClass("_VZMacWallPowerSourceDeviceConfiguration")]) {
        self.splitViewController.splitViewItems = @[
            self.powerSourceDevicesTableSplitViewItem,
            self.emptyPowerSourceDeviceSplitViewItem
        ];
    } else {
        abort();
    }
}

- (void)editMachinePowerSourceDevicesTableViewController:(EditMachinePowerSourceDevicesTableViewController *)editMachinePowerSourceDevicesTableViewController didUpdatePowerSourceDevices:(NSArray *)powerSourceDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setPowerSourceDevices:"), powerSourceDevices);
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePowerSourceDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineMacBatteryPowerSourceDeviceViewController:(EditMachineMacBatteryPowerSourceDeviceViewController *)editMachineMacBatteryPowerSourceDeviceViewController didUpdatePowerSourceDevice:(id)powerSourceDevice {
    NSInteger selectedPowerSourceIndex = self.selectedPowerSourceIndex;
    assert((selectedPowerSourceIndex != NSNotFound) and (selectedPowerSourceIndex != -1));
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    NSMutableArray *powerSourceDevices = [reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(configuration, sel_registerName("_powerSourceDevices")) mutableCopy];
    [powerSourceDevices removeObjectAtIndex:selectedPowerSourceIndex];
    [powerSourceDevices insertObject:powerSourceDevice atIndex:selectedPowerSourceIndex];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setPowerSourceDevices:"), powerSourceDevices);
    [powerSourceDevices release];
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePowerSourceDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
