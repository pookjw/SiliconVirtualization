//
//  SVUSBScreenCoordinatePointingDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVPointingDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVUSBScreenCoordinatePointingDeviceConfiguration : SVPointingDeviceConfiguration
+ (NSFetchRequest<SVUSBScreenCoordinatePointingDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
