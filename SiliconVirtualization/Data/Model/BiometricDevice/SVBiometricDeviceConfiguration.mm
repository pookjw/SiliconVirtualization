//
//  SVBiometricDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVBiometricDeviceConfiguration.h"

@implementation SVBiometricDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVBiometricDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"BiometricDeviceConfiguration"];
}

@end
