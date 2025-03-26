//
//  EditMachineDirectorySharingDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineDirectorySharingDevicesTableViewController;
@protocol EditMachineDirectorySharingDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineDirectorySharingDevicesTableViewController:(EditMachineDirectorySharingDevicesTableViewController *)editMachineDirectorySharingDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
@end

@interface EditMachineDirectorySharingDevicesTableViewController : NSViewController
@property (retain, nonatomic) NSArray<__kindof VZDirectorySharingDevice *> *directorySharingDevices;
@property (assign, nonatomic, nullable) id<EditMachineDirectorySharingDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
