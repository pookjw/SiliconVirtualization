//
//  EditMachineSidebarViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import "EditMachineSidebarItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@class EditMachineSidebarViewController;
@protocol EditMachineSidebarViewControllerDelegate <NSObject>
- (void)editMachineSidebarViewController:(EditMachineSidebarViewController *)editMachineSidebarViewController didSelectItemModel:(EditMachineSidebarItemModel *)itemModel;
@end

@interface EditMachineSidebarViewController : NSViewController
@property (assign, nonatomic, nullable) id<EditMachineSidebarViewControllerDelegate> delegate;
@property (retain, nonatomic) EditMachineSidebarItemModel *itemModel; // notifyingDelegate = NO
- (void)setItemModel:(EditMachineSidebarItemModel *)itemModel notifyingDelegate:(BOOL)notifyingDelegate;
@end

NS_ASSUME_NONNULL_END
