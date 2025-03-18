//
//  SVGenericMachineIdentifier.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGenericMachineIdentifier.h"

@implementation SVGenericMachineIdentifier
@dynamic dataRepresentation;
@dynamic platform;

+ (NSFetchRequest<SVGenericMachineIdentifier *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"GenericMachineIdentifier"];
}

@end
