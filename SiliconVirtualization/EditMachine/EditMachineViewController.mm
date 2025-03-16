//
//  EditMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineViewController.h"
#import "EditMachineSidebarViewController.h"
#import "EditMachineCPUViewController.h"
#import "EditMachineMemoryViewController.h"
#import "EditMachineGraphicsViewController.h"
#import "EditMachineStoragesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineViewController () <EditMachineSidebarViewControllerDelegate, EditMachineCPUViewControllerDelegate, EditMachineMemoryViewControllerDelegate, EditMachineGraphicsViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_sidebarViewController) EditMachineSidebarViewController *sidebarViewController;
@property (retain, nonatomic, readonly, getter=_sidebarSplitViewItem) NSSplitViewItem *sidebarSplitViewItem;

@property (retain, nonatomic, readonly, getter=_CPUViewController) EditMachineCPUViewController *CPUViewController;
@property (retain, nonatomic, readonly, getter=_CPUSplitViewItem) NSSplitViewItem *CPUSplitViewItem;

@property (retain, nonatomic, readonly, getter=_memoryViewController) EditMachineMemoryViewController *memoryViewController;
@property (retain, nonatomic, readonly, getter=_memorySplitViewItem) NSSplitViewItem *memorySplitViewItem;

@property (retain, nonatomic, readonly, getter=_graphicsViewController) EditMachineGraphicsViewController *graphicsViewController;
@property (retain, nonatomic, readonly, getter=_graphicsSplitViewItem) NSSplitViewItem *graphicsSplitViewItem;

@property (retain, nonatomic, readonly, getter=_storagesViewController) EditMachineStoragesViewController *storagesViewController;
@property (retain, nonatomic, readonly, getter=_storagesSplitViewItem) NSSplitViewItem *storagesSplitViewItem;
@end

@implementation EditMachineViewController
@synthesize splitViewController = _splitViewController;
@synthesize sidebarViewController = _sidebarViewController;
@synthesize sidebarSplitViewItem = _sidebarSplitViewItem;
@synthesize CPUViewController = _CPUViewController;
@synthesize CPUSplitViewItem = _CPUSplitViewItem;
@synthesize memoryViewController = _memoryViewController;
@synthesize memorySplitViewItem = _memorySplitViewItem;
@synthesize graphicsViewController = _graphicsViewController;
@synthesize graphicsSplitViewItem = _graphicsSplitViewItem;
@synthesize storagesViewController = _storagesViewController;
@synthesize storagesSplitViewItem = _storagesSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super init]) {
        self.configuration = configuration;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_sidebarViewController release];
    [_sidebarSplitViewItem release];
    [_CPUViewController release];
    [_CPUSplitViewItem release];
    [_memoryViewController release];
    [_memorySplitViewItem release];
    [_graphicsViewController release];
    [_graphicsSplitViewItem release];
    [_storagesViewController release];
    [_storagesSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    [self addChildViewController:splitViewController];
    
    EditMachineSidebarItemModel *itemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeStorages];
    [self.sidebarViewController setItemModel:itemModel notifyingDelegate:YES];
    [itemModel release];
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
    
    NSSplitViewItem *sidebarSplitViewItem = [NSSplitViewItem sidebarWithViewController:self.sidebarViewController];
    sidebarSplitViewItem.canCollapse = NO;
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(sidebarSplitViewItem, sel_registerName("setMinimumSize:"), 200.);
    
    _sidebarSplitViewItem = [sidebarSplitViewItem retain];
    return sidebarSplitViewItem;
}

- (EditMachineCPUViewController *)_CPUViewController {
    if (auto CPUViewController = _CPUViewController) return CPUViewController;
    
    EditMachineCPUViewController *CPUViewController = [[EditMachineCPUViewController alloc] initWithConfiguration:self.configuration];
    CPUViewController.delegate = self;
    
    _CPUViewController = CPUViewController;
    return CPUViewController;
}

- (NSSplitViewItem *)_CPUSplitViewItem {
    if (auto CPUSplitViewItem = _CPUSplitViewItem) return CPUSplitViewItem;
    
    NSSplitViewItem *CPUSplitViewItem = [NSSplitViewItem contentListWithViewController:self.CPUViewController];
    
    _CPUSplitViewItem = [CPUSplitViewItem retain];
    return CPUSplitViewItem;
}

- (EditMachineMemoryViewController *)_memoryViewController {
    if (auto memoryViewController = _memoryViewController) return memoryViewController;
    
    EditMachineMemoryViewController *memoryViewController = [[EditMachineMemoryViewController alloc] initWithConfiguration:self.configuration];
    memoryViewController.delegate = self;
    
    _memoryViewController = memoryViewController;
    return memoryViewController;
}

- (NSSplitViewItem *)_memorySplitViewItem {
    if (auto memorySplitViewItem = _memorySplitViewItem) return memorySplitViewItem;
    
    NSSplitViewItem *memorySplitViewItem = [NSSplitViewItem contentListWithViewController:self.memoryViewController];
    
    _memorySplitViewItem = [memorySplitViewItem retain];
    return memorySplitViewItem;
}

- (EditMachineGraphicsViewController *)_graphicsViewController {
    if (auto graphicsViewController = _graphicsViewController) return graphicsViewController;
    
    EditMachineGraphicsViewController *graphicsViewController = [[EditMachineGraphicsViewController alloc] initWithConfiguration:self.configuration];
    graphicsViewController.delegate = self;
    
    _graphicsViewController = graphicsViewController;
    return graphicsViewController;
}

- (NSSplitViewItem *)_graphicsSplitViewItem {
    if (auto graphicsSplitViewItem = _graphicsSplitViewItem) return graphicsSplitViewItem;
    
    NSSplitViewItem *graphicsSplitViewItem = [NSSplitViewItem contentListWithViewController:self.graphicsViewController];
    
    _graphicsSplitViewItem = [graphicsSplitViewItem retain];
    return graphicsSplitViewItem;
}

- (EditMachineStoragesViewController *)_storagesViewController {
    if (auto storagesViewController = _storagesViewController) return storagesViewController;
    
    EditMachineStoragesViewController *storagesViewController = [[EditMachineStoragesViewController alloc] initWithConfiguration:self.configuration];
    
    _storagesViewController = storagesViewController;
    return storagesViewController;
}

- (NSSplitViewItem *)_storagesSplitViewItem {
    if (auto storagesSplitViewItem = _storagesSplitViewItem) return storagesSplitViewItem;
    
    NSSplitViewItem *storagesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.storagesViewController];
    
    _storagesSplitViewItem = [storagesSplitViewItem retain];
    return storagesSplitViewItem;
}

- (void)editMachineSidebarViewController:(EditMachineSidebarViewController *)editMachineSidebarViewController didSelectItemModel:(EditMachineSidebarItemModel *)itemModel {
    switch (itemModel.type) {
        case EditMachineSidebarItemModelTypeCPU: {
            self.CPUViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.CPUSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeMemory: {
            self.memoryViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.memorySplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeGraphics: {
            self.graphicsViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.graphicsSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeStorages: {
            self.storagesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.storagesSplitViewItem];
            break;
        }
        default:
            abort();
    }
}

- (void)editMachineCPUViewController:(EditMachineCPUViewController *)editMachineCPUViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
}

- (void)editMachineMemoryViewController:(EditMachineMemoryViewController *)editMachineMemoryViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
}

- (void)editMachineGraphicsViewController:(EditMachineGraphicsViewController *)editMachineGraphicsViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
}

@end
