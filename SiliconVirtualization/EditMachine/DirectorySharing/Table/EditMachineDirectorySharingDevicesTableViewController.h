//
//  EditMachineDirectorySharingDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineDirectorySharingDevicesTableViewController;

@protocol EditMachineDirectorySharingDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didUpdateDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices;
@end

@interface EditMachineDirectorySharingDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *directorySharingDevices;
@property (assign, nonatomic, nullable) id<EditMachineDirectorySharingDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
