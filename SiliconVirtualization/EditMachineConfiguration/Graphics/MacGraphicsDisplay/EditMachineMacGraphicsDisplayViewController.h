//
//  EditMachineMacGraphicsDisplayViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacGraphicsDisplayViewController;
@protocol EditMachineMacGraphicsDisplayViewControllerDelegate <NSObject>
- (void)editMachineMacGraphicsDisplayViewController:(EditMachineMacGraphicsDisplayViewController *)editMachineMacGraphicsDisplayViewController didUpdateConfiguration:(VZMacGraphicsDisplayConfiguration *)configuration;
@end

@interface EditMachineMacGraphicsDisplayViewController : NSViewController
@property (copy, nonatomic, nullable) VZMacGraphicsDisplayConfiguration *configuration;
@property (assign, nonatomic, nullable) id<EditMachineMacGraphicsDisplayViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
