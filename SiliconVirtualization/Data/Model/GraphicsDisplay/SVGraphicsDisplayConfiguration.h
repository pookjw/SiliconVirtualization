//
//  SVGraphicsDisplayConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVGraphicsDisplayConfiguration : NSManagedObject
+ (NSFetchRequest<SVGraphicsDisplayConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
