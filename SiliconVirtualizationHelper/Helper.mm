//
//  Helper.mm
//  SiliconVirtualizationHelper
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "Helper.h"
#import "HelperXPCInterface.h"
#import "HelperExportedObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface Helper () <NSXPCListenerDelegate>
@property (retain, nonatomic, readonly, getter=_listener) NSXPCListener *listener;
@property (retain, nonatomic, readonly, getter=_exportedObject) HelperExportedObject *exportedObject;
@end

@implementation Helper

- (instancetype)init {
    if (self = [super init]) {
        NSXPCListener *listener = [[NSXPCListener alloc] initWithMachServiceName:@"com.pookjw.SiliconVirtualization.Helper"];
        listener.delegate = self;
        
        HelperExportedObject *exportedObject = [HelperExportedObject new];
        
        _listener = listener;
        _exportedObject = exportedObject;
    }
    
    return self;
}

- (void)dealloc {
    [_listener invalidate];
    [_listener release];
    [_exportedObject release];
    [super dealloc];
}

- (void)run {
    [_listener activate];
    dispatch_main();
}

- (BOOL)listener:(NSXPCListener *)listener shouldAcceptNewConnection:(NSXPCConnection *)newConnection {
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperXPCInterface)];
    
    newConnection.exportedInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperXPCInterface)];
    newConnection.exportedObject = self.exportedObject;
    
    __block auto unretained = newConnection;
    newConnection.invalidationHandler = ^{
        NSLog(@"%@", reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretained, sel_registerName("_errorDescription")));
        NSLog(@"Invalidated!");
    };
    newConnection.interruptionHandler = ^{
        NSLog(@"%@", reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretained, sel_registerName("_errorDescription")));
        NSLog(@"Interrupted!");
    };
    
    [newConnection activate];
    
    return YES;
}

@end
