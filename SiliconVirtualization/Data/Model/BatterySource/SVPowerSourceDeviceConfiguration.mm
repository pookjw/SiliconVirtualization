//
//  SVPowerSourceDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVPowerSourceDeviceConfiguration.h"

@implementation SVPowerSourceDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVPowerSourceDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"PowerSourceDeviceConfiguration"];
}

@end
