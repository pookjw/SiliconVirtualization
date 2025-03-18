//
//  SVGenericPlatformConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGenericPlatformConfiguration.h"

@implementation SVGenericPlatformConfiguration
@dynamic nestedVirtualizationEnabled;
@dynamic machineIdentifier;

+ (NSFetchRequest<SVGenericPlatformConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"GenericPlatformConfiguration"];
}

@end
