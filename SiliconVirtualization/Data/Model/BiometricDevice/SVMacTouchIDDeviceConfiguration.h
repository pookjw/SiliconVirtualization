//
//  SVMacTouchIDDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVBiometricDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacTouchIDDeviceConfiguration : SVBiometricDeviceConfiguration
+ (NSFetchRequest<SVMacTouchIDDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
