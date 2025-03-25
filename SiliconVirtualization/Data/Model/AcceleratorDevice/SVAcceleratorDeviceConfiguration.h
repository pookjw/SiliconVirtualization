//
//  SVAcceleratorDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVAcceleratorDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVAcceleratorDeviceConfiguration *> *)fetchRequest;
@property (nullable, nonatomic, retain) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
