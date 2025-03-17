//
//  NSManagedObjectModel+Category.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSManagedObjectModel (Category)
@property (class, nonatomic, readonly) NSManagedObjectModel *sv_managedObjectModel;
@end

NS_ASSUME_NONNULL_END
