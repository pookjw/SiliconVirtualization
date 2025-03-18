//
//  SVMacHardwareModel.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacHardwareModel.h"

@implementation SVMacHardwareModel
@dynamic dataRepresentation;
@dynamic platform;

+ (NSFetchRequest<SVMacHardwareModel *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacHardwareModel"];
}

@end
