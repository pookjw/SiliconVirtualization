//
//  SVMacBatteryPowerSourceDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVPowerSourceDeviceConfiguration.h"
#import "SVMacBatterySource.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVMacBatteryPowerSourceDeviceConfiguration : SVPowerSourceDeviceConfiguration
+ (NSFetchRequest<SVMacBatteryPowerSourceDeviceConfiguration *> *)fetchRequest;
@property (nullable, nonatomic, retain) SVVirtualMachineConfiguration *machine;
@property (nullable, nonatomic, retain) SVMacBatterySource *source;
@end

NS_ASSUME_NONNULL_END
