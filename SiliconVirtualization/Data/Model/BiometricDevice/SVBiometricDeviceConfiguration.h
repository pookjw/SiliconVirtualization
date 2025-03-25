//
//  SVBiometricDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVBiometricDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVBiometricDeviceConfiguration *> *)fetchRequest;
@property (nullable, nonatomic, retain) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
