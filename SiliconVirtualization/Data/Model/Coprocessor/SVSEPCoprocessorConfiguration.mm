//
//  SVSEPCoprocessorConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVSEPCoprocessorConfiguration.h"

@implementation SVSEPCoprocessorConfiguration
@dynamic romBinaryBookmarkData;
@dynamic storage;

+ (NSFetchRequest<SVSEPCoprocessorConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SEPCoprocessorConfiguration"];
}

@end
