//
//  SVVirtualMachineConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVVirtualMachineConfiguration.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVVirtualMachineConfiguration
#pragma clang diagnostic pop

@dynamic cpuCount;
@dynamic memorySize;
@dynamic timestamp;
@dynamic bootLoader;
@dynamic graphicsDevices;
@dynamic keyboards;
@dynamic platform;
@dynamic storageDevices;

+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtualMachineConfiguration"];
}

@end
