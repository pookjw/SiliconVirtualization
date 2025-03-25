//
//  EditMachineCoprocessorsViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineCoprocessorsViewController.h"
#import "EditMachineCoprocessorsTableViewController.h"
#import "EditMachineSEPCoprocessorViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineCoprocessorsViewController () <EditMachineCoprocessorsTableViewControllerDelegate, EditMachineSEPCoprocessorViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_coprocessorsTableViewController) EditMachineCoprocessorsTableViewController *coprocessorsTableViewController;
@property (retain, nonatomic, readonly, getter=_coprocessorsTableSplitViewItem) NSSplitViewItem *coprocessorsTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_SEPCoprocessorViewController) EditMachineSEPCoprocessorViewController *SEPCoprocessorViewController;
@property (retain, nonatomic, readonly, getter=_SEPCoprocessorSplitViewItem) NSSplitViewItem *SEPCoprocessorSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyCoprocessorViewController) NSViewController *emptyCoprocessorViewController;
@property (retain, nonatomic, readonly, getter=_emptyCoprocessorSplitViewItem) NSSplitViewItem *emptyCoprocessorSplitViewItem;

@property (assign, nonatomic, getter=_selectedCoprocessorIndex, setter=_setSelectedCoprocessorIndex:) NSInteger selectedCoprocessorIndex;
@end

@implementation EditMachineCoprocessorsViewController
@synthesize splitViewController = _splitViewController;
@synthesize coprocessorsTableViewController = _coprocessorsTableViewController;
@synthesize coprocessorsTableSplitViewItem = _coprocessorsTableSplitViewItem;
@synthesize SEPCoprocessorViewController = _SEPCoprocessorViewController;
@synthesize SEPCoprocessorSplitViewItem = _SEPCoprocessorSplitViewItem;
@synthesize emptyCoprocessorViewController = _emptyCoprocessorViewController;
@synthesize emptyCoprocessorSplitViewItem = _emptyCoprocessorSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedCoprocessorIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_coprocessorsTableViewController release];
    [_coprocessorsTableSplitViewItem release];
    [_SEPCoprocessorViewController release];
    [_SEPCoprocessorSplitViewItem release];
    [_emptyCoprocessorViewController release];
    [_emptyCoprocessorSplitViewItem release];
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
    NSArray *coprocessors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_coprocessors"));
    self.coprocessorsTableViewController.coprocessors = coprocessors;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.coprocessorsTableSplitViewItem, self.emptyCoprocessorSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineCoprocessorsTableViewController *)_coprocessorsTableViewController {
    if (auto coprocessorsTableViewController = _coprocessorsTableViewController) return coprocessorsTableViewController;
    
    EditMachineCoprocessorsTableViewController *coprocessorsTableViewController = [EditMachineCoprocessorsTableViewController new];
    coprocessorsTableViewController.delegate = self;
    
    _coprocessorsTableViewController = coprocessorsTableViewController;
    return coprocessorsTableViewController;
}

- (NSSplitViewItem *)_coprocessorsTableSplitViewItem {
    if (auto coprocessorsTableSplitViewItem = _coprocessorsTableSplitViewItem) return coprocessorsTableSplitViewItem;
    
    NSSplitViewItem *coprocessorsTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.coprocessorsTableViewController];
    
    _coprocessorsTableSplitViewItem = [coprocessorsTableSplitViewItem retain];
    return coprocessorsTableSplitViewItem;
}

- (EditMachineSEPCoprocessorViewController *)_SEPCoprocessorViewController {
    if (auto SEPCoprocessorViewController = _SEPCoprocessorViewController) return SEPCoprocessorViewController;
    
    EditMachineSEPCoprocessorViewController *SEPCoprocessorViewController = [EditMachineSEPCoprocessorViewController new];
    SEPCoprocessorViewController.delegate = self;
    
    _SEPCoprocessorViewController = SEPCoprocessorViewController;
    return SEPCoprocessorViewController;
}

- (NSSplitViewItem *)_SEPCoprocessorSplitViewItem {
    if (auto SEPCoprocessorSplitViewItem = _SEPCoprocessorSplitViewItem) return SEPCoprocessorSplitViewItem;
    
    NSSplitViewItem *SEPCoprocessorSplitViewItem = [NSSplitViewItem contentListWithViewController:self.SEPCoprocessorViewController];
    
    _SEPCoprocessorSplitViewItem = [SEPCoprocessorSplitViewItem retain];
    return SEPCoprocessorSplitViewItem;
}

- (NSViewController *)_emptyCoprocessorViewController {
    if (auto emptyCoprocessorViewController = _emptyCoprocessorViewController) return emptyCoprocessorViewController;
    
    NSViewController *emptyCoprocessorViewController = [NSViewController new];
    
    _emptyCoprocessorViewController = emptyCoprocessorViewController;
    return emptyCoprocessorViewController;
}

- (NSSplitViewItem *)_emptyCoprocessorSplitViewItem {
    if (auto emptyCoprocessorSplitViewItem = _emptyCoprocessorSplitViewItem) return emptyCoprocessorSplitViewItem;
    
    NSSplitViewItem *emptyCoprocessorSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyCoprocessorViewController];
    
    _emptyCoprocessorSplitViewItem = [emptyCoprocessorSplitViewItem retain];
    return emptyCoprocessorSplitViewItem;
}

- (void)editMachineCoprocessorsTableViewController:(EditMachineCoprocessorsTableViewController *)editMachineCoprocessorsTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedCoprocessorIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.coprocessorsTableSplitViewItem, self.emptyCoprocessorSplitViewItem];
        return;
    }
    
    NSArray *coprocessors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.configuration, sel_registerName("_coprocessors"));
    id coprocessor = coprocessors[selectedIndex];
    
    if ([coprocessor isKindOfClass:objc_lookUpClass("_VZSEPCoprocessorConfiguration")]) {
        self.SEPCoprocessorViewController.SEPCoprocessorConfigurtion = coprocessor;
        self.splitViewController.splitViewItems = @[self.coprocessorsTableSplitViewItem, self.SEPCoprocessorSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachineCoprocessorsTableViewController:(EditMachineCoprocessorsTableViewController *)editMachineCoprocessorsTableViewController didUpdateCoprocessors:(NSArray *)coprocessors {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setCoprocessors:"), coprocessors);
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineCoprocessorsViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineSEPCoprocessorViewController:(EditMachineSEPCoprocessorViewController *)editMachineSEPCoprocessorViewController didUpdateSEPCoprocessorConfigurtion:(id)SEPCoprocessorConfigurtion {
    NSInteger selectedCoprocessorIndex = self.selectedCoprocessorIndex;
    assert((selectedCoprocessorIndex != NSNotFound) and (selectedCoprocessorIndex != -1));
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    NSMutableArray *coprocessors = [reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(configuration, sel_registerName("_coprocessors")) mutableCopy];
    [coprocessors removeObjectAtIndex:selectedCoprocessorIndex];
    [coprocessors insertObject:SEPCoprocessorConfigurtion atIndex:selectedCoprocessorIndex];
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setCoprocessors:"), coprocessors);
    [coprocessors release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineCoprocessorsViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
