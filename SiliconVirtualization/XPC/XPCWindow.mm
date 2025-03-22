//
//  XPCWindow.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "XPCWindow.h"
#import "XPCViewController.h"

@implementation XPCWindow

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 400, 600.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Create";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(400., 600.);
        
        XPCViewController *contentViewController = [XPCViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
