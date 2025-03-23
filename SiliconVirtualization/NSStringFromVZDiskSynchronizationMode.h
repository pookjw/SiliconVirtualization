//
//  NSStringFromVZDiskSynchronizationMode.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Virtualization/Virtualization.h>
#include "Extern.h"

NS_ASSUME_NONNULL_BEGIN

SV_EXTERN NSString * NSStringFromVZDiskSynchronizationMode(VZDiskSynchronizationMode mode);
SV_EXTERN VZDiskSynchronizationMode VZDiskSynchronizationModeFromString(NSString *string);
SV_EXTERN const VZDiskSynchronizationMode * allVZDiskSynchronizationModes(NSUInteger * _Nullable count);

NS_ASSUME_NONNULL_END
