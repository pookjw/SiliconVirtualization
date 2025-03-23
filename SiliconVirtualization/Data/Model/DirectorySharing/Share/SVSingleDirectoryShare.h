//
//  SVSingleDirectoryShare.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDirectoryShare.h"
#import "SVSharedDirectory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVSingleDirectoryShare : SVDirectoryShare
+ (NSFetchRequest<SVSingleDirectoryShare *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVSharedDirectory *directory;
@end

NS_ASSUME_NONNULL_END
