//
//  SVMacBatteryPowerSourceDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacBatteryPowerSourceDeviceConfiguration.h"

@implementation SVMacBatteryPowerSourceDeviceConfiguration
@dynamic machine;
@dynamic source;

+ (NSFetchRequest<SVMacBatteryPowerSourceDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacBatteryPowerSourceDeviceConfiguration"];
}

@end
