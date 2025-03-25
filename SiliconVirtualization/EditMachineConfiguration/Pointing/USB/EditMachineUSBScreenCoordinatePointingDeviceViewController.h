//
//  EditMachineUSBScreenCoordinatePointingDeviceViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBScreenCoordinatePointingDeviceViewController;
@protocol EditMachineUSBScreenCoordinatePointingDeviceViewControllerDelegate <NSObject>
- (void)editMachineUSBScreenCoordinatePointingDeviceViewController:(EditMachineUSBScreenCoordinatePointingDeviceViewController *)editMachineUSBScreenCoordinatePointingDeviceViewController didUpdateUSBScreenCoordinatePointingDeviceConfiguration:(VZUSBScreenCoordinatePointingDeviceConfiguration *)USBScreenCoordinatePointingDeviceConfiguration;
@end

@interface EditMachineUSBScreenCoordinatePointingDeviceViewController : NSViewController
@property (copy, nonatomic, nullable) VZUSBScreenCoordinatePointingDeviceConfiguration *USBScreenCoordinatePointingDeviceConfiguration;
@property (assign, nonatomic, nullable) id<EditMachineUSBScreenCoordinatePointingDeviceViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
