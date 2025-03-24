//
//  SVMacHostBatterySource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacBatterySource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacHostBatterySource : SVMacBatterySource
+ (NSFetchRequest<SVMacHostBatterySource *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
