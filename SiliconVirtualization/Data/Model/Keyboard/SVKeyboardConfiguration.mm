//
//  SVKeyboardConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVKeyboardConfiguration.h"

@implementation SVKeyboardConfiguration
@dynamic machine;

+ (NSFetchRequest<SVKeyboardConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"KeyboardConfiguration"];
}

@end
