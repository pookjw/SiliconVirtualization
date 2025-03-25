//
//  EditMachinePowerSourceDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachinePowerSourceDevicesViewController;
@protocol EditMachinePowerSourceDevicesViewControllerDelegate <NSObject>
- (void)editMachinePowerSourceDevicesViewController:(EditMachinePowerSourceDevicesViewController *)editMachinePowerSourceDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachinePowerSourceDevicesViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;

@property (copy, nonatomic) VZVirtualMachineConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachinePowerSourceDevicesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
