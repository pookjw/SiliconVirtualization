//
//  EditMachineConfigurationMemoryBalloonDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationMemoryBalloonDevicesTableViewController;
@protocol EditMachineConfigurationMemoryBalloonDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineConfigurationMemoryBalloonDevicesTableViewController:(EditMachineConfigurationMemoryBalloonDevicesTableViewController *)editMachineConfigurationMemoryBalloonDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineConfigurationMemoryBalloonDevicesTableViewController:(EditMachineConfigurationMemoryBalloonDevicesTableViewController *)editMachineConfigurationMemoryBalloonDevicesTableViewController didUpateMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices;
@end

@interface EditMachineConfigurationMemoryBalloonDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<VZMemoryBalloonDeviceConfiguration *> *memoryBalloonDevices;
@property (assign, nonatomic, nullable) id<EditMachineConfigurationMemoryBalloonDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
