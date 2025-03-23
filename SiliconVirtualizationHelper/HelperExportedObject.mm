//
//  HelperExportedObject.mm
//  SiliconVirtualizationHelper
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "HelperExportedObject.h"
#import "FileHandlesManager.h"

@implementation HelperExportedObject

- (void)pingWithCompletionHandler:(void (^)(NSString *string))completionHandler {
    completionHandler(@"pong");
}

- (void)openFromURL:(NSURL *)URL completionHandler:(void (^)(NSFileHandle * _Nonnull))completionHandler {
    NSError * _Nullable error = nil;
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingURL:URL error:&error];
    assert(error == nil);
    
    [FileHandlesManager.sharedInstance withLock:^(NSMutableSet<NSFileHandle *> * _Nonnull handles) {
        [handles addObject:fileHandle];
    }];
    
    completionHandler(fileHandle);
}

- (void)closeWithFileDescriptor:(int)fileDescriptor completionHandler:(void (^)(int result))completionHandler {
    abort();
}

@end
