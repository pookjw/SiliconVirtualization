//
//  EditMachineBiometricDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineBiometricDevicesViewController;
@protocol EditMachineBiometricDevicesViewControllerDelegate <NSObject>
- (void)editMachineBiometricDevicesViewController:(EditMachineBiometricDevicesViewController *)editMachineBiometricDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachineBiometricDevicesViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;

@property (copy, nonatomic) VZVirtualMachineConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineBiometricDevicesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
