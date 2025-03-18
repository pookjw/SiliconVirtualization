//
//  SVVirtioBlockDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVVirtioBlockDeviceConfiguration.h"

@implementation SVVirtioBlockDeviceConfiguration

+ (NSFetchRequest<SVVirtioBlockDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioBlockDeviceConfiguration"];
}

@end
