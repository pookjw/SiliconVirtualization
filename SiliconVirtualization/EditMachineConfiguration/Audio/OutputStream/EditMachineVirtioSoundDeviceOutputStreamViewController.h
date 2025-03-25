//
//  EditMachineVirtioSoundDeviceOutputStreamViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineVirtioSoundDeviceOutputStreamViewController;
@protocol EditMachineVirtioSoundDeviceOutputStreamViewControllerDelegate <NSObject>
- (void)editMachineVirtioSoundDeviceOutputStreamViewController:(EditMachineVirtioSoundDeviceOutputStreamViewController *)editMachineVirtioSoundDeviceOutputStreamViewController didUpdateConfiguration:(VZVirtioSoundDeviceOutputStreamConfiguration *)configuration;
@end

@interface EditMachineVirtioSoundDeviceOutputStreamViewController : NSViewController
@property (copy, nonatomic, nullable) VZVirtioSoundDeviceOutputStreamConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineVirtioSoundDeviceOutputStreamViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
