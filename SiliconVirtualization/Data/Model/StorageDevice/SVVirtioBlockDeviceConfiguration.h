//
//  SVVirtioBlockDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVStorageDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioBlockDeviceConfiguration : SVStorageDeviceConfiguration
+ (NSFetchRequest<SVVirtioBlockDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
