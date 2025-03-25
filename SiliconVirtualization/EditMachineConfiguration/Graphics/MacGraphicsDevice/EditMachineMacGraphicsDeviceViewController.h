//
//  EditMachineMacGraphicsDeviceViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacGraphicsDeviceViewController;
@protocol EditMachineMacGraphicsDeviceViewControllerDelegate <NSObject>
- (void)editMachineMacGraphicsDeviceViewController:(EditMachineMacGraphicsDeviceViewController *)editMachineMacGraphicsDeviceViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineMacGraphicsDeviceViewController:(EditMachineMacGraphicsDeviceViewController *)editMachineMacGraphicsDeviceViewController didUpdateConfiguration:(VZMacGraphicsDeviceConfiguration *)configuration;
@end

@interface EditMachineMacGraphicsDeviceViewController : NSViewController
@property (copy, nonatomic, nullable) VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration;
@property (assign, nonatomic, nullable) id<EditMachineMacGraphicsDeviceViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
