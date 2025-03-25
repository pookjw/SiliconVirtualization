//
//  SVSEPStorage.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVSEPStorage.h"

@implementation SVSEPStorage
@dynamic bookmarkData;
@dynamic sepCoprocessor;

+ (NSFetchRequest<SVSEPStorage *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SEPStorage"];
}

@end
