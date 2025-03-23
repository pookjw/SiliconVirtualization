//
//  EditMachineDirectorySharingViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineDirectorySharingViewController.h"
#import "EditMachineDirectorySharingDevicesTableViewController.h"

@interface EditMachineDirectorySharingViewController () <EditMachineDirectorySharingDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableViewController) EditMachineDirectorySharingDevicesTableViewController *directorySharingDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_directorySharingDevicesTableSplitViewItem) NSSplitViewItem *directorySharingDevicesTableSplitViewItem;
@end

@implementation EditMachineDirectorySharingViewController
@synthesize splitViewController = _splitViewController;
@synthesize directorySharingDevicesTableViewController = _directorySharingDevicesTableViewController;
@synthesize directorySharingDevicesTableSplitViewItem = _directorySharingDevicesTableSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_directorySharingDevicesTableViewController release];
    [_directorySharingDevicesTableSplitViewItem release];
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
    splitViewController.splitViewItems = @[self.directorySharingDevicesTableSplitViewItem];
    
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

- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    
}

- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didUpdateDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.directorySharingDevices = directorySharingDevices;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineDirectorySharingViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
