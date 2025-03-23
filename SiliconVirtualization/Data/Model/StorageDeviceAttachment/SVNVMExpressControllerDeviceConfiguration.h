//
//  SVNVMExpressControllerDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVStorageDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVNVMExpressControllerDeviceConfiguration : SVStorageDeviceConfiguration
+ (NSFetchRequest<SVNVMExpressControllerDeviceConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
