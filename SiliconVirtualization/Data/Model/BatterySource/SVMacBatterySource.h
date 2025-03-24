//
//  SVMacBatterySource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachineConfiguration;

@interface SVMacBatterySource : NSManagedObject
+ (NSFetchRequest<SVMacBatterySource *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *machine;
@end

NS_ASSUME_NONNULL_END
