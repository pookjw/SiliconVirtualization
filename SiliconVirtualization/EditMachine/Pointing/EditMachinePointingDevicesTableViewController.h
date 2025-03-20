//
//  EditMachinePointingDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachinePointingDevicesTableViewController;
@protocol EditMachinePointingDevicesTableViewControllerDelegate <NSObject>
- (void)editMachinePointingDevicesTableViewController:(EditMachinePointingDevicesTableViewController *)editMachinePointingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachinePointingDevicesTableViewController:(EditMachinePointingDevicesTableViewController *)editMachinePointingDevicesTableViewController didUpdatePointingDevices:(NSArray<__kindof VZPointingDeviceConfiguration *> *)pointingDevices;
@end

@interface EditMachinePointingDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZPointingDeviceConfiguration *> *pointingDevices;
@property (assign, nonatomic, nullable) id<EditMachinePointingDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
