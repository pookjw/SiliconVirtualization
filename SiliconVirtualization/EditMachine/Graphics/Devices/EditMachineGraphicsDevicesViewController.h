//
//  EditMachineGraphicsDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineGraphicsDevicesViewController;
@protocol EditMachineGraphicsDevicesViewControllerDelegate <NSObject>
- (void)editMachineGraphicsDevicesViewController:(EditMachineGraphicsDevicesViewController *)editMachineGraphicsDevicesViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineGraphicsDevicesViewController:(EditMachineGraphicsDevicesViewController *)editMachineGraphicsDevicesViewController didUpdateGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices;
@end

@interface EditMachineGraphicsDevicesViewController : NSViewController
@property (copy, nonatomic) NSArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices;
@property (assign, nonatomic, nullable) id<EditMachineGraphicsDevicesViewControllerDelegate> delegate;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSNibName)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (nullable instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;
- (instancetype)initWithGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices;
@end

NS_ASSUME_NONNULL_END
