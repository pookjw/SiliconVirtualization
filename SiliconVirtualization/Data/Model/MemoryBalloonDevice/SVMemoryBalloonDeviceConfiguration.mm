//
//  SVMemoryBalloonDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVMemoryBalloonDeviceConfiguration.h"

@implementation SVMemoryBalloonDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVMemoryBalloonDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MemoryBalloonDeviceConfiguration"];
}

@end
