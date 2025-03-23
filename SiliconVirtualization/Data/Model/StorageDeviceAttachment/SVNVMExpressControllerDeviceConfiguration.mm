//
//  SVNVMExpressControllerDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVNVMExpressControllerDeviceConfiguration.h"

@implementation SVNVMExpressControllerDeviceConfiguration

+ (NSFetchRequest<SVNVMExpressControllerDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"NVMExpressControllerDeviceConfiguration"];
}

@end
