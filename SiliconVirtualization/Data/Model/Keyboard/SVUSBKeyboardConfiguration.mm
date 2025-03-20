//
//  SVUSBKeyboardConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVUSBKeyboardConfiguration.h"

@implementation SVUSBKeyboardConfiguration

+ (NSFetchRequest<SVUSBKeyboardConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"USBKeyboardConfiguration"];
}

@end
