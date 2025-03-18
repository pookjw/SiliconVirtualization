//
//  SVStorageDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>
#import "SVStorageDeviceAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVStorageDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVStorageDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVStorageDeviceAttachment *attachment;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
