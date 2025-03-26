//
//  EditMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineViewController.h"
#import "EditMachineSidebarViewController.h"
#import "EditMachineMemoryBalloonDevicesViewController.h"
#import "EditMachineDirectorySharingDevicesViewController.h"
#import "EditMachineUSBControllersViewController.h"

@interface EditMachineViewController () <EditMachineSidebarViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_sidebarViewController) EditMachineSidebarViewController *sidebarViewController;
@property (retain, nonatomic, readonly, getter=_sidebarSplitViewItem) NSSplitViewItem *sidebarSplitViewItem;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesViewController) EditMachineMemoryBalloonDevicesViewController *memoryBalloonDevicesViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesSplitViewItem) NSSplitViewItem *memoryBalloonDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_directorySharingDevicesViewController) EditMachineDirectorySharingDevicesViewController *directorySharingDevicesViewController;
@property (retain, nonatomic, readonly, getter=_directorySharingDevicesSplitViewItem) NSSplitViewItem *directorySharingDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_usbControllersViewController) EditMachineUSBControllersViewController *usbControllersViewController;
@property (retain, nonatomic, readonly, getter=_usbControllersSplitViewItem) NSSplitViewItem *usbControllersSplitViewItem;
@end

@implementation EditMachineViewController
@synthesize splitViewController = _splitViewController;
@synthesize sidebarViewController = _sidebarViewController;
@synthesize sidebarSplitViewItem = _sidebarSplitViewItem;
@synthesize memoryBalloonDevicesViewController = _memoryBalloonDevicesViewController;
@synthesize memoryBalloonDevicesSplitViewItem = _memoryBalloonDevicesSplitViewItem;
@synthesize directorySharingDevicesViewController = _directorySharingDevicesViewController;
@synthesize directorySharingDevicesSplitViewItem = _directorySharingDevicesSplitViewItem;
@synthesize usbControllersViewController = _usbControllersViewController;
@synthesize usbControllersSplitViewItem = _usbControllersSplitViewItem;

- (instancetype)initWithMachine:(VZVirtualMachine *)machine {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _machine = [machine retain];
    }
    
    return self;
}

- (void)dealloc {
    [_machine release];
    [_splitViewController release];
    [_sidebarViewController release];
    [_sidebarSplitViewItem release];
    [_memoryBalloonDevicesViewController release];
    [_memoryBalloonDevicesSplitViewItem release];
    [_directorySharingDevicesViewController release];
    [_directorySharingDevicesSplitViewItem release];
    [_usbControllersViewController release];
    [_usbControllersSplitViewItem release];
    [super dealloc];
}

- (void)setMachine:(VZVirtualMachine *)machine {
    [_machine release];
    _machine = [machine retain];
    
    self.memoryBalloonDevicesViewController.memoryBalloonDevices = machine.memoryBalloonDevices;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    [self addChildViewController:splitViewController];
    
    [self _configureItemModels];
    
    EditMachineSidebarItemModel *itemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeUSB];
    [self.sidebarViewController selectItemModel:itemModel notifyingDelegate:YES];
    [itemModel release];
}

- (void)_configureItemModels {
    EditMachineSidebarItemModel *memoryBalloonDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeMemoryBalloonDevices];
    EditMachineSidebarItemModel *directorySharingDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeDirectorySharing];
    EditMachineSidebarItemModel *usbItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeUSB];
    
    self.sidebarViewController.itemModels = @[
        memoryBalloonDevicesItemModel,
        directorySharingDevicesItemModel,
        usbItemModel
    ];
    
    [memoryBalloonDevicesItemModel release];
    [directorySharingDevicesItemModel release];
    [usbItemModel release];
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    
    [splitViewController addSplitViewItem:self.sidebarSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineSidebarViewController *)_sidebarViewController {
    if (auto sidebarViewController = _sidebarViewController) return sidebarViewController;
    
    EditMachineSidebarViewController *sidebarViewController = [EditMachineSidebarViewController new];
    sidebarViewController.delegate = self;
    
    _sidebarViewController = sidebarViewController;
    return sidebarViewController;
}

