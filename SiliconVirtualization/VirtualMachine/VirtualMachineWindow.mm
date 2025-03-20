//
//  VirtualMachineWindow.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "VirtualMachineWindow.h"
#import "VirtualMachineViewController.h"

@implementation VirtualMachineWindow

- (instancetype)initWithMachineConfiguration:(VZVirtualMachineConfiguration *)machineConfiguration {
    self = [super initWithContentRect:NSMakeRect(0., 0., 1280, 800.) styleMask:NSWindowStyleMaskBorderless | NSWindowStyleMaskClosable | NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled backing:NSBackingStoreBuffered defer:NO];
    
    if (self) {
        self.title = @"Machine";
        self.releasedWhenClosed = NO;
        self.contentMinSize = NSMakeSize(1280, 800.);
        
        VZVirtualMachine *virtualMachine = [[VZVirtualMachine alloc] initWithConfiguration:machineConfiguration queue:dispatch_get_global_queue(0, 0)];
        VirtualMachineViewController *contentViewController = [VirtualMachineViewController new];
        contentViewController.virtualMachine = virtualMachine;
        [virtualMachine release];
        self.contentViewController = contentViewController;
        [contentViewController release];
    }
    
    return self;
}

@end
