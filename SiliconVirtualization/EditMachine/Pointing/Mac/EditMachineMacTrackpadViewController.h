//
//  EditMachineMacTrackpadViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMacTrackpadViewController;

@protocol EditMachineMacTrackpadViewControllerDelegate <NSObject>
- (void)editMachineMacTrackpadViewController:(EditMachineMacTrackpadViewController *)editMachineMacTrackpadViewController didUpdateMacTrackpadConfiguration:(VZMacTrackpadConfiguration *)macTrackpadConfiguration;
@end

@interface EditMachineMacTrackpadViewController : NSViewController
@property (copy, nonatomic, nullable) VZMacTrackpadConfiguration *macTrackpadConfiguration;
@property (assign, nonatomic, nullable) id<EditMachineMacTrackpadViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
