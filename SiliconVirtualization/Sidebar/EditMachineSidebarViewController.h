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

@property (copy, nonatomic) NSArray<EditMachineSidebarItemModel *> *itemModels;

@property (retain, nonatomic) EditMachineSidebarItemModel *selectedItemModel; // notifyingDelegate = NO
- (void)selectItemModel:(EditMachineSidebarItemModel *)itemModel notifyingDelegate:(BOOL)notifyingDelegate;
@end

NS_ASSUME_NONNULL_END
