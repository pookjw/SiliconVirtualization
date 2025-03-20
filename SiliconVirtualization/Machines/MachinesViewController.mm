//
//  MachinesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "MachinesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>
#import "CreateMachineWindow.h"
#import "MachinesViewModel.h"
#import "MachinesCollectionViewItem.h"
#import "EditMachineConfigurationObjectWindow.h"
#import "SVCoreDataStack+VirtualizationSupport.h"
#import <Virtualization/Virtualization.h>
#import "InstallMacOSViewController.h"
#import "VirtualMachineWindow.h"

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface MachinesViewController () <NSToolbarDelegate, NSCollectionViewDelegate, NSMenuDelegate, InstallMacOSViewControllerDelegate>
@property (class, nonatomic, readonly, getter=_installationKey) void *installationKey;
@property (class, nonatomic, readonly, getter=_itemIdentifier) NSUserInterfaceItemIdentifier itemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_collectionView) NSCollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (retain, nonatomic, readonly, getter=_viewModel) MachinesViewModel *viewModel;
@property (retain, nonatomic, readonly, getter=_dataSource) NSCollectionViewDiffableDataSource<NSString *, NSManagedObjectID *> *dataSource;
@property (copy, nonatomic, nullable, getter=_menuIndexPath, setter=_setMenuIndexPath:) NSIndexPath *menuIndexPath;
@end

@implementation MachinesViewController
@synthesize scrollView = _scrollView;
@synthesize collectionView = _collectionView;
@synthesize toolbar = _toolbar;
@synthesize viewModel = _viewModel;
@synthesize dataSource = _dataSource;

+ (void *)_installationKey {
    static void *key = &key;
    return key;
}

+ (NSUserInterfaceItemIdentifier)_itemIdentifier {
    return NSStringFromClass([MachinesCollectionViewItem class]);
}

- (void)dealloc {
    [_scrollView release];
    [_collectionView release];
    [_toolbar release];
    [_viewModel release];
    [_dataSource release];
    [_menuIndexPath release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
    
    [self _viewModel];
    
    [self _showCreateMachineWindow];
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    
    if (oldWindow) {
        oldWindow.toolbar = nil;
    }
    
    if (newWindow) {
        newWindow.toolbar = self.toolbar;
    }
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.collectionView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSCollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    NSCollectionView *collectionView = [NSCollectionView new];
    
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    NSCollectionViewCompositionalLayout *collectionViewLayout = [[NSCollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> _Nonnull layoutEnvironment) {
        NSUInteger quotient = floorf(layoutEnvironment.container.contentSize.width / 200.);
        NSUInteger count = MAX(quotient, 2);
        
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]
                                                                          heightDimension:[NSCollectionLayoutDimension fractionalHeightDimension:1.]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize];
        item.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1. / count]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup horizontalGroupWithLayoutSize:groupSize subitem:item count:count];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        section.contentInsets = NSDirectionalEdgeInsetsMake(10., 10., 10., 10.);
        
        return section;
    }
                                                                                                                       configuration:configuration];
    [configuration release];
    
    collectionView.collectionViewLayout = collectionViewLayout;
    [collectionViewLayout release];
    
    collectionView.selectable = YES;
    collectionView.allowsEmptySelection = YES;
    collectionView.allowsMultipleSelection = NO;
    collectionView.delegate = self;
    [collectionView registerClass:[MachinesCollectionViewItem class] forItemWithIdentifier:MachinesViewController.itemIdentifier];
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    collectionView.menu = menu;
    [menu release];
    
    _collectionView = collectionView;
    return collectionView;
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"Machines"];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (MachinesViewModel *)_viewModel {
    if (auto viewModel = _viewModel) return viewModel;
    
    MachinesViewModel *viewModel = [[MachinesViewModel alloc] initWithDataSource:self.dataSource];
    
    _viewModel = viewModel;
    return viewModel;
}

