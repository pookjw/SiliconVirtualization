//
//  EditMachineNetworkDeviceViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineNetworkDeviceViewController;
@protocol EditMachineNetworkDeviceViewControllerDelegate <NSObject>
- (void)editMachineNetworkDeviceViewController:(EditMachineNetworkDeviceViewController *)editMachineNetworkDeviceViewController didUpdateNetworkDevice:(__kindof VZNetworkDeviceConfiguration *)networkDevice;
@end

@interface EditMachineNetworkDeviceViewController : NSViewController
@property (copy, nonatomic, nullable) __kindof VZNetworkDeviceConfiguration *networkDevice;
@property (assign, nonatomic, nullable) id<EditMachineNetworkDeviceViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
