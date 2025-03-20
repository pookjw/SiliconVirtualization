//
//  MachinesWindow.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "MachinesWindow.h"
#import "MachinesViewController.h"

@implementation MachinesWindow

- (instancetype)init {
    self = [super initWithContentRect:NSMakeRect(0., 0., 400, 600.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Machines";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(400., 600.);
        
        MachinesViewController *contentViewController = [MachinesViewController new];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
