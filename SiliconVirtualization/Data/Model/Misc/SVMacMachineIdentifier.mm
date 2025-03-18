//
//  SVMacMachineIdentifier.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacMachineIdentifier.h"

@implementation SVMacMachineIdentifier
@dynamic dataRepresentation;
@dynamic platform;

+ (NSFetchRequest<SVMacMachineIdentifier *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacMachineIdentifier"];
}

@end
