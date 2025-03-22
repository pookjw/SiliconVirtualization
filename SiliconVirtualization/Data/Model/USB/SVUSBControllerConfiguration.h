//
//  SVUSBControllerConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <CoreData/CoreData.h>
#import "SVUSBMassStorageDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVUSBControllerConfiguration : NSManagedObject
+ (NSFetchRequest<SVUSBControllerConfiguration *> *)fetchRequest;

@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@property (retain, nonatomic, nullable) NSOrderedSet<SVUSBMassStorageDeviceConfiguration *> *usbMassStorageDevices;

- (void)insertObject:(SVUSBMassStorageDeviceConfiguration *)value inUsbMassStorageDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUsbMassStorageDevicesAtIndex:(NSUInteger)idx;
- (void)insertUsbMassStorageDevices:(NSArray<SVUSBMassStorageDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUsbMassStorageDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUsbMassStorageDevicesAtIndex:(NSUInteger)idx withObject:(SVUSBMassStorageDeviceConfiguration *)value;
- (void)replaceUsbMassStorageDevicesAtIndexes:(NSIndexSet *)indexes withUsbMassStorageDevices:(NSArray<SVUSBMassStorageDeviceConfiguration *> *)values;
- (void)addUsbMassStorageDevicesObject:(SVUSBMassStorageDeviceConfiguration *)value;
- (void)removeUsbMassStorageDevicesObject:(SVUSBMassStorageDeviceConfiguration *)value;
- (void)addUsbMassStorageDevices:(NSOrderedSet<SVUSBMassStorageDeviceConfiguration *> *)values;
- (void)removeUsbMassStorageDevices:(NSOrderedSet<SVUSBMassStorageDeviceConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
