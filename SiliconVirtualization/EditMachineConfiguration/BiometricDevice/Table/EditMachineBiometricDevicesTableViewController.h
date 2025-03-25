//
//  EditMachineBiometricDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineBiometricDevicesTableViewController;
@protocol EditMachineBiometricDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineBiometricDevicesTableViewController:(EditMachineBiometricDevicesTableViewController *)editMachineAudioDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineAudioDevicesTableViewController:(EditMachineBiometricDevicesTableViewController *)editMachineAudioDevicesTableViewController didUpdateBiometricDevices:(NSArray *)biometricDevices;
@end

@interface EditMachineBiometricDevicesTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray *biometricDevices;
@property (assign, nonatomic, nullable) id<EditMachineBiometricDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
