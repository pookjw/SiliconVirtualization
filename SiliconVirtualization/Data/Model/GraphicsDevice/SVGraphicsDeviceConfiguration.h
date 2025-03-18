//
//  SVGraphicsDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVGraphicsDeviceConfiguration : NSManagedObject
+ (NSFetchRequest<SVGraphicsDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
