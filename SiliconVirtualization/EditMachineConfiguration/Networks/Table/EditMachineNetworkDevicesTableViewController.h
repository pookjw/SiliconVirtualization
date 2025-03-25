//
//  EditMachineNetworkDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineNetworkDevicesTableViewController;
@protocol EditMachineNetworkDevicesViewControllerDelegate <NSObject>
- (void)editMachineNetworkDevicesViewController:(EditMachineNetworkDevicesTableViewController *)editMachineNetworkDevicesViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineNetworkDevicesViewController:(EditMachineNetworkDevicesTableViewController *)editMachineNetworkDevicesViewController didUpdateNetworkDevices:(NSArray<__kindof VZNetworkDeviceConfiguration *> *)networkDevices;
@end

@interface EditMachineNetworkDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZNetworkDeviceConfiguration *> *networkDevices;
@property (assign, nonatomic, nullable) id<EditMachineNetworkDevicesViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
