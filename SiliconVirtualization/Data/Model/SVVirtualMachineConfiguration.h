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
#import "SVNetworkDeviceConfiguration.h"
#import "SVAudioDeviceConfiguration.h"
#import "SVUSBControllerConfiguration.h"
#import "SVDirectorySharingDeviceConfiguration.h"
#import "SVPowerSourceDeviceConfiguration.h"
#import "SVBiometricDeviceConfiguration.h"
#import "SVCoprocessorConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachine;

@interface SVVirtualMachineConfiguration : NSManagedObject
+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSNumber *cpuCount;
@property (retain, nonatomic, nullable) NSNumber *memorySize;
@property (retain, nonatomic, nullable) NSOrderedSet<SVAudioDeviceConfiguration *> *audioDevices;
@property (nullable, nonatomic, retain) NSOrderedSet<SVBiometricDeviceConfiguration *> *biometricDevices;
@property (retain, nonatomic, nullable) SVBootLoader *bootLoader;
@property (nullable, nonatomic, retain) NSOrderedSet<SVCoprocessorConfiguration *> *coprocessors;
@property (retain, nonatomic, nullable) NSOrderedSet<SVDirectorySharingDeviceConfiguration *> *directorySharingDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVGraphicsDeviceConfiguration *> *graphicsDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVKeyboardConfiguration *> *keyboards;
@property (retain, nonatomic, nullable) SVVirtualMachine *machine;
@property (retain, nonatomic, nullable) NSOrderedSet<SVNetworkDeviceConfiguration *> *networkDevices;
@property (retain, nonatomic, nullable) SVPlatformConfiguration *platform;
@property (retain, nonatomic, nullable) NSOrderedSet<SVPointingDeviceConfiguration *> *pointingDevices;
@property (nullable, nonatomic, retain) NSOrderedSet<SVPowerSourceDeviceConfiguration *> *powerSourceDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVStorageDeviceConfiguration *> *storageDevices;
@property (retain, nonatomic, nullable) NSOrderedSet<SVUSBControllerConfiguration *> *usbControllers;

