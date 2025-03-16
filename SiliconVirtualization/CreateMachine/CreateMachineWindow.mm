//
//  CreateMachineWindow.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "CreateMachineWindow.h"
#import "CreateMachineViewController.h"

@implementation CreateMachineWindow

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 400, 600.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Create";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(400., 600.);
        self.canBecomeVisibleWithoutLogin = YES;
        self.restorable = YES;
        self.allowsConcurrentViewDrawing = YES;
        
        CreateMachineViewController *contentViewController = [CreateMachineViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
