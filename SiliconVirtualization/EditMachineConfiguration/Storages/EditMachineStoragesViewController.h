//
//  EditMachineStoragesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineStoragesViewController;
@protocol EditMachineStoragesViewControllerDelegate <NSObject>
- (void)EditMachineStoragesViewController:(EditMachineStoragesViewController *)EditMachineStoragesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration;
@end

@interface EditMachineStoragesViewController : NSViewController
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration;

@property (copy, nonatomic) VZVirtualMachineConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineStoragesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
