//
//  EditMachineConfigurationUSBDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationUSBDevicesTableViewController;

@protocol EditMachineConfigurationUSBDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineConfigurationUSBDevicesTableViewController:(EditMachineConfigurationUSBDevicesTableViewController *)editMachineConfigurationUSBDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineConfigurationUSBDevicesTableViewController:(EditMachineConfigurationUSBDevicesTableViewController *)editMachineConfigurationUSBDevicesTableViewController didUpdateUSBDevices:(NSArray<id<VZUSBDeviceConfiguration>> *)usbDevices;
@end

@interface EditMachineConfigurationUSBDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBDevices:) NSArray<id<VZUSBDeviceConfiguration>> *usbDevices;
@property (assign, nonatomic, nullable) id<EditMachineConfigurationUSBDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
