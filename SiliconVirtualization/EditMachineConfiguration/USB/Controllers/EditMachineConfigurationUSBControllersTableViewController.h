//
//  EditMachineConfigurationUSBControllersTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineConfigurationUSBControllersTableViewController;

@protocol EditMachineUSBControllersTableViewControllerDelegate <NSObject>
- (void)editMachineConfigurationUSBControllersTableViewController:(EditMachineConfigurationUSBControllersTableViewController *)editMachineConfigurationUSBControllersTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineConfigurationUSBControllersTableViewController:(EditMachineConfigurationUSBControllersTableViewController *)editMachineConfigurationUSBControllersTableViewController didUpdateUSBControllers:(NSArray<__kindof VZUSBControllerConfiguration *> *)usbControllers;
@end

@interface EditMachineConfigurationUSBControllersTableViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBControllers:) NSArray<__kindof VZUSBControllerConfiguration *> *usbControllers;
@property (assign, nonatomic, nullable) id<EditMachineUSBControllersTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
