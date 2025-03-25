//
//  SVMacTouchIDDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVMacTouchIDDeviceConfiguration.h"

@implementation SVMacTouchIDDeviceConfiguration

+ (NSFetchRequest<SVMacTouchIDDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacTouchIDDeviceConfiguration"];
}

@end
