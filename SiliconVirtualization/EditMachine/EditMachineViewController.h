//
//  EditMachineViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineViewController : NSViewController
@property (retain, nonatomic, nullable) VZVirtualMachine *machine;
@end

NS_ASSUME_NONNULL_END
