//
//  FileHandlesManager.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "FileHandlesManager.h"
#import <os/lock.h>

@interface FileHandlesManager () {
    os_unfair_lock _lock;
    NSMutableSet<NSFileHandle *> *_handles;
}
@end

@implementation FileHandlesManager

+ (FileHandlesManager *)sharedInstance {
    static FileHandlesManager *sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [FileHandlesManager new];
    });
    
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _lock = OS_UNFAIR_LOCK_INIT;
        _handles = [NSMutableSet new];
    }
    
    return self;
}

- (void)dealloc {
    [_handles release];
    [super dealloc];
}

- (void)withLock:(void (NS_NOESCAPE ^)(NSMutableSet<NSFileHandle *> *handles))block {
    os_unfair_lock_lock(&_lock);
    
    NSMutableSet<NSFileHandle *> *handles = _handles;
    block(handles);
    NSMutableSet<NSFileHandle *> *copy = [handles mutableCopy];
    [handles release];
    _handles = copy;
    
    os_unfair_lock_unlock(&_lock);
}

@end
