//
//  EditMachineMacAcceleratorDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineMacAcceleratorDevicesViewController.h"
#import "EditMachineMacAcceleratorDevicesTableViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineMacAcceleratorDevicesViewController () <EditMachineMacAcceleratorDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_acceleratorDevicesTableViewController) EditMachineMacAcceleratorDevicesTableViewController *acceleratorDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_acceleratorDevicesTableSplitViewItem) NSSplitViewItem *acceleratorDevicesTableSplitViewItem;
@end

@implementation EditMachineMacAcceleratorDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize acceleratorDevicesTableViewController = _acceleratorDevicesTableViewController;
@synthesize acceleratorDevicesTableSplitViewItem = _acceleratorDevicesTableSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_acceleratorDevicesTableViewController release];
    [_acceleratorDevicesTableSplitViewItem release];
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
    NSArray *acceleratorDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_acceleratorDevices"));
    self.acceleratorDevicesTableViewController.acceleratorDevices = acceleratorDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.acceleratorDevicesTableSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineMacAcceleratorDevicesTableViewController *)_acceleratorDevicesTableViewController {
    if (auto acceleratorDevicesTableViewController = _acceleratorDevicesTableViewController) return acceleratorDevicesTableViewController;
    
    EditMachineMacAcceleratorDevicesTableViewController *acceleratorDevicesTableViewController = [EditMachineMacAcceleratorDevicesTableViewController new];
    acceleratorDevicesTableViewController.delegate = self;
    
    _acceleratorDevicesTableViewController = acceleratorDevicesTableViewController;
    return acceleratorDevicesTableViewController;
}

- (NSSplitViewItem *)_acceleratorDevicesTableSplitViewItem {
    if (auto acceleratorDevicesTableSplitViewItem = _acceleratorDevicesTableSplitViewItem) return acceleratorDevicesTableSplitViewItem;
    
    NSSplitViewItem *acceleratorDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.acceleratorDevicesTableViewController];
    
    _acceleratorDevicesTableSplitViewItem = [acceleratorDevicesTableSplitViewItem retain];
    return acceleratorDevicesTableSplitViewItem;
}

- (void)editMachineMacAcceleratorDevicesTableViewController:(EditMachineMacAcceleratorDevicesTableViewController *)editMachineMacAcceleratorDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    
}

- (void)editMachineMacAcceleratorDevicesTableViewController:(EditMachineMacAcceleratorDevicesTableViewController *)editMachineMacAcceleratorDevicesTableViewController didUpdateAcceleratorDevices:(NSArray *)acceleratorDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setAcceleratorDevices:"), acceleratorDevices);
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacAcceleratorDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
