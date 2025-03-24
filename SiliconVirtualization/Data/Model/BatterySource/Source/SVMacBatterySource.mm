//
//  SVMacBatterySource.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacBatterySource.h"

@implementation SVMacBatterySource
@dynamic batteryPowerSourceDevice;

+ (NSFetchRequest<SVMacBatterySource *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacBatterySource"];
}

@end
