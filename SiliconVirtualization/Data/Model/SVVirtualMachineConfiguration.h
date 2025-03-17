//
//  SVVirtualMachineConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVGraphicsDevices;
@class SVStorageDeviceConfiguration;

@interface SVVirtualMachineConfiguration : NSManagedObject
+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSNumber *cpuCount;
@property (retain, nonatomic, nullable) NSNumber *memorySize;
@property (retain, nonatomic, nullable) NSOrderedSet<SVGraphicsDevices *> *graphicsDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVStorageDeviceConfiguration *> *storageDevices;

- (void)insertObject:(SVGraphicsDevices *)value inGraphicsDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGraphicsDevicesAtIndex:(NSUInteger)idx;
- (void)insertGraphicsDevices:(NSArray<SVGraphicsDevices *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGraphicsDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGraphicsDevicesAtIndex:(NSUInteger)idx withObject:(SVGraphicsDevices *)value;
- (void)replaceGraphicsDevicesAtIndexes:(NSIndexSet *)indexes withGraphicsDevices:(NSArray<SVGraphicsDevices *> *)values;
- (void)addGraphicsDevicesObject:(SVGraphicsDevices *)value;
- (void)removeGraphicsDevicesObject:(SVGraphicsDevices *)value;
- (void)addGraphicsDevices:(NSOrderedSet<SVGraphicsDevices *> *)values;
- (void)removeGraphicsDevices:(NSOrderedSet<SVGraphicsDevices *> *)values;

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
