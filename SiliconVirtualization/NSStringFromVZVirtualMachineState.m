//
//  NSStringFromVZVirtualMachineState.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "NSStringFromVZVirtualMachineState.h"

NSString * NSStringFromVZVirtualMachineState(VZVirtualMachineState state) {
    switch (state) {
        case VZVirtualMachineStateStopped:
            return @"Stopped";
        case VZVirtualMachineStateRunning:
            return @"Running";
        case VZVirtualMachineStatePaused:
            return @"Paused";
        case VZVirtualMachineStateError:
            return @"Error";
        case VZVirtualMachineStateStarting:
            return @"Starting";
        case VZVirtualMachineStatePausing:
            return @"Pausing";
        case VZVirtualMachineStateResuming:
            return @"Resuming";
        case VZVirtualMachineStateStopping:
            return @"Stopping";
        case VZVirtualMachineStateSaving:
            return @"Saving";
        case VZVirtualMachineStateRestoring:
            return @"Restoring";
        default:
            abort();
    }
}

VZVirtualMachineState VZVirtualMachineStateFromString(NSString *string) {
    if ([string isEqualToString:@"Stopped"]) {
        return VZVirtualMachineStateStopped;
    } else if ([string isEqualToString:@"Running"]) {
        return VZVirtualMachineStateRunning;
    } else if ([string isEqualToString:@"Paused"]) {
        return VZVirtualMachineStatePaused;
    } else if ([string isEqualToString:@"Error"]) {
        return VZVirtualMachineStateError;
    } else if ([string isEqualToString:@"Starting"]) {
        return VZVirtualMachineStateStarting;
    } else if ([string isEqualToString:@"Pausing"]) {
        return VZVirtualMachineStatePausing;
    } else if ([string isEqualToString:@"Resuming"]) {
        return VZVirtualMachineStateResuming;
    } else if ([string isEqualToString:@"Stopping"]) {
        return VZVirtualMachineStateStopping;
    } else if ([string isEqualToString:@"Saving"]) {
        return VZVirtualMachineStateSaving;
    } else if ([string isEqualToString:@"Restoring"]) {
        return VZVirtualMachineStateRestoring;
    } else {
        abort();
    }
}

const VZVirtualMachineState * allVZVirtualMachineStates(NSUInteger * _Nullable count) {
    static const VZVirtualMachineState allStates[] = {
        VZVirtualMachineStateStopped,
        VZVirtualMachineStateRunning,
        VZVirtualMachineStatePaused,
        VZVirtualMachineStateError,
        VZVirtualMachineStateStarting,
        VZVirtualMachineStatePausing,
        VZVirtualMachineStateResuming,
        VZVirtualMachineStateStopping,
        VZVirtualMachineStateSaving,
        VZVirtualMachineStateRestoring
    };
    
    if (count != NULL) {
        *count = sizeof(allStates) / sizeof(VZVirtualMachineState);
    }
    
    return allStates;
}
