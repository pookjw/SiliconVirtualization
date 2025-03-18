//
//  EditMachineSidebarItemModel.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, EditMachineSidebarItemModelType) {
    EditMachineSidebarItemModelTypeCPU,
    EditMachineSidebarItemModelTypeMemory,
    EditMachineSidebarItemModelTypeGraphics,
    EditMachineSidebarItemModelTypeStorages,
    EditMachineSidebarItemModelTypeBootLoader
};

@interface EditMachineSidebarItemModel : NSObject
@property (assign, nonatomic, readonly) EditMachineSidebarItemModelType type;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(EditMachineSidebarItemModelType)type;
@end

NS_ASSUME_NONNULL_END
