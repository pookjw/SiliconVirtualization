//
//  SVMacSyntheticBatterySource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacBatterySource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacSyntheticBatterySource : SVMacBatterySource
+ (NSFetchRequest<SVMacSyntheticBatterySource *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (nonatomic) double charge;
@property (nonatomic) int64_t connectivity;
@end

NS_ASSUME_NONNULL_END
