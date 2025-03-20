//
//  InstallMacOSViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class InstallMacOSViewController;
@protocol InstallMacOSViewControllerDelegate <NSObject>
- (void)installMacOSViewController:(InstallMacOSViewController *)installMacOSViewController didCompleteInstallationWithError:(NSError * _Nullable)error;
@end

@interface InstallMacOSViewController : NSViewController
@property (assign, nonatomic, nullable) id<InstallMacOSViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithVirtualMachineConfiguration:(VZVirtualMachineConfiguration *)virtualMachineConfiguration;
@end

NS_ASSUME_NONNULL_END
