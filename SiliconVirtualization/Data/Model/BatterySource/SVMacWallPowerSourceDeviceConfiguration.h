//
//  SVMacWallPowerSourceDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVPowerSourceDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacWallPowerSourceDeviceConfiguration : SVPowerSourceDeviceConfiguration
+ (NSFetchRequest<SVMacWallPowerSourceDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
