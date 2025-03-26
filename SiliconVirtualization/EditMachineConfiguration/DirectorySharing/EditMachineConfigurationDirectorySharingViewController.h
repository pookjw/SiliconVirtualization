//
//  EditMachineConfigurationDirectorySharingViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationDirectorySharingViewController;
@protocol EditMachineConfigurationDirectorySharingViewControllerDelegate <NSObject>
- (void)editMachineConfigurationDirectorySharingViewController:(EditMachineConfigurationDirectorySharingViewController *)editMachineConfigurationDirectorySharingViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachineConfigurationDirectorySharingViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;

@property (copy, nonatomic) VZVirtualMachineConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineConfigurationDirectorySharingViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
