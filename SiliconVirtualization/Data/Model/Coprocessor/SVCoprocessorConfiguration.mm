//
//  SVCoprocessorConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVCoprocessorConfiguration.h"

@implementation SVCoprocessorConfiguration
@dynamic machine;

+ (NSFetchRequest<SVCoprocessorConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"CoprocessorConfiguration"];
}

@end
