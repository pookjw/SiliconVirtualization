//
//  SVUSBMassStorageDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVUSBMassStorageDeviceConfiguration.h"

@implementation SVUSBMassStorageDeviceConfiguration
@dynamic usbController;

+ (NSFetchRequest<SVUSBMassStorageDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"USBMassStorageDeviceConfiguration"];
}

@end
