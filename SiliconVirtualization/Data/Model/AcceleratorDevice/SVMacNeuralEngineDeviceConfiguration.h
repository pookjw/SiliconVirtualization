//
//  SVMacNeuralEngineDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVAcceleratorDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacNeuralEngineDeviceConfiguration : SVAcceleratorDeviceConfiguration
+ (NSFetchRequest<SVMacNeuralEngineDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
