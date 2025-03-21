//
//  VirtualMachineWindow.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import "SVVirtualMachine.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirtualMachineWindow : NSWindow
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag NS_UNAVAILABLE;
- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)backingStoreType defer:(BOOL)flag screen:(nullable NSScreen *)screen NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject;
@end

NS_ASSUME_NONNULL_END
