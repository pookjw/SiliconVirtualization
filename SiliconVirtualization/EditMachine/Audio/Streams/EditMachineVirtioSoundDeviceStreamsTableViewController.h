//
//  EditMachineVirtioSoundDeviceStreamsTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineVirtioSoundDeviceStreamsTableViewController;

@protocol EditMachineVirtioSoundDeviceStreamsViewControllerDelegate <NSObject>
- (void)editMachineVirtioSoundDeviceStreamsViewController:(EditMachineVirtioSoundDeviceStreamsTableViewController *)editMachineVirtioSoundDeviceStreamsViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineVirtioSoundDeviceStreamsViewController:(EditMachineVirtioSoundDeviceStreamsTableViewController *)editMachineVirtioSoundDeviceStreamsViewController didUpdateStreams:(NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *)streams;
@end

@interface EditMachineVirtioSoundDeviceStreamsTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams;
@property (assign, nonatomic, nullable) id<EditMachineVirtioSoundDeviceStreamsViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
