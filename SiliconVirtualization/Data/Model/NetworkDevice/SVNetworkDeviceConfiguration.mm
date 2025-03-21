//
//  SVNetworkDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVNetworkDeviceConfiguration.h"

@implementation SVNetworkDeviceConfiguration
@dynamic attachment;
@dynamic macAddress;
@dynamic machine;

+ (NSFetchRequest<SVNetworkDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"NetworkDeviceConfiguration"];
}

@end
