//
//  SVVirtualMachineStartOptions.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import "SVVirtualMachineStartOptions.h"

@implementation SVVirtualMachineStartOptions
@dynamic machine;

+ (NSFetchRequest<SVVirtualMachineStartOptions *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtualMachineStartOptions"];
}

@end
