//
//  SVVirtioTraditionalMemoryBalloonDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVVirtioTraditionalMemoryBalloonDeviceConfiguration.h"

@implementation SVVirtioTraditionalMemoryBalloonDeviceConfiguration

+ (NSFetchRequest<SVVirtioTraditionalMemoryBalloonDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioTraditionalMemoryBalloonDeviceConfiguration"];
}

@end
