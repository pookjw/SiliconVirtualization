//
//  SVMacHostBatterySource.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "SVMacHostBatterySource.h"

@implementation SVMacHostBatterySource

+ (NSFetchRequest<SVMacHostBatterySource *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacHostBatterySource"];
}

@end
