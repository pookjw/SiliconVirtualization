//
//  SVBootLoader.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVBootLoader.h"

@implementation SVBootLoader
@dynamic machine;

+ (NSFetchRequest<SVBootLoader *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"BootLoader"];
}

@end
