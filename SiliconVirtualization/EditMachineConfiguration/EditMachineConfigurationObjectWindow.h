//
//  EditMachineConfigurationObjectWindow.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <Cocoa/Cocoa.h>
#import "SVVirtualMachineConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineConfigurationObjectWindow : NSWindow
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag screen:(nullable NSScreen *)screen NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithMachineConfigurationObject:(SVVirtualMachineConfiguration *)machineConfigurationObject;
@end

NS_ASSUME_NONNULL_END
