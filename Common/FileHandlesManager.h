//
//  FileHandlesManager.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileHandlesManager : NSObject
@property (class, nonatomic, readonly) FileHandlesManager *sharedInstance;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (void)withLock:(void (NS_NOESCAPE ^)(NSMutableSet<NSFileHandle *> *handles))block;
@end

NS_ASSUME_NONNULL_END
