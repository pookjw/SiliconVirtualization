//
//  SVStorageDeviceConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVStorageDeviceConfiguration.h"

@implementation SVStorageDeviceConfiguration
@dynamic attachment;
@dynamic machine;

+ (NSFetchRequest<SVStorageDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"StorageDeviceConfiguration"];
}

@end
