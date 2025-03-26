//
//  EditMachineConfigurationUSBControllersViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineConfigurationUSBControllersViewController.h"
#import "EditMachineConfigurationUSBControllersTableViewController.h"
#import "EditMachineConfigurationUSBDevicesTableViewController.h"

@interface EditMachineConfigurationUSBControllersViewController () <EditMachineUSBControllersTableViewControllerDelegate, EditMachineConfigurationUSBDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_usbControllersTableViewController) EditMachineConfigurationUSBControllersTableViewController *usbControllersTableViewController;
@property (retain, nonatomic, readonly, getter=_usbControllersTableSplitView) NSSplitViewItem *usbControllersTableSplitView;

@property (retain, nonatomic, readonly, getter=_usbDevicesTableViewController) EditMachineConfigurationUSBDevicesTableViewController *usbDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_usbDevicesTableSplitView) NSSplitViewItem *usbDevicesTableSplitView;

@property (retain, nonatomic, readonly, getter=_emptyUSBControllerViewController) NSViewController *emptyUSBControllerViewController;
@property (retain, nonatomic, readonly, getter=_emptyUSBControllerSplitViewItem) NSSplitViewItem *emptyUSBControllerSplitViewItem;

@property (assign, nonatomic, getter=_selectedUSBControllerIndex, setter=_setSelectedUSBControllerIndex:) NSInteger selectedUSBControllerIndex;
@end

@implementation EditMachineConfigurationUSBControllersViewController
@synthesize splitViewController = _splitViewController;
@synthesize usbControllersTableViewController = _usbControllersTableViewController;
@synthesize usbControllersTableSplitView = _usbControllersTableSplitView;
@synthesize usbDevicesTableViewController = _usbDevicesTableViewController;
@synthesize usbDevicesTableSplitView = _usbDevicesTableSplitView;
@synthesize emptyUSBControllerViewController = _emptyUSBControllerViewController;
@synthesize emptyUSBControllerSplitViewItem = _emptyUSBControllerSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedUSBControllerIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_usbControllersTableViewController release];
    [_usbControllersTableSplitView release];
    [_usbDevicesTableViewController release];
    [_usbDevicesTableSplitView release];
    [_emptyUSBControllerViewController release];
    [_emptyUSBControllerSplitViewItem release];
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
    self.usbControllersTableViewController.usbControllers = self.configuration.usbControllers;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.usbControllersTableSplitView, self.emptyUSBControllerSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineConfigurationUSBControllersTableViewController *)_usbControllersTableViewController {
    if (auto usbControllersTableViewController = _usbControllersTableViewController) return usbControllersTableViewController;
    
    EditMachineConfigurationUSBControllersTableViewController *usbControllersTableViewController = [EditMachineConfigurationUSBControllersTableViewController new];
    usbControllersTableViewController.delegate = self;
    
    _usbControllersTableViewController = usbControllersTableViewController;
    return usbControllersTableViewController;
}

- (NSSplitViewItem *)_usbControllersTableSplitView {
    if (auto usbControllersTableSplitView = _usbControllersTableSplitView) return usbControllersTableSplitView;
    
    NSSplitViewItem *usbControllersTableSplitView = [NSSplitViewItem contentListWithViewController:self.usbControllersTableViewController];
    
    _usbControllersTableSplitView = [usbControllersTableSplitView retain];
    return usbControllersTableSplitView;
}

- (EditMachineConfigurationUSBDevicesTableViewController *)_usbDevicesTableViewController {
    if (auto usbDevicesTableViewController = _usbDevicesTableViewController) return usbDevicesTableViewController;
    
    EditMachineConfigurationUSBDevicesTableViewController *usbDevicesTableViewController = [EditMachineConfigurationUSBDevicesTableViewController new];
    usbDevicesTableViewController.delegate = self;
    
    _usbDevicesTableViewController = usbDevicesTableViewController;
    return usbDevicesTableViewController;
}

- (NSSplitViewItem *)_usbDevicesTableSplitView {
    if (auto usbDevicesTableSplitView = _usbDevicesTableSplitView) return usbDevicesTableSplitView;
    
    NSSplitViewItem *usbDevicesTableSplitView = [NSSplitViewItem contentListWithViewController:self.usbDevicesTableViewController];
    
    _usbDevicesTableSplitView = [usbDevicesTableSplitView retain];
    return usbDevicesTableSplitView;
}

- (NSViewController *)_emptyUSBControllerViewController {
    if (auto emptyUSBControllerViewController = _emptyUSBControllerViewController) return emptyUSBControllerViewController;
    
    NSViewController *emptyUSBControllerViewController = [NSViewController new];
    
    _emptyUSBControllerViewController = emptyUSBControllerViewController;
    return emptyUSBControllerViewController;
}

- (NSSplitViewItem *)_emptyUSBControllerSplitViewItem {
    if (auto emptyUSBControllerSplitViewItem = _emptyUSBControllerSplitViewItem) return emptyUSBControllerSplitViewItem;
    
    NSSplitViewItem *emptyUSBControllerSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyUSBControllerViewController];
    
    _emptyUSBControllerSplitViewItem = [emptyUSBControllerSplitViewItem retain];
    return emptyUSBControllerSplitViewItem;
}

- (void)editMachineConfigurationUSBControllersTableViewController:(EditMachineConfigurationUSBControllersTableViewController *)editMachineUSBControllersTableViewControllerDelegate didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedUSBControllerIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.usbControllersTableSplitView, self.emptyUSBControllerSplitViewItem];
        return;
    }
    
    __kindof VZUSBControllerConfiguration *usbController = self.configuration.usbControllers[selectedIndex];
    
    if ([usbController isKindOfClass:[VZXHCIControllerConfiguration class]]) {
        auto casted = static_cast<VZXHCIControllerConfiguration *>(usbController);
        
        self.usbDevicesTableViewController.usbDevices = casted.usbDevices;
        self.splitViewController.splitViewItems = @[self.usbControllersTableSplitView, self.usbDevicesTableSplitView];
    } else {
        abort();
    }
}

- (void)editMachineConfigurationUSBControllersTableViewController:(EditMachineConfigurationUSBControllersTableViewController *)editMachineUSBControllersTableViewControllerDelegate didUpdateUSBControllers:(NSArray<__kindof VZUSBControllerConfiguration *> *)usbControllers {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.usbControllers = usbControllers;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationUSBControllersViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineConfigurationUSBDevicesTableViewController:(EditMachineConfigurationUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    // nop
}

- (void)editMachineConfigurationUSBDevicesTableViewController:(EditMachineConfigurationUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didUpdateUSBDevices:(NSArray<id<VZUSBDeviceConfiguration>> *)usbDevices {
    NSInteger selectedUSBControllerIndex = self.selectedUSBControllerIndex;
    assert((selectedUSBControllerIndex != NSNotFound) and (selectedUSBControllerIndex != -1));
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    __kindof VZUSBControllerConfiguration *usbController = configuration.usbControllers[selectedUSBControllerIndex];
    assert([usbController isKindOfClass:[VZXHCIControllerConfiguration class]]);
    
    usbController.usbDevices = usbDevices;
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationUSBControllersViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
