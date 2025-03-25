//
//  EditMachineBiometricDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineBiometricDevicesViewController.h"
#import "EditMachineBiometricDevicesTableViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineBiometricDevicesViewController () <EditMachineBiometricDevicesTableViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_biometricDevicesTableViewController) EditMachineBiometricDevicesTableViewController *biometricDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_biometricDevicesTableSplitViewItem) NSSplitViewItem *biometricDevicesTableSplitViewItem;
@end

@implementation EditMachineBiometricDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize biometricDevicesTableViewController = _biometricDevicesTableViewController;
@synthesize biometricDevicesTableSplitViewItem = _biometricDevicesTableSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_biometricDevicesTableViewController release];
    [_biometricDevicesTableSplitViewItem release];
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
    NSArray *biometricDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_biometricDevices"));
    self.biometricDevicesTableViewController.biometricDevices = biometricDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.biometricDevicesTableSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineBiometricDevicesTableViewController *)_biometricDevicesTableViewController {
    if (auto biometricDevicesTableViewController = _biometricDevicesTableViewController) return biometricDevicesTableViewController;
    
    EditMachineBiometricDevicesTableViewController *biometricDevicesTableViewController = [EditMachineBiometricDevicesTableViewController new];
    biometricDevicesTableViewController.delegate = self;
    
    _biometricDevicesTableViewController = biometricDevicesTableViewController;
    return biometricDevicesTableViewController;
}

- (NSSplitViewItem *)_biometricDevicesTableSplitViewItem {
    if (auto biometricDevicesTableSplitViewItem = _biometricDevicesTableSplitViewItem) return biometricDevicesTableSplitViewItem;
    
    NSSplitViewItem *biometricDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.biometricDevicesTableViewController];
    
    _biometricDevicesTableSplitViewItem = [biometricDevicesTableSplitViewItem retain];
    return biometricDevicesTableSplitViewItem;
}

- (void)editMachineBiometricDevicesTableViewController:(EditMachineBiometricDevicesTableViewController *)editMachineAudioDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    
}

- (void)editMachineAudioDevicesTableViewController:(EditMachineBiometricDevicesTableViewController *)editMachineAudioDevicesTableViewController didUpdateBiometricDevices:(NSArray *)biometricDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setBiometricDevices:"), biometricDevices);
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineBiometricDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
