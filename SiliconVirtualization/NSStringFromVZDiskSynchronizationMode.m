//
//  NSStringFromVZDiskSynchronizationMode.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "NSStringFromVZDiskSynchronizationMode.h"

NSString * NSStringFromVZDiskSynchronizationMode(VZDiskSynchronizationMode mode) {
    switch (mode) {
        case VZDiskSynchronizationModeFull:
            return @"Full";
        case VZDiskSynchronizationModeNone:
            return @"None";
        default:
            abort();
    }
}

VZDiskSynchronizationMode VZDiskSynchronizationModeFromString(NSString *string) {
    if ([string isEqualToString:@"Full"]) {
        return VZDiskSynchronizationModeFull;
    } else if ([string isEqualToString:@"None"]) {
        return VZDiskSynchronizationModeNone;
    } else {
        abort();
    }
}

const VZDiskSynchronizationMode * allVZDiskSynchronizationModes(NSUInteger * _Nullable count) {
    static const VZDiskSynchronizationMode allModes[] = {
        VZDiskSynchronizationModeFull,
        VZDiskSynchronizationModeNone
    };
    
    if (count != NULL) {
        *count = sizeof(allModes) / sizeof(VZDiskSynchronizationMode);
    }
    
    return allModes;
}
