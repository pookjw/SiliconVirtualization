//
//  EditMachineViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineViewController;
@protocol EditMachineViewControllerDelegate <NSObject>
- (void)editMachineViewController:(EditMachineViewController *)editMachineViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachineViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;
- (instancetype)initWithMachine:(VZVirtualMachine *)machine;

@property (copy, nonatomic, nullable) VZVirtualMachineConfiguration *configuration;
@property (copy, nonatomic, nullable) VZVirtualMachine *machine;
@property (assign, nonatomic, nullable) id<EditMachineViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