- (void)insertObject:(SVAudioDeviceConfiguration *)value inAudioDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAudioDevicesAtIndex:(NSUInteger)idx;
- (void)insertAudioDevices:(NSArray<SVAudioDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAudioDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAudioDevicesAtIndex:(NSUInteger)idx withObject:(SVAudioDeviceConfiguration *)value;
- (void)replaceAudioDevicesAtIndexes:(NSIndexSet *)indexes withAudioDevices:(NSArray<SVAudioDeviceConfiguration *> *)values;
- (void)addAudioDevicesObject:(SVAudioDeviceConfiguration *)value;
- (void)removeAudioDevicesObject:(SVAudioDeviceConfiguration *)value;
- (void)addAudioDevices:(NSOrderedSet<SVAudioDeviceConfiguration *> *)values;
- (void)removeAudioDevices:(NSOrderedSet<SVAudioDeviceConfiguration *> *)values;

- (void)insertObject:(SVBiometricDeviceConfiguration *)value inBiometricDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromBiometricDevicesAtIndex:(NSUInteger)idx;
- (void)insertBiometricDevices:(NSArray<SVBiometricDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeBiometricDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInBiometricDevicesAtIndex:(NSUInteger)idx withObject:(SVBiometricDeviceConfiguration *)value;
- (void)replaceBiometricDevicesAtIndexes:(NSIndexSet *)indexes withBiometricDevices:(NSArray<SVBiometricDeviceConfiguration *> *)values;
- (void)addBiometricDevicesObject:(SVBiometricDeviceConfiguration *)value;
- (void)removeBiometricDevicesObject:(SVBiometricDeviceConfiguration *)value;
- (void)addBiometricDevices:(NSOrderedSet<SVBiometricDeviceConfiguration *> *)values;
- (void)removeBiometricDevices:(NSOrderedSet<SVBiometricDeviceConfiguration *> *)values;

- (void)insertObject:(SVCoprocessorConfiguration *)value inCoprocessorsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromCoprocessorsAtIndex:(NSUInteger)idx;
- (void)insertCoprocessors:(NSArray<SVCoprocessorConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeCoprocessorsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInCoprocessorsAtIndex:(NSUInteger)idx withObject:(SVCoprocessorConfiguration *)value;
- (void)replaceCoprocessorsAtIndexes:(NSIndexSet *)indexes withCoprocessors:(NSArray<SVCoprocessorConfiguration *> *)values;
- (void)addCoprocessorsObject:(SVCoprocessorConfiguration *)value;
- (void)removeCoprocessorsObject:(SVCoprocessorConfiguration *)value;
- (void)addCoprocessors:(NSOrderedSet<SVCoprocessorConfiguration *> *)values;
- (void)removeCoprocessors:(NSOrderedSet<SVCoprocessorConfiguration *> *)values;

- (void)insertObject:(SVDirectorySharingDeviceConfiguration *)value inDirectorySharingDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDirectorySharingDevicesAtIndex:(NSUInteger)idx;
- (void)insertDirectorySharingDevices:(NSArray<SVDirectorySharingDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDirectorySharingDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDirectorySharingDevicesAtIndex:(NSUInteger)idx withObject:(SVDirectorySharingDeviceConfiguration *)value;
- (void)replaceDirectorySharingDevicesAtIndexes:(NSIndexSet *)indexes withDirectorySharingDevices:(NSArray<SVDirectorySharingDeviceConfiguration *> *)values;
- (void)addDirectorySharingDevicesObject:(SVDirectorySharingDeviceConfiguration *)value;
- (void)removeDirectorySharingDevicesObject:(SVDirectorySharingDeviceConfiguration *)value;
- (void)addDirectorySharingDevices:(NSOrderedSet<SVDirectorySharingDeviceConfiguration *> *)values;
- (void)removeDirectorySharingDevices:(NSOrderedSet<SVDirectorySharingDeviceConfiguration *> *)values;

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

- (void)insertObject:(SVNetworkDeviceConfiguration *)value inNetworkDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNetworkDevicesAtIndex:(NSUInteger)idx;
- (void)insertNetworkDevices:(NSArray<SVNetworkDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNetworkDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNetworkDevicesAtIndex:(NSUInteger)idx withObject:(SVNetworkDeviceConfiguration *)value;
- (void)replaceNetworkDevicesAtIndexes:(NSIndexSet *)indexes withNetworkDevices:(NSArray<SVNetworkDeviceConfiguration *> *)values;
- (void)addNetworkDevicesObject:(SVNetworkDeviceConfiguration *)value;
- (void)removeNetworkDevicesObject:(SVNetworkDeviceConfiguration *)value;
- (void)addNetworkDevices:(NSOrderedSet<SVNetworkDeviceConfiguration *> *)values;
- (void)removeNetworkDevices:(NSOrderedSet<SVNetworkDeviceConfiguration *> *)values;

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

- (void)insertObject:(SVPowerSourceDeviceConfiguration *)value inPowerSourceDevicesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromPowerSourceDevicesAtIndex:(NSUInteger)idx;
- (void)insertPowerSourceDevices:(NSArray<SVPowerSourceDeviceConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removePowerSourceDevicesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInPowerSourceDevicesAtIndex:(NSUInteger)idx withObject:(SVPowerSourceDeviceConfiguration *)value;
- (void)replacePowerSourceDevicesAtIndexes:(NSIndexSet *)indexes withPowerSourceDevices:(NSArray<SVPowerSourceDeviceConfiguration *> *)values;
- (void)addPowerSourceDevicesObject:(SVPowerSourceDeviceConfiguration *)value;
- (void)removePowerSourceDevicesObject:(SVPowerSourceDeviceConfiguration *)value;
- (void)addPowerSourceDevices:(NSOrderedSet<SVPowerSourceDeviceConfiguration *> *)values;
- (void)removePowerSourceDevices:(NSOrderedSet<SVPowerSourceDeviceConfiguration *> *)values;

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

- (void)insertObject:(SVUSBControllerConfiguration *)value inUsbControllersAtIndex:(NSUInteger)idx;
- (void)removeObjectFromUsbControllersAtIndex:(NSUInteger)idx;
- (void)insertUsbControllers:(NSArray<SVUSBControllerConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeUsbControllersAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInUsbControllersAtIndex:(NSUInteger)idx withObject:(SVUSBControllerConfiguration *)value;
- (void)replaceUsbControllersAtIndexes:(NSIndexSet *)indexes withUsbControllers:(NSArray<SVUSBControllerConfiguration *> *)values;
- (void)addUsbControllersObject:(SVUSBControllerConfiguration *)value;
- (void)removeUsbControllersObject:(SVUSBControllerConfiguration *)value;
- (void)addUsbControllers:(NSOrderedSet<SVUSBControllerConfiguration *> *)values;
- (void)removeUsbControllers:(NSOrderedSet<SVUSBControllerConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
