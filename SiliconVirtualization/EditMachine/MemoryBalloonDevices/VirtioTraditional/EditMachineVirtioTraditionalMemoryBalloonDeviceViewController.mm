//
//  EditMachineVirtioTraditionalMemoryBalloonDeviceViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineVirtioTraditionalMemoryBalloonDeviceViewController.h"
#import "EditMachineStorageControl.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineVirtioTraditionalMemoryBalloonDeviceViewController ()
@property (retain, nonatomic, readonly, getter=_storageControl) EditMachineStorageControl *storageControl;
@end

@implementation EditMachineVirtioTraditionalMemoryBalloonDeviceViewController
@synthesize storageControl = _storageControl;

- (void)dealloc {
    [_virtioTraditionalMemoryBalloonDevice release];
    [_storageControl release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EditMachineStorageControl *storageControl = self.storageControl;
    storageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:storageControl];
    [NSLayoutConstraint activateConstraints:@[
        [storageControl.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor],
        [storageControl.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [storageControl.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor]
    ]];
}

- (void)setVirtioTraditionalMemoryBalloonDevice:(VZVirtioTraditionalMemoryBalloonDevice *)virtioTraditionalMemoryBalloonDevice {
    [_virtioTraditionalMemoryBalloonDevice release];
    _virtioTraditionalMemoryBalloonDevice = [virtioTraditionalMemoryBalloonDevice retain];
    
    dispatch_queue_t _queue;
    assert(object_getInstanceVariable(virtioTraditionalMemoryBalloonDevice, "_queue", reinterpret_cast<void **>(&_queue)) != NULL);
    
    dispatch_async(_queue, ^{
        uint64_t targetVirtualMachineMemorySize = virtioTraditionalMemoryBalloonDevice.targetVirtualMachineMemorySize;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.virtioTraditionalMemoryBalloonDevice isEqual:virtioTraditionalMemoryBalloonDevice]) {
                self.storageControl.unsignedInt64Value = targetVirtualMachineMemorySize;
            }
        });
    });
}

- (EditMachineStorageControl *)_storageControl {
    if (auto storageControl = _storageControl) return storageControl;
    
    EditMachineStorageControl *storageControl = [EditMachineStorageControl new];
    storageControl.maxValue = VZVirtualMachineConfiguration.maximumAllowedMemorySize;
    storageControl.minValue = VZVirtualMachineConfiguration.minimumAllowedMemorySize;
    storageControl.target = self;
    storageControl.action = @selector(_didTriggerStorageControl:);
    
    _storageControl = storageControl;
    return storageControl;
}

- (void)_didTriggerStorageControl:(EditMachineStorageControl *)sender {
    VZVirtioTraditionalMemoryBalloonDevice *virtioTraditionalMemoryBalloonDevice = self.virtioTraditionalMemoryBalloonDevice;
    
    dispatch_queue_t _queue;
    assert(object_getInstanceVariable(virtioTraditionalMemoryBalloonDevice, "_queue", reinterpret_cast<void **>(&_queue)) != NULL);
    
    uint64_t unsignedInt64Value = sender.unsignedInt64Value;
    
    dispatch_async(_queue, ^{
        if (virtioTraditionalMemoryBalloonDevice.targetVirtualMachineMemorySize == unsignedInt64Value) return;
        virtioTraditionalMemoryBalloonDevice.targetVirtualMachineMemorySize = unsignedInt64Value;
    });
}

@end
