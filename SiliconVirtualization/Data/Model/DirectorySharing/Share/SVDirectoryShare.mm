//
//  SVDirectoryShare.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDirectoryShare.h"

@implementation SVDirectoryShare
@dynamic fileSystemDevice;

+ (NSFetchRequest<SVDirectoryShare *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"DirectoryShare"];
}

@end
