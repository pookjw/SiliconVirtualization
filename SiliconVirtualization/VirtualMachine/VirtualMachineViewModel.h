//
//  VirtualMachineViewModel.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import <Virtualization/Virtualization.h>
#import "SVVirtualMachine.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirtualMachineViewModel : NSObject
@property (retain, nonatomic, readonly) dispatch_queue_t queue;

@property (retain, nonatomic, nullable, setter=isolated_setVirtualMachineObject:) SVVirtualMachine *isolated_virtualMachineObject;
- (void)isolated_setVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject completionHandler:(void (^ _Nullable)(void))completionHandler;

@property (retain, nonatomic, nullable, readonly) VZVirtualMachine *isolated_virtualMachine;

@property (assign, nonatomic) BOOL startUpFromMacOSRecovery;
@end

NS_ASSUME_NONNULL_END
