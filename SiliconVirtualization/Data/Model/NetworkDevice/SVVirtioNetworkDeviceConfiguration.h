//
//  SVVirtioNetworkDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVNetworkDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioNetworkDeviceConfiguration : SVNetworkDeviceConfiguration
+ (NSFetchRequest<SVVirtioNetworkDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