- (NSSplitViewItem *)_sidebarSplitViewItem {
    if (auto sidebarSplitViewItem = _sidebarSplitViewItem) return sidebarSplitViewItem;
    
    NSSplitViewItem *sidebarSplitViewItem = [NSSplitViewItem contentListWithViewController:self.sidebarViewController];
    
    _sidebarSplitViewItem = [sidebarSplitViewItem retain];
    return sidebarSplitViewItem;
}

- (EditMachineMemoryBalloonDevicesViewController *)_memoryBalloonDevicesViewController {
    if (auto memoryBalloonDevicesViewController = _memoryBalloonDevicesViewController) return memoryBalloonDevicesViewController;
    
    EditMachineMemoryBalloonDevicesViewController *memoryBalloonDevicesViewController = [EditMachineMemoryBalloonDevicesViewController new];
    
    _memoryBalloonDevicesViewController = memoryBalloonDevicesViewController;
    return memoryBalloonDevicesViewController;
}

- (NSSplitViewItem *)_memoryBalloonDevicesSplitViewItem {
    if (auto memoryBalloonDevicesSplitViewItem = _memoryBalloonDevicesSplitViewItem) return memoryBalloonDevicesSplitViewItem;
    
    NSSplitViewItem *memoryBalloonDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.memoryBalloonDevicesViewController];
    
    _memoryBalloonDevicesSplitViewItem = [memoryBalloonDevicesSplitViewItem retain];
    return memoryBalloonDevicesSplitViewItem;
}

- (EditMachineDirectorySharingDevicesViewController *)_directorySharingDevicesViewController {
    if (auto directorySharingDevicesViewController = _directorySharingDevicesViewController) return directorySharingDevicesViewController;
    
    EditMachineDirectorySharingDevicesViewController *directorySharingDevicesViewController = [EditMachineDirectorySharingDevicesViewController new];
    
    _directorySharingDevicesViewController = directorySharingDevicesViewController;
    return directorySharingDevicesViewController;
}

- (NSSplitViewItem *)_directorySharingDevicesSplitViewItem {
    if (auto directorySharingDevicesSplitViewItem = _directorySharingDevicesSplitViewItem) return directorySharingDevicesSplitViewItem;
    
    NSSplitViewItem *directorySharingDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.directorySharingDevicesViewController];
    
    _directorySharingDevicesSplitViewItem = [directorySharingDevicesSplitViewItem retain];
    return directorySharingDevicesSplitViewItem;
}

- (EditMachineUSBControllersViewController *)_usbControllersViewController {
    if (auto usbControllersViewController = _usbControllersViewController) return usbControllersViewController;
    
    EditMachineUSBControllersViewController *usbControllersViewController = [EditMachineUSBControllersViewController new];
    
    _usbControllersViewController = usbControllersViewController;
    return usbControllersViewController;
}

- (NSSplitViewItem *)_usbControllersSplitViewItem {
    if (auto usbControllersSplitViewItem = _usbControllersSplitViewItem) return usbControllersSplitViewItem;
    
    NSSplitViewItem *usbControllersSplitViewItem = [NSSplitViewItem contentListWithViewController:self.usbControllersViewController];
    
    _usbControllersSplitViewItem = [usbControllersSplitViewItem retain];
    return usbControllersSplitViewItem;
}

- (void)editMachineSidebarViewController:(EditMachineSidebarViewController *)editMachineSidebarViewController didSelectItemModel:(EditMachineSidebarItemModel *)itemModel {
    switch (itemModel.type) {
        case EditMachineSidebarItemModelTypeMemoryBalloonDevices: {
            self.memoryBalloonDevicesViewController.memoryBalloonDevices = self.machine.memoryBalloonDevices;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.memoryBalloonDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeDirectorySharing: {
            self.directorySharingDevicesViewController.directorySharingDevices = self.machine.directorySharingDevices;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.directorySharingDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeUSB: {
            self.usbControllersViewController.usbControllers = self.machine.usbControllers;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.usbControllersSplitViewItem];
            break;
        }
        default:
            abort();
    }
}

@end
