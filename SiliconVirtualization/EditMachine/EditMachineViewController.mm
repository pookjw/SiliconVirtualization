//
//  EditMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineViewController.h"
#import "EditMachineSidebarViewController.h"
#import "EditMachineMemoryBalloonDevicesViewController.h"

@interface EditMachineViewController () <EditMachineSidebarViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_sidebarViewController) EditMachineSidebarViewController *sidebarViewController;
@property (retain, nonatomic, readonly, getter=_sidebarSplitViewItem) NSSplitViewItem *sidebarSplitViewItem;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesViewController) EditMachineMemoryBalloonDevicesViewController *memoryBalloonDevicesViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesSplitViewItem) NSSplitViewItem *memoryBalloonDevicesSplitViewItem;
@end

@implementation EditMachineViewController
@synthesize splitViewController = _splitViewController;
@synthesize sidebarViewController = _sidebarViewController;
@synthesize sidebarSplitViewItem = _sidebarSplitViewItem;
@synthesize memoryBalloonDevicesViewController = _memoryBalloonDevicesViewController;
@synthesize memoryBalloonDevicesSplitViewItem = _memoryBalloonDevicesSplitViewItem;

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
    
    EditMachineSidebarItemModel *itemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeMemoryBalloonDevices];
    [self.sidebarViewController selectItemModel:itemModel notifyingDelegate:YES];
    [itemModel release];
}

- (void)_configureItemModels {
    EditMachineSidebarItemModel *memoryBalloonDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeMemoryBalloonDevices];
    
    self.sidebarViewController.itemModels = @[
        memoryBalloonDevicesItemModel
    ];
    
    [memoryBalloonDevicesItemModel release];
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

- (void)editMachineSidebarViewController:(EditMachineSidebarViewController *)editMachineSidebarViewController didSelectItemModel:(EditMachineSidebarItemModel *)itemModel {
    switch (itemModel.type) {
        case EditMachineSidebarItemModelTypeMemoryBalloonDevices: {
            self.memoryBalloonDevicesViewController.memoryBalloonDevices = self.machine.memoryBalloonDevices;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.memoryBalloonDevicesSplitViewItem];
            break;
        }
        default:
            abort();
    }
}

@end
