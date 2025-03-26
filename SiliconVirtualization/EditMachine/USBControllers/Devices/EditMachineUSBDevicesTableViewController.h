//
//  EditMachineUSBDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBDevicesTableViewController;
@protocol EditMachineUSBDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController attachUSBDevice:(id<VZUSBDevice>)device;
- (void)editMachineUSBDevicesTableViewController:(EditMachineUSBDevicesTableViewController *)editMachineUSBDevicesTableViewController detachUSBDevice:(id<VZUSBDevice>)device;
@end

@interface EditMachineUSBDevicesTableViewController : NSViewController
@property (retain, nonatomic, setter=setUSBDevices:) NSArray<id<VZUSBDevice>> *usbDevices;
@property (assign, nonatomic, nullable) id<EditMachineUSBDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
