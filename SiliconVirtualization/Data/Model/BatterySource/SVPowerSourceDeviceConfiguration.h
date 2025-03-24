//
//  SVPowerSourceDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVPowerSourceDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVPowerSourceDeviceConfiguration *> *)fetchRequest;
@property (nullable, nonatomic, retain) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
