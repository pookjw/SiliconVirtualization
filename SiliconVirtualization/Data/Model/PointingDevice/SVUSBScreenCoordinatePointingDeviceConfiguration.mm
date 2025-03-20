//
//  SVUSBScreenCoordinatePointingDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVUSBScreenCoordinatePointingDeviceConfiguration.h"

@implementation SVUSBScreenCoordinatePointingDeviceConfiguration

+ (NSFetchRequest<SVUSBScreenCoordinatePointingDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"USBScreenCoordinatePointingDeviceConfiguration"];
}

@end
