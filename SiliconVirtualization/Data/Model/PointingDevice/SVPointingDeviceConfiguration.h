//
//  SVPointingDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVPointingDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVPointingDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
