//
//  EditMachinePowerSourceDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachinePowerSourceDevicesTableViewController;

@protocol EditMachinePowerSourceDevicesTableViewControllerDelegate <NSObject>
- (void)editMachinePowerSourceDevicesTableViewController:(EditMachinePowerSourceDevicesTableViewController *)editMachinePowerSourceDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachinePowerSourceDevicesTableViewController:(EditMachinePowerSourceDevicesTableViewController *)editMachinePowerSourceDevicesTableViewController didUpdatePowerSourceDevices:(NSArray *)powerSourceDevices;
@end

@interface EditMachinePowerSourceDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray *powerSourceDevices;
@property (assign, nonatomic, nullable) id<EditMachinePowerSourceDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
