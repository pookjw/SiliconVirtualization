//
//  SVMacBatterySource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVMacBatteryPowerSourceDeviceConfiguration;

@interface SVMacBatterySource : NSManagedObject
+ (NSFetchRequest<SVMacBatterySource *> *)fetchRequest;
@property (nullable, nonatomic, retain) SVMacBatteryPowerSourceDeviceConfiguration *batteryPowerSourceDevice;
@end

NS_ASSUME_NONNULL_END
