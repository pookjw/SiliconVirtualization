//
//  SVGraphicsDisplayConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDisplayConfiguration.h"

@implementation SVGraphicsDisplayConfiguration

+ (NSFetchRequest<SVGraphicsDisplayConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"GraphicsDisplayConfiguration"];
}

@end
