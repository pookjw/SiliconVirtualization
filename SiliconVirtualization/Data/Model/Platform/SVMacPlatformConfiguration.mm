//
//  SVMacPlatformConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacPlatformConfiguration.h"

@implementation SVMacPlatformConfiguration
@dynamic auxiliaryStorage;
@dynamic hardwareModel;
@dynamic machineIdentifier;

+ (NSFetchRequest<SVMacPlatformConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacPlatformConfiguration"];
}

@end
