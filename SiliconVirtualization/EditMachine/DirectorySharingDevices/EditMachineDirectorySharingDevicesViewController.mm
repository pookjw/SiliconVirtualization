//
//  EditMachineDirectorySharingDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import "EditMachineDirectorySharingDevicesViewController.h"
#import "EditMachineDirectorySharingDevicesTableViewController.h"
#import "EditMachineVirtioFileSystemDeviceViewController.h"

@interface EditMachineDirectorySharingDevicesViewController () <EditMachineDirectorySharingDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableViewController) EditMachineDirectorySharingDevicesTableViewController *directorySharingDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableSplitViewItem) NSSplitViewItem *directorySharingDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioFileSystemDeviceViewController) EditMachineVirtioFileSystemDeviceViewController *virtioFileSystemDeviceViewController;
@property (retain, nonatomic, readonly, getter=_virtioFileSystemDeviceSplitViewItem) NSSplitViewItem *virtioFileSystemDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyDeviceViewController) NSViewController *emptyDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyDeviceSplitViewItem) NSSplitViewItem *emptyDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedDeviceIndex, setter=_setSelectedDeviceIndex:) NSInteger selectedDeviceIndex;
@end

@implementation EditMachineDirectorySharingDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize directorySharingDevicesTableViewController = _directorySharingDevicesTableViewController;
@synthesize directorySharingDevicesTableSplitViewItem = _directorySharingDevicesTableSplitViewItem;
@synthesize virtioFileSystemDeviceViewController = _virtioFileSystemDeviceViewController;
@synthesize virtioFileSystemDeviceSplitViewItem = _virtioFileSystemDeviceSplitViewItem;
@synthesize emptyDeviceViewController = _emptyDeviceViewController;
@synthesize emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem;

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _selectedDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_directorySharingDevices release];
    [_splitViewController release];
    [_directorySharingDevicesTableViewController release];
    [_directorySharingDevicesTableSplitViewItem release];
    [_virtioFileSystemDeviceViewController release];
    [_virtioFileSystemDeviceSplitViewItem release];
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
    
    [self _didChangeDirectorySharingDevices];
}

- (void)setDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDevice *> *)directorySharingDevices {
    [_directorySharingDevices release];
    _directorySharingDevices = [directorySharingDevices copy];
    
    [self _didChangeDirectorySharingDevices];
}

- (void)_didChangeDirectorySharingDevices {
    self.directorySharingDevicesTableViewController.directorySharingDevices = self.directorySharingDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineDirectorySharingDevicesTableViewController *)_directorySharingDevicesTableViewController {
    if (auto directorySharingDevicesTableViewController = _directorySharingDevicesTableViewController) return directorySharingDevicesTableViewController;
    
    EditMachineDirectorySharingDevicesTableViewController *directorySharingDevicesTableViewController = [EditMachineDirectorySharingDevicesTableViewController new];
    directorySharingDevicesTableViewController.delegate = self;
    
    _directorySharingDevicesTableViewController = directorySharingDevicesTableViewController;
    return directorySharingDevicesTableViewController;
}

- (NSSplitViewItem *)_directorySharingDevicesTableSplitViewItem {
    if (auto directorySharingDevicesTableSplitViewItem = _directorySharingDevicesTableSplitViewItem) return directorySharingDevicesTableSplitViewItem;
    
    NSSplitViewItem *directorySharingDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.directorySharingDevicesTableViewController];
    
    _directorySharingDevicesTableSplitViewItem = [directorySharingDevicesTableSplitViewItem retain];
    return directorySharingDevicesTableSplitViewItem;
}

- (EditMachineVirtioFileSystemDeviceViewController *)_virtioFileSystemDeviceViewController {
    if (auto virtioFileSystemDeviceViewController = _virtioFileSystemDeviceViewController) return virtioFileSystemDeviceViewController;
    
    EditMachineVirtioFileSystemDeviceViewController *virtioFileSystemDeviceViewController = [EditMachineVirtioFileSystemDeviceViewController new];
    
    _virtioFileSystemDeviceViewController = virtioFileSystemDeviceViewController;
    return virtioFileSystemDeviceViewController;
}

- (NSSplitViewItem *)_virtioFileSystemDeviceSplitViewItem {
    if (auto virtioFileSystemDeviceSplitViewItem = _virtioFileSystemDeviceSplitViewItem) return virtioFileSystemDeviceSplitViewItem;
    
    NSSplitViewItem *virtioFileSystemDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.virtioFileSystemDeviceViewController];
    
    _virtioFileSystemDeviceSplitViewItem = [virtioFileSystemDeviceSplitViewItem retain];
    return virtioFileSystemDeviceSplitViewItem;
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

- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
        return;
    }
    
    __kindof VZDirectorySharingDevice *device = self.directorySharingDevices[selectedIndex];
    
    if ([device isKindOfClass:[VZVirtioFileSystemDevice class]]) {
        self.virtioFileSystemDeviceViewController.device = device;
        self.splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.virtioFileSystemDeviceSplitViewItem];
    } else {
        abort();
    }
}

@end
