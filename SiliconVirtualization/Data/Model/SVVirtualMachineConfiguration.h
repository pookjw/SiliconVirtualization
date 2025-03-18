//
//  SVVirtualMachineConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>
#import "SVGraphicsDeviceConfiguration.h"
#import "SVStorageDeviceConfiguration.h"
#import "SVBootLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtualMachineConfiguration : NSManagedObject
+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSNumber *cpuCount;
@property (retain, nonatomic, nullable) NSNumber *memorySize;
@property (copy, nonatomic, nullable) NSDate *timestamp;
@property (retain, nonatomic, nullable) SVBootLoader *bootLoader;
@property (retain, nonatomic, nullable) NSOrderedSet<SVGraphicsDeviceConfiguration *> *graphicsDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVStorageDeviceConfiguration *> *storageDevices;

- (void)insertObject:(SVGraphicsDeviceConfiguration *)value inGraphicsDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGraphicsDevicesAtIndex:(NSUInteger)idx;
- (void)insertGraphicsDevices:(NSArray<SVGraphicsDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGraphicsDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGraphicsDevicesAtIndex:(NSUInteger)idx withObject:(SVGraphicsDeviceConfiguration *)value;
- (void)replaceGraphicsDevicesAtIndexes:(NSIndexSet *)indexes withGraphicsDevices:(NSArray<SVGraphicsDeviceConfiguration *> *)values;
- (void)addGraphicsDevicesObject:(SVGraphicsDeviceConfiguration *)value;
- (void)removeGraphicsDevicesObject:(SVGraphicsDeviceConfiguration *)value;
- (void)addGraphicsDevices:(NSOrderedSet<SVGraphicsDeviceConfiguration *> *)values;
- (void)removeGraphicsDevices:(NSOrderedSet<SVGraphicsDeviceConfiguration *> *)values;

- (void)insertObject:(SVStorageDeviceConfiguration *)value inStorageDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStorageDevicesAtIndex:(NSUInteger)idx;
- (void)insertStorageDevices:(NSArray<SVStorageDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStorageDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStorageDevicesAtIndex:(NSUInteger)idx withObject:(SVStorageDeviceConfiguration *)value;
- (void)replaceStorageDevicesAtIndexes:(NSIndexSet *)indexes withStorageDevices:(NSArray<SVStorageDeviceConfiguration *> *)values;
- (void)addStorageDevicesObject:(SVStorageDeviceConfiguration *)value;
- (void)removeStorageDevicesObject:(SVStorageDeviceConfiguration *)value;
- (void)addStorageDevices:(NSOrderedSet<SVStorageDeviceConfiguration *> *)values;
- (void)removeStorageDevices:(NSOrderedSet<SVStorageDeviceConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
