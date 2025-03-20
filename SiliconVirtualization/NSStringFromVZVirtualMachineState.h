//
//  NSStringFromVZVirtualMachineState.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Virtualization/Virtualization.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

SV_EXTERN NSString * NSStringFromVZVirtualMachineState(VZVirtualMachineState state);
SV_EXTERN VZVirtualMachineState VZVirtualMachineStateFromString(NSString *string);
SV_EXTERN const VZVirtualMachineState * allVZVirtualMachineStates(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
