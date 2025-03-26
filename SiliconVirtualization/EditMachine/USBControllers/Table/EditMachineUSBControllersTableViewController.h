//
//  EditMachineUSBControllersTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBControllersTableViewController;

@protocol EditMachineUSBControllersTableViewControllerDelegate <NSObject>
- (void)editMachineUSBControllersTableViewController:(EditMachineUSBControllersTableViewController *)editMachineUSBControllersTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
@end;

@interface EditMachineUSBControllersTableViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBControllers:) NSArray<__kindof VZUSBController *> *usbControllers;
@property (assign, nonatomic, nullable) id<EditMachineUSBControllersTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
