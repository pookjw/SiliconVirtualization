//
//  EditMachineVirtioFileSystemDeviceViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineVirtioFileSystemDeviceViewController;
@protocol EditMachineVirtioFileSystemDeviceViewControllerDelegate <NSObject>
- (void)editMachineVirtioFileSystemDeviceViewController:(EditMachineVirtioFileSystemDeviceViewController *)editMachineVirtioFileSystemDeviceViewController didChangeConfiguration:(VZVirtioFileSystemDeviceConfiguration *)configuration;
@end

@interface EditMachineVirtioFileSystemDeviceViewController : NSViewController
@property (copy, nonatomic, nullable) VZVirtioFileSystemDeviceConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineVirtioFileSystemDeviceViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
