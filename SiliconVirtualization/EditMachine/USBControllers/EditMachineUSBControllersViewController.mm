//
//  EditMachineUSBControllersViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import "EditMachineUSBControllersViewController.h"
#import "EditMachineUSBControllersTableViewController.h"
#import "EditMachineUSBDevicesTableViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineUSBControllersViewController () <EditMachineUSBControllersTableViewControllerDelegate, EditMachineUSBDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_usbControllersTableViewController) EditMachineUSBControllersTableViewController *usbControllersTableViewController;
@property (retain, nonatomic, readonly, getter=_usbControllersTableSplitViewItem) NSSplitViewItem *usbControllersTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_usbDevicesTableViewController) EditMachineUSBDevicesTableViewController *usbDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_usbDevicesTableSplitViewItem) NSSplitViewItem *usbDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyDeviceViewController) NSViewController *emptyDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyDeviceSplitViewItem) NSSplitViewItem *emptyDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedDeviceIndex, setter=_setSelectedDeviceIndex:) NSInteger selectedDeviceIndex;
@end

@implementation EditMachineUSBControllersViewController
@synthesize splitViewController = _splitViewController;
@synthesize usbControllersTableViewController = _usbControllersTableViewController;
@synthesize usbControllersTableSplitViewItem = _usbControllersTableSplitViewItem;
@synthesize usbDevicesTableViewController = _usbDevicesTableViewController;
@synthesize usbDevicesTableSplitViewItem = _usbDevicesTableSplitViewItem;
@synthesize emptyDeviceViewController = _emptyDeviceViewController;
@synthesize emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_splitViewController release];
    [_usbControllersTableViewController release];
    [_usbControllersTableSplitViewItem release];
    [_usbDevicesTableViewController release];
    [_usbDevicesTableSplitViewItem release];
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
    
    [self _didChangeUSBControllers];
}

- (void)setUSBControllers:(NSArray<__kindof VZUSBController *> *)usbControllers {
    [_usbControllers release];
    _usbControllers = [usbControllers copy];
    
    [self _didChangeUSBControllers];
}

- (void)_didChangeUSBControllers {
    self.usbControllersTableViewController.usbControllers = self.usbControllers;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.usbControllersTableSplitViewItem, self.emptyDeviceSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineUSBControllersTableViewController *)_usbControllersTableViewController {
    if (auto usbControllersTableViewController = _usbControllersTableViewController) return usbControllersTableViewController;
    
    EditMachineUSBControllersTableViewController *usbControllersTableViewController = [EditMachineUSBControllersTableViewController new];
    usbControllersTableViewController.delegate = self;
    
    _usbControllersTableViewController = usbControllersTableViewController;
    return usbControllersTableViewController;
}

- (NSSplitViewItem *)_usbControllersTableSplitViewItem {
    if (auto usbControllersTableSplitViewItem = _usbControllersTableSplitViewItem) return usbControllersTableSplitViewItem;
    
    NSSplitViewItem *usbControllersTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.usbControllersTableViewController];
    
    _usbControllersTableSplitViewItem = [usbControllersTableSplitViewItem retain];
    return usbControllersTableSplitViewItem;
}

- (EditMachineUSBDevicesTableViewController *)_usbDevicesTableViewController {
    if (auto usbDevicesTableViewController = _usbDevicesTableViewController) return usbDevicesTableViewController;
    
    EditMachineUSBDevicesTableViewController *usbDevicesTableViewController = [EditMachineUSBDevicesTableViewController new];
    usbDevicesTableViewController.delegate = self;
    
    _usbDevicesTableViewController = usbDevicesTableViewController;
    return usbDevicesTableViewController;
}

- (NSSplitViewItem *)_usbDevicesTableSplitViewItem {
    if (auto usbDevicesTableSplitViewItem = _usbDevicesTableSplitViewItem) return usbDevicesTableSplitViewItem;
    
    NSSplitViewItem *usbDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.usbDevicesTableViewController];
    
    _usbDevicesTableSplitViewItem = [usbDevicesTableSplitViewItem retain];
    return usbDevicesTableSplitViewItem;
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

- (void)editMachineUSBControllersTableViewController:(EditMachineUSBControllersTableViewController *)editMachineUSBControllersTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.usbControllersTableSplitViewItem, self.emptyDeviceSplitViewItem];
        return;
    }
    
    __kindof VZUSBController *usbController = self.usbControllers[selectedIndex];
    NSArray<id<VZUSBDevice>> *usbDevices = usbController.usbDevices;
    
    self.usbDevicesTableViewController.usbDevices = usbDevices;
    self.splitViewController.splitViewItems = @[self.usbControllersTableSplitViewItem, self.usbDevicesTableSplitViewItem];
}

- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
     // nop
}

- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController attachUSBDevice:(id<VZUSBDevice>)device {
    NSInteger selectedDeviceIndex = self.selectedDeviceIndex;
    assert((selectedDeviceIndex != NSNotFound) and (selectedDeviceIndex != -1));
    __kindof VZUSBController *usbController = self.usbControllers[selectedDeviceIndex];
    
    dispatch_queue_t _queue;
    assert(object_getInstanceVariable(usbController, "_queue", reinterpret_cast<void **>(&_queue)) != NULL);
    
    dispatch_async(_queue, ^{
        [usbController attachDevice:device completionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usbDevicesTableViewController.usbDevices = usbController.usbDevices;
            });
        }];
    });
}

- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController detachUSBDevice:(id<VZUSBDevice>)device {
    __kindof VZUSBController *usbController = device.usbController;
    assert(usbController != nil);
    
    dispatch_queue_t _queue;
    assert(object_getInstanceVariable(usbController, "_queue", reinterpret_cast<void **>(&_queue)) != NULL);
    
    dispatch_async(_queue, ^{
        [usbController detachDevice:device completionHandler:^(NSError * _Nullable errorOrNil) {
            assert(errorOrNil == nil);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.usbDevicesTableViewController.usbDevices = usbController.usbDevices;
            });
        }];
    });
}

@end
