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
#import "SVPlatformConfiguration.h"
#import "SVKeyboardConfiguration.h"
#import "SVPointingDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachine;

@interface SVVirtualMachineConfiguration : NSManagedObject
+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSNumber *cpuCount;
@property (retain, nonatomic, nullable) NSNumber *memorySize;
@property (retain, nonatomic, nullable) SVBootLoader *bootLoader;
@property (retain, nonatomic, nullable) NSOrderedSet<SVGraphicsDeviceConfiguration *> *graphicsDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVKeyboardConfiguration *> *keyboards;
@property (retain, nonatomic, nullable) SVVirtualMachine *machine;
@property (retain, nonatomic, nullable) SVPlatformConfiguration *platform;
@property (retain, nonatomic, nullable) NSOrderedSet<SVPointingDeviceConfiguration *> *pointingDevices;
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

- (void)insertObject:(SVKeyboardConfiguration *)value inKeyboardsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromKeyboardsAtIndex:(NSUInteger)idx;
- (void)insertKeyboards:(NSArray<SVKeyboardConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeKeyboardsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInKeyboardsAtIndex:(NSUInteger)idx withObject:(SVKeyboardConfiguration *)value;
- (void)replaceKeyboardsAtIndexes:(NSIndexSet *)indexes withKeyboards:(NSArray<SVKeyboardConfiguration *> *)values;
- (void)addKeyboardsObject:(SVKeyboardConfiguration *)value;
- (void)removeKeyboardsObject:(SVKeyboardConfiguration *)value;
- (void)addKeyboards:(NSOrderedSet<SVKeyboardConfiguration *> *)values;
- (void)removeKeyboards:(NSOrderedSet<SVKeyboardConfiguration *> *)values;

- (void)insertObject:(SVPointingDeviceConfiguration *)value inPointingDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPointingDevicesAtIndex:(NSUInteger)idx;
- (void)insertPointingDevices:(NSArray<SVPointingDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePointingDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPointingDevicesAtIndex:(NSUInteger)idx withObject:(SVPointingDeviceConfiguration *)value;
- (void)replacePointingDevicesAtIndexes:(NSIndexSet *)indexes withPointingDevices:(NSArray<SVPointingDeviceConfiguration *> *)values;
- (void)addPointingDevicesObject:(SVPointingDeviceConfiguration *)value;
- (void)removePointingDevicesObject:(SVPointingDeviceConfiguration *)value;
- (void)addPointingDevices:(NSOrderedSet<SVPointingDeviceConfiguration *> *)values;
- (void)removePointingDevices:(NSOrderedSet<SVPointingDeviceConfiguration *> *)values;

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
