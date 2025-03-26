//
//  EditMachineConfigurationDirectorySharingViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineConfigurationDirectorySharingViewController.h"
#import "EditMachineConfigurationDirectorySharingDevicesTableViewController.h"
#import "EditMachineVirtioFileSystemDeviceViewController.h"

@interface EditMachineConfigurationDirectorySharingViewController () <EditMachineConfigurationDirectorySharingDevicesTableViewControllerDelegate, EditMachineVirtioFileSystemDeviceViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableViewController) EditMachineConfigurationDirectorySharingDevicesTableViewController *directorySharingDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableSplitViewItem) NSSplitViewItem *directorySharingDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioFileSystemDeviceViewController) EditMachineVirtioFileSystemDeviceViewController *virtioFileSystemDeviceViewController;
@property (retain, nonatomic, readonly, getter=_virtioFileSystemDeviceSplitViewItem) NSSplitViewItem *virtioFileSystemDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyDeviceViewController) NSViewController *emptyDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyDeviceSplitViewItem) NSSplitViewItem *emptyDeviceSplitViewItem;

@property (assign, nonatomic, getter=_selectedDeviceIndex, setter=_setSelectedDeviceIndex:) NSInteger selectedDeviceIndex;
@end

@implementation EditMachineConfigurationDirectorySharingViewController
@synthesize splitViewController = _splitViewController;
@synthesize directorySharingDevicesTableViewController = _directorySharingDevicesTableViewController;
@synthesize directorySharingDevicesTableSplitViewItem = _directorySharingDevicesTableSplitViewItem;
@synthesize virtioFileSystemDeviceViewController = _virtioFileSystemDeviceViewController;
@synthesize virtioFileSystemDeviceSplitViewItem = _virtioFileSystemDeviceSplitViewItem;
@synthesize emptyDeviceViewController = _emptyDeviceViewController;
@synthesize emptyDeviceSplitViewItem = _emptyDeviceSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedDeviceIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
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
    
    [self _didChangeConfiguration];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    self.directorySharingDevicesTableViewController.directorySharingDevices = self.configuration.directorySharingDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineConfigurationDirectorySharingDevicesTableViewController *)_directorySharingDevicesTableViewController {
    if (auto directorySharingDevicesTableViewController = _directorySharingDevicesTableViewController) return directorySharingDevicesTableViewController;
    
    EditMachineConfigurationDirectorySharingDevicesTableViewController *directorySharingDevicesTableViewController = [EditMachineConfigurationDirectorySharingDevicesTableViewController new];
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
    virtioFileSystemDeviceViewController.delegate = self;
    
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

- (void)editMachineConfigurationDirectorySharingDevicesTableViewController:(EditMachineConfigurationDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.emptyDeviceSplitViewItem];
        return;
    }
    
    __kindof VZDirectorySharingDeviceConfiguration *directorySharingDevice = self.configuration.directorySharingDevices[selectedIndex];
    
    if ([directorySharingDevice isKindOfClass:[VZVirtioFileSystemDeviceConfiguration class]]) {
        self.virtioFileSystemDeviceViewController.configuration = directorySharingDevice;
        self.splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem, self.virtioFileSystemDeviceSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachineConfigurationDirectorySharingDevicesTableViewController:(EditMachineConfigurationDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didUpdateDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.directorySharingDevices = directorySharingDevices;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationDirectorySharingViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineVirtioFileSystemDeviceViewController:(nonnull EditMachineVirtioFileSystemDeviceViewController *)editMachineVirtioFileSystemDeviceViewController didChangeConfiguration:(nonnull VZVirtioFileSystemDeviceConfiguration *)configuration { 
    NSInteger selectedDeviceIndex = self.selectedDeviceIndex;
    assert((selectedDeviceIndex != NSNotFound) and (selectedDeviceIndex != -1));
    
    VZVirtualMachineConfiguration *_configuration = [self.configuration copy];
    
    NSMutableArray<VZDirectorySharingDeviceConfiguration *> *directorySharingDevices = [_configuration.directorySharingDevices mutableCopy];
    [directorySharingDevices removeObjectAtIndex:selectedDeviceIndex];
    [directorySharingDevices insertObject:configuration atIndex:selectedDeviceIndex];
    _configuration.directorySharingDevices = directorySharingDevices;
    [directorySharingDevices release];
    
    self.configuration = _configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineConfigurationDirectorySharingViewController:self didUpdateConfiguration:_configuration];
    }
    
    [_configuration release];
}

@end
