//
//  EditMachineSidebarViewItem.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import "EditMachineSidebarItemModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineSidebarViewItem : NSCollectionViewItem
@property (retain, nonatomic, nullable) EditMachineSidebarItemModel *itemModel;
@end

NS_ASSUME_NONNULL_END
