//
//  SVUSBMassStorageDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVStorageDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVUSBControllerConfiguration;

@interface SVUSBMassStorageDeviceConfiguration : SVStorageDeviceConfiguration
+ (NSFetchRequest<SVUSBMassStorageDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVUSBControllerConfiguration *usbController;
@end

NS_ASSUME_NONNULL_END
