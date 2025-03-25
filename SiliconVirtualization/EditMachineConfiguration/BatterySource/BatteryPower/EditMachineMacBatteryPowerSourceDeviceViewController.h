//
//  EditMachineMacBatteryPowerSourceDeviceViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacBatteryPowerSourceDeviceViewController;
@protocol EditMachineMacBatteryPowerSourceDeviceViewControllerDelegate <NSObject>
- (void)editMachineMacBatteryPowerSourceDeviceViewController:(EditMachineMacBatteryPowerSourceDeviceViewController *)editMachineMacBatteryPowerSourceDeviceViewController didUpdatePowerSourceDevice:(id)powerSourceDevice;
@end

@interface EditMachineMacBatteryPowerSourceDeviceViewController : NSViewController
@property (copy, nonatomic, nullable) id powerSourceDevice;
@property (assign, nonatomic, nullable) id<EditMachineMacBatteryPowerSourceDeviceViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
