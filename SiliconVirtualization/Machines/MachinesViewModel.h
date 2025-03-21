//
//  MachinesViewModel.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <Cocoa/Cocoa.h>
#import "Model.h"

NS_ASSUME_NONNULL_BEGIN

@interface MachinesViewModel : NSObject
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDataSource:(NSCollectionViewDiffableDataSource<NSString *, NSManagedObjectID *> *)dataSource;
- (SVVirtualMachine * _Nullable)isolated_virtualMachineObjectAtIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
