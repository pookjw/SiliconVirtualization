//
//  SVSharedDirectory.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVMultipleDirectoryShare;
@class SVSingleDirectoryShare;

@interface SVSharedDirectory : NSManagedObject
+ (NSFetchRequest<SVSharedDirectory *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSData *bookmarkData;
@property (nonatomic) BOOL readOnly;
@property (retain, nonatomic, nullable) SVMultipleDirectoryShare *multipleDirectoryShare;
@property (retain, nonatomic, nullable) SVSingleDirectoryShare *singleDirectoryShare;
@end

NS_ASSUME_NONNULL_END
