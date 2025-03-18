//
//  SVMacOSBootLoader.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacOSBootLoader.h"

@implementation SVMacOSBootLoader

+ (NSFetchRequest<SVMacOSBootLoader *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacOSBootLoader"];
}

@end
