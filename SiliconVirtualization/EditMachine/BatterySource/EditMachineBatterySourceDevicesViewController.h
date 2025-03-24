//
//  EditMachineBatterySourceDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineBatterySourceDevicesViewController;
@protocol EditMachineBatterySourceDevicesViewControllerDelegate <NSObject>
- (void)editMachineBatterySourceDevicesViewController:(EditMachineBatterySourceDevicesViewController *)editMachineBatterySourceDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachineBatterySourceDevicesViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;

@property (copy, nonatomic) VZVirtualMachineConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineBatterySourceDevicesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
