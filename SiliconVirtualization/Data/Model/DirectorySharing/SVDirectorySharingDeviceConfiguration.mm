//
//  SVDirectorySharingDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDirectorySharingDeviceConfiguration.h"

@implementation SVDirectorySharingDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVDirectorySharingDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"DirectorySharingDeviceConfiguration"];
}

@end
