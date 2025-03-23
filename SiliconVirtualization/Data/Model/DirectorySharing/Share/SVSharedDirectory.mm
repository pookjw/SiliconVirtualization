//
//  SVSharedDirectory.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVSharedDirectory.h"

@implementation SVSharedDirectory
@dynamic bookmarkData;
@dynamic readOnly;
@dynamic multipleDirectoryShare;
@dynamic singleDirectoryShare;

+ (NSFetchRequest<SVSharedDirectory *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SharedDirectory"];
}

@end
