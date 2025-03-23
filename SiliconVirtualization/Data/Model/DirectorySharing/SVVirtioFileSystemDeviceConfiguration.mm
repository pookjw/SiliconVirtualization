//
//  SVVirtioFileSystemDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVVirtioFileSystemDeviceConfiguration.h"

@implementation SVVirtioFileSystemDeviceConfiguration
@dynamic tag;
@dynamic share;

+ (NSFetchRequest<SVVirtioFileSystemDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioFileSystemDeviceConfiguration"];
}

@end
