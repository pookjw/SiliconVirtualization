//
//  VirtualMachineWindow.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "VirtualMachineWindow.h"
#import "VirtualMachineViewController.h"

@implementation VirtualMachineWindow

- (instancetype)initWithVirtualMachineObject:(SVVirtualMachine *)virtualMachineObject {
    self = [super initWithContentRect:NSMakeRect(0., 0., 1280, 800.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Machine";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(1280, 800.);
        
        VirtualMachineViewController *contentViewController = [VirtualMachineViewController new];
        [contentViewController setVirtualMachineObject:virtualMachineObject completionHandler:nil];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
