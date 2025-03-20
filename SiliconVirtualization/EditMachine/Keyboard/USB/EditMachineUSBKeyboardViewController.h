//
//  EditMachineUSBKeyboardViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineUSBKeyboardViewController;

@protocol EditMachineUSBKeyboardViewControllerDelegate <NSObject>
- (void)editMachineUSBKeyboardViewController:(EditMachineUSBKeyboardViewController *)editMachineUSBKeyboardViewController didUpdateKeyboardConfiguration:(VZUSBKeyboardConfiguration *)USBKeyboardConfiguration;
@end

@interface EditMachineUSBKeyboardViewController : NSViewController
@property (copy, nonatomic, nullable) VZUSBKeyboardConfiguration *USBKeyboardConfiguration;
@property (assign, nonatomic, nullable) id<EditMachineUSBKeyboardViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
