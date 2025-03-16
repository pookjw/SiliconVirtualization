//
//  EditMachineSidebarSeparatorView.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineSidebarSeparatorView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation EditMachineSidebarSeparatorView

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(self, sel_registerName("setBackgroundColor:"), NSColor.separatorColor);
    }
    
    return self;
}

@end
