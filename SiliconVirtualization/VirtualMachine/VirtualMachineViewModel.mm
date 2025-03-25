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
        
//        {
//            id tdc = [objc_lookUpClass("_VZMacTouchIDDeviceConfiguration") new];
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setBiometricDevices:"), @[tdc]);
//            [tdc release];
//            
//            NSError * _Nullable error = nil;
//            [configuration validateWithError:&error];
//            assert(error == nil);
//        }
//        
//        {
//            __block NSURL *URL;
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                NSSavePanel *panel = [NSSavePanel new];
//                [panel runModal];
//                URL = [panel.URL copy];
//                [panel release];
//            });
//            
//            NSError * _Nullable error = nil;
//            assert([URL startAccessingSecurityScopedResource]);
//            id storage = reinterpret_cast<id (*)(id, SEL, id, id *)>(objc_msgSend)([objc_lookUpClass("_VZSEPStorage") alloc], sel_registerName("initCreatingStorageAtURL:error:"), URL, &error);
//            [URL release];
//            assert(error == nil);
//            
//            id sep = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPCoprocessorConfiguration") alloc], sel_registerName("initWithStorage:"), storage);
//            [storage release];
//            
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setCoprocessors:"), @[sep]);
//            [sep release];
//        }
//        {
//            id nedc = [objc_lookUpClass("_VZMacNeuralEngineDeviceConfiguration") new];
////            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(nedc, sel_registerName("_setSignatureMismatchAllowed:"), YES);
//            id ad = [objc_lookUpClass("_VZMacScalerAcceleratorDeviceConfiguration") new];
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setAcceleratorDevices:"), @[nedc, ad]);
//            [nedc release];
//            [ad release];
//            
//            NSError * _Nullable error = nil;
//            [configuration validateWithError:&error];
//            assert(error == nil);
//        }
        
//        {
//            id config = [objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration") new];
//            
//            id source = [objc_lookUpClass("_VZMacHostBatterySource") new];
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(config, sel_registerName("setSource:"), source);
//            [source release];
//            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("_setPowerSourceDevices:"), @[config]);
//            [config release];
//        }
        
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

@end
