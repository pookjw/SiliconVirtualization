//
//  main.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"

#warning _VZIOUSBHostPassthroughDeviceConfiguration (VZUSBDeviceConfiguration)

int main(int argc, const char * argv[]) {
    AppDelegate *delegate = [AppDelegate new];
    NSApplication *application = NSApplication.sharedApplication;
    application.delegate = delegate;
    
    [application run];
    [delegate release];
    
    return 0;
}
