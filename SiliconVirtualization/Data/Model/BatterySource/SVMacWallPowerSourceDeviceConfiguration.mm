//
//  SVMacWallPowerSourceDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacWallPowerSourceDeviceConfiguration.h"

@implementation SVMacWallPowerSourceDeviceConfiguration

+ (NSFetchRequest<SVMacWallPowerSourceDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacWallPowerSourceDeviceConfiguration"];
}

@end
