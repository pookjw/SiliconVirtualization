//
//  HelperExportedObject.mm
//  SiliconVirtualizationHelper
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "HelperExportedObject.h"
#include <fcntl.h>

@implementation HelperExportedObject

- (void)pingWithCompletionHandler:(void (^)(NSString *string))completionHandler {
    completionHandler(@"pong");
}

- (void)openFromURL:(NSURL *)URL completionHandler:(void (^)(int))completionHandler {
    NSString *absoluteString = URL.path;
    const char *cString = [absoluteString cStringUsingEncoding:NSUTF8StringEncoding];
    int fd = open(cString, O_RDWR);
    completionHandler(fd);
}

- (void)closeWithFileDescriptor:(int)fileDescriptor completionHandler:(void (^)(int result))completionHandler {
    int result = close(fileDescriptor);
    completionHandler(result);
}

@end
