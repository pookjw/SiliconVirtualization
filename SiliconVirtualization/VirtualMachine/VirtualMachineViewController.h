//
//  VirtualMachineViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import "SVVirtualMachine.h"

NS_ASSUME_NONNULL_BEGIN

@interface VirtualMachineViewController : NSViewController
- (void)setVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject completionHandler:(void (^ _Nullable)(void))completionHandler;
@end

NS_ASSUME_NONNULL_END
