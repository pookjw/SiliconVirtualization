//
//  SVMacAuxiliaryStorage.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacAuxiliaryStorage.h"

@implementation SVMacAuxiliaryStorage
@dynamic bookmarkData;
@dynamic platform;

+ (NSFetchRequest<SVMacAuxiliaryStorage *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacAuxiliaryStorage"];
}

@end
