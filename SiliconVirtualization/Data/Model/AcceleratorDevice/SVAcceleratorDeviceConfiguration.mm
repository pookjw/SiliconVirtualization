//
//  SVAcceleratorDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVAcceleratorDeviceConfiguration.h"

@implementation SVAcceleratorDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVAcceleratorDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"AcceleratorDeviceConfiguration"];
}

@end