- (NSCollectionViewDiffableDataSource<NSString *,NSManagedObjectID *> *)_dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    NSCollectionViewDiffableDataSource<NSString *,NSManagedObjectID *> *dataSource = [[NSCollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, NSManagedObjectID * _Nonnull objectID) {
        MachinesCollectionViewItem *item = [collectionView makeItemWithIdentifier:MachinesViewController.itemIdentifier forIndexPath:indexPath];
        item.objectID = objectID;
        return item;
    }];
    
    _dataSource = dataSource;
    return dataSource;
}

- (NSMenu *)_makeAddMachineMenu {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *createMenuItem = [NSMenuItem new];
    createMenuItem.title = @"Create a new machine...";
    createMenuItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    createMenuItem.target = self;
    createMenuItem.action = @selector(_didTriggerCreateMenuItem:);
    [menu addItem:createMenuItem];
    [createMenuItem release];
    
    return [menu autorelease];
}

- (void)_didTriggerAddMachineToolbarItem:(NSToolbarItem *)sender {
    NSView *_view = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(sender, sel_registerName("_view"));
    
    [NSMenu popUpContextMenu:[self _makeAddMachineMenu]
                   withEvent:_view.window.currentEvent
                     forView:_view];
}

- (void)_didTriggerCreateMenuItem:(NSMenuItem *)sender {
    [self _showCreateMachineWindow];
}

- (void)_showCreateMachineWindow {
    CreateMachineWindow *window = [CreateMachineWindow new];
    [window makeKeyAndOrderFront:nil];
    [window release];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        @"AddMachine"
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        @"AddMachine"
    ];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([itemIdentifier isEqualToString:@"AddMachine"]) {
        NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
        toolbarItem.target = self;
        toolbarItem.action = @selector(_didTriggerAddMachineToolbarItem:);
        toolbarItem.label = @"Add";
        toolbarItem.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
        return [toolbarItem autorelease];
    } else {
        abort();
    }
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    
}

- (void)menuWillOpen:(NSMenu *)menu {
    [menu removeAllItems];
    
    NSCollectionView *collectionView = self.collectionView;
    NSEvent * _Nullable event = collectionView.window.currentEvent;
    if (event == nil) {
        self.menuIndexPath = nil;
        return;
    }
    
    CGPoint point = [collectionView convertPoint:[event locationInWindow] fromView:nil];
    NSIndexPath * _Nullable indexPath = [collectionView indexPathForItemAtPoint:point];
    if (indexPath == nil) {
        self.menuIndexPath = nil;
        return;
    }
    
    self.menuIndexPath = indexPath;
    
    NSMenuItem *editItem = [NSMenuItem new];
    editItem.title = @"Edit";
    editItem.target = self;
    editItem.action = @selector(_didTriggerEditItem:);
    [menu addItem:editItem];
    [editItem release];
    
    NSMenuItem *validateItem = [NSMenuItem new];
    validateItem.title = @"Validate";
    validateItem.target = self;
    validateItem.action = @selector(_didTriggerValidateItem:);
    [menu addItem:validateItem];
    [validateItem release];
    
    NSMenuItem *installMacOSItem = [NSMenuItem new];
    installMacOSItem.title = @"Install macOS";
    installMacOSItem.target = self;
    installMacOSItem.action = @selector(_didTriggerInstallMacOSItem:);
    [menu addItem:installMacOSItem];
    [installMacOSItem release];
    
    NSMenuItem *runItem = [NSMenuItem new];
    runItem.title = @"Run";
    runItem.target = self;
    runItem.action = @selector(_didTriggerRunItem:);
    [menu addItem:runItem];
    [runItem release];
}

