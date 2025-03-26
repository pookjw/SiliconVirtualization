//
//  EditMachineConfigurationDirectorySharingDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationDirectorySharingDevicesTableViewController;

@protocol EditMachineConfigurationDirectorySharingDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineConfigurationDirectorySharingDevicesTableViewController:(EditMachineConfigurationDirectorySharingDevicesTableViewController *)editMachineConfigurationDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineConfigurationDirectorySharingDevicesTableViewController:(EditMachineConfigurationDirectorySharingDevicesTableViewController *)editMachineConfigurationDirectorySharingDevicesTableViewController didUpdateDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices;
@end

@interface EditMachineConfigurationDirectorySharingDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *directorySharingDevices;
@property (assign, nonatomic, nullable) id<EditMachineConfigurationDirectorySharingDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
