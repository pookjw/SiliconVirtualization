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
@dynamic acceleratorDevices;
@dynamic audioDevices;
@dynamic biometricDevices;
@dynamic directorySharingDevices;
@dynamic bootLoader;
@dynamic graphicsDevices;
@dynamic keyboards;
@dynamic networkDevices;
@dynamic machine;
@dynamic platform;
@dynamic pointingDevices;
@dynamic powerSourceDevices;
@dynamic storageDevices;
@dynamic usbControllers;
@dynamic coprocessors;

+ (NSFetchRequest<SVVirtualMachineConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtualMachineConfiguration"];
}

@end
