//
//  SVPlatformConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVPlatformConfiguration.h"

@implementation SVPlatformConfiguration
@dynamic machine;

+ (NSFetchRequest<SVPlatformConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"PlatformConfiguration"];
}

@end
