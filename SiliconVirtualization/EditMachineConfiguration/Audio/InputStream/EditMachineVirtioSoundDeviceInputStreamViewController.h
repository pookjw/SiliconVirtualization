//
//  EditMachineVirtioSoundDeviceInputStreamViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineVirtioSoundDeviceInputStreamViewController;
@protocol EditMachineVirtioSoundDeviceInputStreamViewControllerDelegate <NSObject>
- (void)editMachineVirtioSoundDeviceInputStreamViewController:(EditMachineVirtioSoundDeviceInputStreamViewController *)editMachineVirtioSoundDeviceInputStreamViewController didUpdateConfiguration:(VZVirtioSoundDeviceInputStreamConfiguration *)configuration;
@end

@interface EditMachineVirtioSoundDeviceInputStreamViewController : NSViewController
@property (copy, nonatomic, nullable) VZVirtioSoundDeviceInputStreamConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineVirtioSoundDeviceInputStreamViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
