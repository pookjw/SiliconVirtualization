//
//  VirtualMachineViewModel.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import "VirtualMachineViewModel.h"
#import "SVCoreDataStack.h"
#import "SVCoreDataStack+VirtualizationSupport.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface VirtualMachineViewModel ()
@property (retain, nonatomic, nullable, setter=_isolated_setVirtualMachine:) VZVirtualMachine *isolated_virtualMachine;
@end

@implementation VirtualMachineViewModel
@synthesize isolated_virtualMachineObject = _virtualMachineObject;
@synthesize isolated_virtualMachine = _virtualMachine;

- (instancetype)init {
    if (self = [super init]) {
        dispatch_queue_attr_t attr = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_SERIAL, QOS_CLASS_USER_INITIATED, QOS_MIN_RELATIVE_PRIORITY);
        dispatch_queue_t queue = dispatch_queue_create("VirtualMachineViewModel", attr);
        _queue = queue;
        
        SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
        NSManagedObjectContext *context = stack.backgroundContext;
        
        [NSNotificationCenter.defaultCenter addObserver:self
                                               selector:@selector(_didSaveObjectIDs:)
                                                   name:NSManagedObjectContextDidSaveObjectIDsNotification
                                                 object:context];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_virtualMachineObject release];
    dispatch_release(_queue);
    [_virtualMachine release];
    [super dealloc];
}

- (SVVirtualMachine *)isolated_virtualMachineObject {
    dispatch_assert_queue(_queue);
    return _virtualMachineObject;
}

- (void)isolated_setVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject {
    [self isolated_setVirtualMachineObject:virtualMachineObject completionHandler:nil];
}

- (void)isolated_setVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject completionHandler:(void (^)())completionHandler {
    [_virtualMachineObject release];
    _virtualMachineObject = [virtualMachineObject retain];
    
    SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
    NSManagedObjectContext *context = stack.backgroundContext;
    
    [context performBlock:^{
        SVVirtualMachineConfiguration *configurationObject = virtualMachineObject.configuration;
        assert(configurationObject != nil);
        
        VZVirtualMachineConfiguration *configuration = [stack isolated_makeVirtualMachineConfigurationFromManagedObject:configurationObject];
        
//        BOOL _isProductionModeEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(configuration.platform, sel_registerName("_isProductionModeEnabled"));
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration.platform, sel_registerName("_setProductionModeEnabled:"), !_isProductionModeEnabled);
        
//        BOOL _isSIODescramblerEnabled = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(configuration.platform, sel_registerName("_isSIODescramblerEnabled"));
//        reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(configuration.platform, sel_registerName("_setSIODescramblerEnabled:"), !_isSIODescramblerEnabled);
        
        
//        for (VZMacGraphicsDeviceConfiguration *device in configuration.graphicsDevices) {
//            // 0x4 미만
//            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(device, sel_registerName("_setDeviceFeatureLevel:"), 3);
//            
//            BOOL _enableProcessIsolation = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(device, sel_registerName("_enableProcessIsolation"));
//            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(device, sel_registerName("_setEnableProcessIsolation:"), !_enableProcessIsolation);
//        }
        
        {
            id debugStubConfiguration = reinterpret_cast<id (*)(id, SEL, ushort)>(objc_msgSend)([objc_lookUpClass("_VZGDBDebugStubConfiguration") alloc], sel_registerName("initWithPort:"), 1234);
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(debugStubConfiguration, sel_registerName("setListensOnAllNetworkInterfaces:"), YES);
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setDebugStub:"), debugStubConfiguration);
            [debugStubConfiguration release];
        }
        
        BOOL startUpFromMacOSRecovery;
        __kindof SVVirtualMachineStartOptions *startOptions = virtualMachineObject.startOptions;
        if (startOptions == nil) {
            startUpFromMacOSRecovery = NO;
        } else if ([startOptions isKindOfClass:[SVMacOSVirtualMachineStartOptions class]]) {
            auto casted = static_cast<SVMacOSVirtualMachineStartOptions *>(startOptions);
            startUpFromMacOSRecovery =casted.startUpFromMacOSRecovery;
        } else {
            abort();
        }
        
        dispatch_async(_queue, ^{
            if ([_virtualMachineObject isEqual:virtualMachineObject]) {
                VZVirtualMachine *virtualMachine = [[VZVirtualMachine alloc] initWithConfiguration:configuration queue:_queue];
                
                if (id _debugStub = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachine, sel_registerName("_debugStub"))) {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(_debugStub, sel_registerName("setDelegate:"), self);
                }
                
                for (__kindof VZUSBController *usbController in virtualMachine.usbControllers) {
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(usbController, sel_registerName("setDelegate:"), self);
                }
                
                self.isolated_virtualMachine = virtualMachine;
                [virtualMachine release];
                
                self.startUpFromMacOSRecovery = startUpFromMacOSRecovery;
            }
            
            if (completionHandler) {
                completionHandler();
            }
        });
    }];
}

- (VZVirtualMachine *)isolated_virtualMachine {
    dispatch_assert_queue(_queue);
    return _virtualMachine;
}

- (void)_isolated_setVirtualMachine:(VZVirtualMachine *)isolated_virtualMachine {
    dispatch_assert_queue(_queue);
    [_virtualMachine release];
    _virtualMachine = [isolated_virtualMachine retain];
}

- (void)setStartUpFromMacOSRecovery:(BOOL)startUpFromMacOSRecovery {
    _startUpFromMacOSRecovery = startUpFromMacOSRecovery;
    
    dispatch_async(_queue, ^{
        SVVirtualMachine *virtualMachineObject = self.isolated_virtualMachineObject;
        assert(virtualMachineObject != nil);
        
        NSManagedObjectContext *context = virtualMachineObject.managedObjectContext;
        assert(context != nil);
        
        [context performBlock:^{
            if (__kindof SVVirtualMachineStartOptions *startOptions = virtualMachineObject.startOptions) {
                assert([startOptions isKindOfClass:[SVMacOSVirtualMachineStartOptions class]]);
                auto casted = static_cast<SVMacOSVirtualMachineStartOptions *>(startOptions);
                casted.startUpFromMacOSRecovery = startUpFromMacOSRecovery;
            } else {
                SVMacOSVirtualMachineStartOptions *_startOptions = [[SVMacOSVirtualMachineStartOptions alloc] initWithContext:context];
                _startOptions.startUpFromMacOSRecovery = startUpFromMacOSRecovery;
                virtualMachineObject.startOptions = _startOptions;
                [_startOptions release];
            }
            
            NSError * _Nullable error = nil;
            [context save:&error];
            assert(error == nil);
        }];
    });
}

- (void)_didSaveObjectIDs:(NSNotification *)notification {
    
}

-(void)_debugStub:(id)_debugStub didStartListeningOnPort:(ushort)port {
    NSLog(@"%s (%@, %hu)", __func__, _debugStub, port);
}

// Not Working...
- (void)usbController:(__kindof VZUSBController *)usbCintroller passthroughDeviceWillDisconnect:(id<VZUSBDevice>)device {
    NSLog(@"%s (%@, %@)", __func__, usbCintroller, device);
}

@end
