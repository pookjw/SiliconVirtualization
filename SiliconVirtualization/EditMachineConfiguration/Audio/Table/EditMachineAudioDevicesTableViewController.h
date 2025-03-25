//
//  EditMachineAudioDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineAudioDevicesTableViewController;

@protocol EditMachineAudioDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineAudioDevicesTableViewController:(EditMachineAudioDevicesTableViewController *)editMachineAudioDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineAudioDevicesTableViewController:(EditMachineAudioDevicesTableViewController *)editMachineAudioDevicesTableViewController didUpdateAudioDevices:(NSArray<__kindof VZAudioDeviceConfiguration *> *)audioDevices;
@end

@interface EditMachineAudioDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZAudioDeviceConfiguration *> *audioDevices;
@property (assign, nonatomic, nullable) id<EditMachineAudioDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
