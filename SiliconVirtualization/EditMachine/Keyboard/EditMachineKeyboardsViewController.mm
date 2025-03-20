//
//  EditMachineKeyboardsViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "EditMachineKeyboardsViewController.h"
#import "EditMachineKeyboardsTableViewController.h"
#import "EditMachineUSBKeyboardViewController.h"
#import "EditMachineMacKeyboardViewController.h"

@interface EditMachineKeyboardsViewController () <EditMachineKeyboardsTableViewControllerDelegate, EditMachineMacKeyboardViewControllerDelegate, EditMachineUSBKeyboardViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_keyboardsTableViewController) EditMachineKeyboardsTableViewController *keyboardsTableViewController;
@property (retain, nonatomic, readonly, getter=_keyboardsTableSplitViewItem) NSSplitViewItem *keyboardsTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_USBKeyboardViewController) EditMachineUSBKeyboardViewController *USBKeyboardViewController;
@property (retain, nonatomic, readonly, getter=_USBKeyboardSplitViewItem) NSSplitViewItem *USBKeyboardSplitViewItem;

@property (retain, nonatomic, readonly, getter=_macKeyboardViewController) EditMachineMacKeyboardViewController *macKeyboardViewController;
@property (retain, nonatomic, readonly, getter=_macKeyboardSplitViewItem) NSSplitViewItem *macKeyboardSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyKeyboardViewController) NSViewController *emptyKeyboardViewController;
@property (retain, nonatomic, readonly, getter=_emptyKeyboardSplitViewItem) NSSplitViewItem *emptyKeyboardSplitViewItem;

@property (assign, nonatomic, getter=_selectedKeyboardIndex, setter=_setSelectedKeyboardIndex:) NSInteger selectedKeyboardIndex;
@end

@implementation EditMachineKeyboardsViewController
@synthesize splitViewController = _splitViewController;
@synthesize keyboardsTableViewController = _keyboardsTableViewController;
@synthesize keyboardsTableSplitViewItem = _keyboardsTableSplitViewItem;
@synthesize USBKeyboardViewController = _USBKeyboardViewController;
@synthesize USBKeyboardSplitViewItem = _USBKeyboardSplitViewItem;
@synthesize macKeyboardViewController = _macKeyboardViewController;
@synthesize macKeyboardSplitViewItem = _macKeyboardSplitViewItem;
@synthesize emptyKeyboardViewController = _emptyKeyboardViewController;
@synthesize emptyKeyboardSplitViewItem = _emptyKeyboardSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedKeyboardIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_keyboardsTableViewController release];
    [_keyboardsTableSplitViewItem release];
    [_USBKeyboardViewController release];
    [_USBKeyboardSplitViewItem release];
    [_macKeyboardViewController release];
    [_macKeyboardSplitViewItem release];
    [_emptyKeyboardViewController release];
    [_emptyKeyboardSplitViewItem release];
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
    self.keyboardsTableViewController.keyboards = self.configuration.keyboards;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.keyboardsTableSplitViewItem, self.emptyKeyboardSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineKeyboardsTableViewController *)_keyboardsTableViewController {
    if (auto keyboardsTableViewController = _keyboardsTableViewController) return keyboardsTableViewController;
    
    EditMachineKeyboardsTableViewController *keyboardsTableViewController = [EditMachineKeyboardsTableViewController new];
    keyboardsTableViewController.delegate = self;
    
    _keyboardsTableViewController = keyboardsTableViewController;
    return keyboardsTableViewController;
}

- (NSSplitViewItem *)_keyboardsTableSplitViewItem {
    if (auto keyboardsTableSplitViewItem = _keyboardsTableSplitViewItem) return keyboardsTableSplitViewItem;
    
    NSSplitViewItem *keyboardsTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.keyboardsTableViewController];
    
    _keyboardsTableSplitViewItem = [keyboardsTableSplitViewItem retain];
    return keyboardsTableSplitViewItem;
}

- (EditMachineMacKeyboardViewController *)_macKeyboardViewController {
    if (auto macKeyboardViewController = _macKeyboardViewController) return macKeyboardViewController;
    
    EditMachineMacKeyboardViewController *macKeyboardViewController = [EditMachineMacKeyboardViewController new];
    macKeyboardViewController.delegate = self;
    
    _macKeyboardViewController = macKeyboardViewController;
    return macKeyboardViewController;
}

- (NSSplitViewItem *)_macKeyboardSplitViewItem {
    if (auto macKeyboardSplitViewItem = _macKeyboardSplitViewItem) return macKeyboardSplitViewItem;
    
    NSSplitViewItem *macKeyboardSplitViewItem = [NSSplitViewItem contentListWithViewController:self.macKeyboardViewController];
    
    _macKeyboardSplitViewItem = [macKeyboardSplitViewItem retain];
    return macKeyboardSplitViewItem;
}

