//
//  SVPointingDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVPointingDeviceConfiguration.h"

@implementation SVPointingDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVPointingDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"PointingDeviceConfiguration"];
}

@end
