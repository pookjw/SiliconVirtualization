//
//  SVUSBControllerConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVUSBControllerConfiguration.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVUSBControllerConfiguration
#pragma clang diagnostic pop

@dynamic machine;
@dynamic usbMassStorageDevices;

+ (NSFetchRequest<SVUSBControllerConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"USBControllerConfiguration"];
}

@end