- (void)_didTriggerEditItem:(NSMenuItem *)sender {
    NSIndexPath *menuIndexPath = self.menuIndexPath;
    assert(menuIndexPath != nil);
    
    [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        SVVirtualMachineConfiguration *machineConfigurationObject = [self.viewModel isolated_machineConfigurationObjectAtIndexPath:menuIndexPath];
        assert(machineConfigurationObject != nil);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            EditMachineConfigurationObjectWindow *window = [[EditMachineConfigurationObjectWindow alloc] initWithMachineConfigurationObject:machineConfigurationObject];
            [window makeKeyAndOrderFront:nil];
            [window release];
        });
    }];
    
    self.menuIndexPath = nil;
}

- (void)_didTriggerValidateItem:(NSMenuItem *)sender {
    NSIndexPath *menuIndexPath = self.menuIndexPath;
    assert(menuIndexPath != nil);
    
    [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        SVVirtualMachineConfiguration *machineConfigurationObject = [self.viewModel isolated_machineConfigurationObjectAtIndexPath:menuIndexPath];
        assert(machineConfigurationObject != nil);
        
        VZVirtualMachineConfiguration *configuration = [SVCoreDataStack.sharedInstance isolated_makeVirtualMachineConfigurationFromManagedObject:machineConfigurationObject];
        
        NSError * _Nullable error = nil;
        [configuration validateWithError:&error];
        
        if (error == nil) {
            [configuration validateSaveRestoreSupportWithError:&error];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAlert *alert = [NSAlert new];
            
            if (error != nil) {
                alert.messageText = @"ERROR";
                alert.informativeText = error.description;
            } else {
                alert.messageText = @"No Error";
            }
            
            [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                
            }];
            [alert release];
        });
    }];
    
    self.menuIndexPath = nil;
}

- (void)_didTriggerInstallMacOSItem:(NSMenuItem *)sender {
    NSIndexPath *menuIndexPath = self.menuIndexPath;
    assert(menuIndexPath != nil);
    
    [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        SVVirtualMachineConfiguration *machineConfigurationObject = [self.viewModel isolated_machineConfigurationObjectAtIndexPath:menuIndexPath];
        assert(machineConfigurationObject != nil);
        
        VZVirtualMachineConfiguration *configuration = [SVCoreDataStack.sharedInstance isolated_makeVirtualMachineConfigurationFromManagedObject:machineConfigurationObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            InstallMacOSViewController *viewController = [[InstallMacOSViewController alloc] initWithVirtualMachineConfiguration:configuration];
            objc_setAssociatedObject(viewController, MachinesViewController.installationKey, [NSNull null], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            viewController.delegate = self;
            [self presentViewControllerAsSheet:viewController];
            [viewController release];
        });
    }];
    
    self.menuIndexPath = nil;
}

- (void)_didTriggerRunItem:(NSMenuItem *)sender {
    NSIndexPath *menuIndexPath = self.menuIndexPath;
    assert(menuIndexPath != nil);
    
    [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        SVVirtualMachineConfiguration *machineConfigurationObject = [self.viewModel isolated_machineConfigurationObjectAtIndexPath:menuIndexPath];
        assert(machineConfigurationObject != nil);
        
        VZVirtualMachineConfiguration *configuration = [SVCoreDataStack.sharedInstance isolated_makeVirtualMachineConfigurationFromManagedObject:machineConfigurationObject];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            VirtualMachineWindow *window = [[VirtualMachineWindow alloc] initWithMachineConfiguration:configuration];
            [window makeKeyAndOrderFront:nil];
            [window release];
        });
    }];
    
    self.menuIndexPath = nil;
}

- (void)installMacOSViewController:(InstallMacOSViewController *)installMacOSViewController didCompleteInstallationWithError:(NSError *)error {
    assert(error == nil);
    [self _dismissInstallMacOSViewControllers];
}

- (void)_dismissInstallMacOSViewControllers {
    for (NSViewController *presentedViewController in self.presentedViewControllers) {
        if (objc_getAssociatedObject(presentedViewController, MachinesViewController.installationKey)) {
            [self dismissViewController:presentedViewController];
        }
    }
}

@end
