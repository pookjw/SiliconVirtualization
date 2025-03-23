//
//  SVMultipleDirectoryShare.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDirectoryShare.h"
#import "SVSharedDirectory.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMultipleDirectoryShare : SVDirectoryShare
+ (NSFetchRequest<SVMultipleDirectoryShare *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSArray *directoryNames;
@property (retain, nonatomic, nullable) NSOrderedSet<SVSharedDirectory *> *directories;
- (void)insertObject:(SVSharedDirectory *)value inDirectoriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDirectoriesAtIndex:(NSUInteger)idx;
- (void)insertDirectories:(NSArray<SVSharedDirectory *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDirectoriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDirectoriesAtIndex:(NSUInteger)idx withObject:(SVSharedDirectory *)value;
- (void)replaceDirectoriesAtIndexes:(NSIndexSet *)indexes withDirectories:(NSArray<SVSharedDirectory *> *)values;
- (void)addDirectoriesObject:(SVSharedDirectory *)value;
- (void)removeDirectoriesObject:(SVSharedDirectory *)value;
- (void)addDirectories:(NSOrderedSet<SVSharedDirectory *> *)values;
- (void)removeDirectories:(NSOrderedSet<SVSharedDirectory *> *)values;
@end

NS_ASSUME_NONNULL_END
