//
//  SVGraphicsDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDeviceConfiguration.h"

@implementation SVGraphicsDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVGraphicsDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"GraphicsDeviceConfiguration"];
}

@end