- (EditMachineUSBKeyboardViewController *)_USBKeyboardViewController {
    if (auto USBKeyboardViewController = _USBKeyboardViewController) return USBKeyboardViewController;
    
    EditMachineUSBKeyboardViewController *USBKeyboardViewController = [EditMachineUSBKeyboardViewController new];
    USBKeyboardViewController.delegate = self;
    
    _USBKeyboardViewController = USBKeyboardViewController;
    return USBKeyboardViewController;
}

- (NSSplitViewItem *)_USBKeyboardSplitViewItem {
    if (auto USBKeyboardSplitViewItem = _USBKeyboardSplitViewItem) return USBKeyboardSplitViewItem;
    
    NSSplitViewItem *USBKeyboardSplitViewItem = [NSSplitViewItem contentListWithViewController:self.USBKeyboardViewController];
    
    _USBKeyboardSplitViewItem = [USBKeyboardSplitViewItem retain];
    return USBKeyboardSplitViewItem;
}

- (NSViewController *)_emptyKeyboardViewController {
    if (auto emptyKeyboardViewController = _emptyKeyboardViewController) return emptyKeyboardViewController;
    
    NSViewController *emptyKeyboardViewController = [NSViewController new];
    
    _emptyKeyboardViewController = emptyKeyboardViewController;
    return emptyKeyboardViewController;
}

- (NSSplitViewItem *)_emptyKeyboardSplitViewItem {
    if (auto emptyKeyboardSplitViewItem = _emptyKeyboardSplitViewItem) return emptyKeyboardSplitViewItem;
    
    NSSplitViewItem *emptyKeyboardSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyKeyboardViewController];
    
    _emptyKeyboardSplitViewItem = [emptyKeyboardSplitViewItem retain];
    return emptyKeyboardSplitViewItem;
}

- (void)editMachineKeyboardsTableViewController:(EditMachineKeyboardsTableViewController *)editMachineKeyboardsTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedKeyboardIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.keyboardsTableSplitViewItem, self.emptyKeyboardSplitViewItem];
        return;
    }
    
    __kindof VZKeyboardConfiguration *keyboard = self.configuration.keyboards[selectedIndex];
    
    if ([keyboard isKindOfClass:[VZUSBKeyboardConfiguration class]]) {
        auto USBKeyboardConfiguration = static_cast<VZUSBKeyboardConfiguration *>(keyboard);
        self.USBKeyboardViewController.USBKeyboardConfiguration = USBKeyboardConfiguration;
        self.splitViewController.splitViewItems = @[self.keyboardsTableSplitViewItem, self.USBKeyboardSplitViewItem];
    } else if ([keyboard isKindOfClass:[VZMacKeyboardConfiguration class]]) {
        auto macKeyboardConfiguration = static_cast<VZMacKeyboardConfiguration *>(keyboard);
        self.macKeyboardViewController.macKeyboardConfiguration = macKeyboardConfiguration;
        self.splitViewController.splitViewItems = @[self.keyboardsTableSplitViewItem, self.macKeyboardSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachineKeyboardsTableViewController:(EditMachineKeyboardsTableViewController *)editMachineKeyboardsTableViewController didUpdateKeyboards:(NSArray<__kindof VZKeyboardConfiguration *> *)keyboards {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.keyboards = keyboards;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineKeyboardsViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineUSBKeyboardViewController:(EditMachineUSBKeyboardViewController *)editMachineUSBKeyboardViewController didUpdateKeyboardConfiguration:(VZUSBKeyboardConfiguration *)USBKeyboardConfiguration {
    [self _updateMachineConfigurationWithKeyboardConfiguration:USBKeyboardConfiguration];
}

- (void)editMachineMacKeyboardViewController:(EditMachineMacKeyboardViewController *)editMachineMacKeyboardViewController didUpdateKeyboardConfiguration:(VZMacKeyboardConfiguration *)macKeyboardConfiguration {
    [self _updateMachineConfigurationWithKeyboardConfiguration:macKeyboardConfiguration];
}

- (void)_updateMachineConfigurationWithKeyboardConfiguration:(__kindof VZKeyboardConfiguration *)keyboardConfiguration {
    NSInteger selectedKeyboardIndex = self.selectedKeyboardIndex;
    assert((selectedKeyboardIndex != NSNotFound) and (selectedKeyboardIndex != -1));
    
    VZVirtualMachineConfiguration *machineConfiguration = [self.configuration copy];
    
    NSMutableArray<__kindof VZKeyboardConfiguration *> *keyboards = [machineConfiguration.keyboards mutableCopy];
    [keyboards removeObjectAtIndex:selectedKeyboardIndex];
    [keyboards insertObject:keyboardConfiguration atIndex:selectedKeyboardIndex];
    machineConfiguration.keyboards = keyboards;
    [keyboards release];
    
    self.configuration = machineConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineKeyboardsViewController:self didUpdateConfiguration:machineConfiguration];
    }
    
    [machineConfiguration release];
}

@end
