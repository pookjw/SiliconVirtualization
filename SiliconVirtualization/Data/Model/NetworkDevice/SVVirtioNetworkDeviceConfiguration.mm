//
//  SVVirtioNetworkDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioNetworkDeviceConfiguration.h"

@implementation SVVirtioNetworkDeviceConfiguration

+ (NSFetchRequest<SVVirtioNetworkDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioNetworkDeviceConfiguration"];
}

@end
