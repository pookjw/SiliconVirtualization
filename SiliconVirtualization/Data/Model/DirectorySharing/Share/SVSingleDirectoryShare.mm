//
//  SVSingleDirectoryShare.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVSingleDirectoryShare.h"

@implementation SVSingleDirectoryShare
@dynamic directory;

+ (NSFetchRequest<SVSingleDirectoryShare *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SingleDirectoryShare"];
}

@end
