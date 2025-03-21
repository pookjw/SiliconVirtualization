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
@property (nullable, nonatomic, retain) SVNetworkDeviceAttachment *attachment;
@property (nullable, nonatomic, retain) SVMACAddress *macAddress;
@property (nullable, nonatomic, retain) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
