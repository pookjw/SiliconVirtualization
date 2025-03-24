//
//  SVMacSyntheticBatterySource.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacSyntheticBatterySource.h"

@implementation SVMacSyntheticBatterySource
@dynamic charge;
@dynamic connectivity;

+ (NSFetchRequest<SVMacSyntheticBatterySource *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacSyntheticBatterySource"];
}

@end
