//
//  HelperXPCInterface.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HelperXPCInterface <NSObject>
- (void)pingWithCompletionHandler:(void (^)(NSString *string))completionHandler;
- (void)openFromURL:(NSURL *)URL completionHandler:(void (^)(int fileDescriptor))completionHandler;
- (void)closeWithFileDescriptor:(int)fileDescriptor completionHandler:(void (^)(int result))completionHandler;
@end

NS_ASSUME_NONNULL_END
