//
//  EditMachineUSBControllersTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBControllersTableViewController;

@protocol EditMachineUSBControllersTableViewControllerDelegate <NSObject>
- (void)editMachineUSBControllersTableViewControllerDelegate:(EditMachineUSBControllersTableViewController *)editMachineUSBControllersTableViewControllerDelegate didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineUSBControllersTableViewControllerDelegate:(EditMachineUSBControllersTableViewController *)editMachineUSBControllersTableViewControllerDelegate didUpdateUSBControllers:(NSArray<__kindof VZUSBControllerConfiguration *> *)usbControllers;
@end

@interface EditMachineUSBControllersTableViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBControllers:) NSArray<__kindof VZUSBControllerConfiguration *> *usbControllers;
@property (assign, nonatomic, nullable) id<EditMachineUSBControllersTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
