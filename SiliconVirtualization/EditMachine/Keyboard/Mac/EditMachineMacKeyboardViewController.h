//
//  EditMachineMacKeyboardViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacKeyboardViewController;

@protocol EditMachineMacKeyboardViewControllerDelegate <NSObject>
- (void)editMachineMacKeyboardViewController:(EditMachineMacKeyboardViewController *)editMachineMacKeyboardViewController didUpdateKeyboardConfiguration:(VZMacKeyboardConfiguration *)macKeyboardConfiguration;
@end

@interface EditMachineMacKeyboardViewController : NSViewController
@property (copy, nonatomic, nullable) VZMacKeyboardConfiguration *macKeyboardConfiguration;
@property (assign, nonatomic, nullable) id<EditMachineMacKeyboardViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
