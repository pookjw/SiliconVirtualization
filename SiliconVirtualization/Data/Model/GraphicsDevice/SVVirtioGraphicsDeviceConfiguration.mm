//
//  SVVirtioGraphicsDeviceConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVVirtioGraphicsDeviceConfiguration.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVVirtioGraphicsDeviceConfiguration
#pragma clang diagnostic pop

@dynamic scanouts;
+ (NSFetchRequest<SVVirtioGraphicsDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioGraphicsDeviceConfiguration"];
}

@end
