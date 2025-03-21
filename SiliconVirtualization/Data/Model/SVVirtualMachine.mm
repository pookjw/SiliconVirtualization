//
//  SVVirtualMachine.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import "SVVirtualMachine.h"

@implementation SVVirtualMachine
@dynamic timestamp;
@dynamic configuration;
@dynamic startOptions;

+ (NSFetchRequest<SVVirtualMachine *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtualMachine"];
}

@end
