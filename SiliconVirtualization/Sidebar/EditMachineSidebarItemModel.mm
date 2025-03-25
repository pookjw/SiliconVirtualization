//
//  EditMachineSidebarItemModel.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineSidebarItemModel.h"

@implementation EditMachineSidebarItemModel

- (instancetype)initWithType:(EditMachineSidebarItemModelType)type {
    if (self = [super init]) {
        _type = type;
    }
    
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    
    if (![other isKindOfClass:[EditMachineSidebarItemModel class]]) {
        return NO;
    }
    
    auto casted = static_cast<EditMachineSidebarItemModel *>(other);
    
    return _type == casted->_type;
}

- (NSUInteger)hash {
    return _type;
}

@end
