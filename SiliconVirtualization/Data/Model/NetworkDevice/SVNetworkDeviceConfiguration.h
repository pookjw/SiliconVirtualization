//
//  SVNetworkDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>
#import "SVNetworkDeviceAttachment.h"
#import "SVMACAddress.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVNetworkDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVNetworkDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVNetworkDeviceAttachment *attachment;
@property (retain, nonatomic, nullable) SVMACAddress *macAddress;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
