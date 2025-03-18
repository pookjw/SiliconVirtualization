//
//  SVCoreDataStack.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>
#import "Model.h"
#import "Extern.h"

NS_ASSUME_NONNULL_BEGIN

SV_EXTERN NSNotificationName const SVCoreDataStackDidInitializeNotification;

@interface SVCoreDataStack : NSObject
@property (class, retain, readonly, nonatomic) SVCoreDataStack *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
@property (retain, nonatomic, readonly) NSManagedObjectContext *backgroundContext;
@property (assign, nonatomic, readonly, getter=isInitialized) BOOL initialized; // can be called from any threads
@end

NS_ASSUME_NONNULL_END
