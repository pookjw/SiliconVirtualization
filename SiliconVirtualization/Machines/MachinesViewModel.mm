//
//  MachinesViewModel.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "MachinesViewModel.h"
#import "SVCoreDataStack.h"

@interface MachinesViewModel () <NSFetchedResultsControllerDelegate>
@property (retain, nonatomic, readonly, getter=_dataSource) NSCollectionViewDiffableDataSource<NSString *, NSManagedObjectID *> *dataSource;
@property (retain, nonatomic, getter=_isolated_fetchedResultsController, setter=_isolated_setFetchedResultsController:) NSFetchedResultsController<SVVirtualMachineConfiguration *> *isolated_fetchedResultsController;
@end

@implementation MachinesViewModel

- (instancetype)initWithDataSource:(NSCollectionViewDiffableDataSource<NSString *, NSManagedObjectID *> *)dataSource {
    if (self = [super init]) {
        _dataSource = [dataSource retain];
        
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didInitializeCoreDataStack:) name:SVCoreDataStackDidInitializeNotification object:SVCoreDataStack.sharedInstance];
        if (SVCoreDataStack.sharedInstance.initialized) {
            [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
                [self _isolated_setupFetchedResultsControllerIfNeeded];
            }];
        }
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_dataSource release];
    [_isolated_fetchedResultsController release];
    [super dealloc];
}

- (void)_didInitializeCoreDataStack:(NSNotification *)notification {
    [SVCoreDataStack.sharedInstance.backgroundContext performBlock:^{
        [self _isolated_setupFetchedResultsControllerIfNeeded];
    }];
}

- (SVVirtualMachineConfiguration *)isolated_machineConfigurationObjectAtIndexPath:(NSIndexPath *)indexPath {
    assert(self.isolated_fetchedResultsController != nil);
    return [self.isolated_fetchedResultsController objectAtIndexPath:indexPath];
}

- (void)_isolated_setupFetchedResultsControllerIfNeeded {
    assert(self.isolated_fetchedResultsController == nil);
    
    SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
    if (!stack.initialized) return;
    
    NSManagedObjectContext *context = stack.backgroundContext;
    
    NSFetchRequest<SVVirtualMachineConfiguration *> *fetchRequest = [SVVirtualMachineConfiguration fetchRequest];
    fetchRequest.sortDescriptors = @[
        [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES]
    ];
    
    NSFetchedResultsController<SVVirtualMachineConfiguration *> *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                                                managedObjectContext:context
                                                                                                                                  sectionNameKeyPath:nil
                                                                                                                                           cacheName:nil];
    fetchedResultsController.delegate = self;
    
    self.isolated_fetchedResultsController = fetchedResultsController;
    
    NSError * _Nullable error = nil;
    [fetchedResultsController performFetch:&error];
    assert(error == nil);
    
    [fetchedResultsController release];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeContentWithSnapshot:(NSDiffableDataSourceSnapshot<NSString *,NSManagedObjectID *> *)snapshot {
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
}

@end
