//
//  SVVirtioGraphicsDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDeviceConfiguration.h"
#import "SVVirtioGraphicsScanoutConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioGraphicsDeviceConfiguration : SVGraphicsDeviceConfiguration
+ (NSFetchRequest<SVVirtioGraphicsDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSOrderedSet<SVVirtioGraphicsScanoutConfiguration *> *scanouts;
- (void)insertObject:(SVVirtioGraphicsScanoutConfiguration *)value inScanoutsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromScanoutsAtIndex:(NSUInteger)idx;
- (void)insertScanouts:(NSArray<SVVirtioGraphicsScanoutConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeScanoutsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInScanoutsAtIndex:(NSUInteger)idx withObject:(SVVirtioGraphicsScanoutConfiguration *)value;
- (void)replaceScanoutsAtIndexes:(NSIndexSet *)indexes withScanouts:(NSArray<SVVirtioGraphicsScanoutConfiguration *> *)values;
- (void)addScanoutsObject:(SVVirtioGraphicsScanoutConfiguration *)value;
- (void)removeScanoutsObject:(SVVirtioGraphicsScanoutConfiguration *)value;
- (void)addScanouts:(NSOrderedSet<SVVirtioGraphicsScanoutConfiguration *> *)values;
- (void)removeScanouts:(NSOrderedSet<SVVirtioGraphicsScanoutConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
