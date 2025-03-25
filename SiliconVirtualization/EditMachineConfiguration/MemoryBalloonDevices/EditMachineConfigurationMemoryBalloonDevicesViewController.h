//
//  EditMachineConfigurationMemoryBalloonDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationMemoryBalloonDevicesViewController;
@protocol EditMachineConfigurationMemoryBalloonDevicesViewControllerDelegate <NSObject>
- (void)editMachineConfigurationMemoryBalloonDevicesViewController:(EditMachineConfigurationMemoryBalloonDevicesViewController *)editMachineConfigurationMemoryBalloonDevicesViewController didUpateMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices;
@end

@interface EditMachineConfigurationMemoryBalloonDevicesViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<VZMemoryBalloonDeviceConfiguration *> *memoryBalloonDevices;
@property (assign, nonatomic, nullable) id<EditMachineConfigurationMemoryBalloonDevicesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
