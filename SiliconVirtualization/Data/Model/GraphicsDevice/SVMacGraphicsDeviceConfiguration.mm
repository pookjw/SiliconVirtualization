//
//  SVMacGraphicsDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacGraphicsDeviceConfiguration.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVMacGraphicsDeviceConfiguration
#pragma clang diagnostic pop

@dynamic displays;

+ (NSFetchRequest<SVMacGraphicsDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacGraphicsDeviceConfiguration"];
}

@end
