//
//  SVMultipleDirectoryShare.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVMultipleDirectoryShare.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVMultipleDirectoryShare
#pragma clang diagnostic pop

@dynamic directoryNames;
@dynamic directories;

+ (NSFetchRequest<SVMultipleDirectoryShare *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MultipleDirectoryShare"];
}

@end
