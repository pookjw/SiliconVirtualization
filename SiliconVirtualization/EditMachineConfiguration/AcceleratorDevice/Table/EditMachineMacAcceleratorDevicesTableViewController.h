//
//  EditMachineMacAcceleratorDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacAcceleratorDevicesTableViewController;
@protocol EditMachineMacAcceleratorDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineMacAcceleratorDevicesTableViewController:(EditMachineMacAcceleratorDevicesTableViewController *)editMachineMacAcceleratorDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineMacAcceleratorDevicesTableViewController:(EditMachineMacAcceleratorDevicesTableViewController *)editMachineMacAcceleratorDevicesTableViewController didUpdateAcceleratorDevices:(NSArray *)acceleratorDevices;
@end

@interface EditMachineMacAcceleratorDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray *acceleratorDevices;
@property (assign, nonatomic, nullable) id<EditMachineMacAcceleratorDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
