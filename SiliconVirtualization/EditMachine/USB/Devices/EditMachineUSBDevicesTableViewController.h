//
//  EditMachineUSBDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBDevicesTableViewController;

@protocol EditMachineUSBDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didUpdateUSBDevices:(NSArray<id<VZUSBDeviceConfiguration>> *)usbDevices;
@end

@interface EditMachineUSBDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBDevices:) NSArray<id<VZUSBDeviceConfiguration>> *usbDevices;
@property (assign, nonatomic, nullable) id<EditMachineUSBDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
