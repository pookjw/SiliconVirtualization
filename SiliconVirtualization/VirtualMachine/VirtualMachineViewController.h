//
//  VirtualMachineViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface VirtualMachineViewController : NSViewController
@property (retain, nonatomic, nullable) VZVirtualMachine *virtualMachine;
@end

NS_ASSUME_NONNULL_END
