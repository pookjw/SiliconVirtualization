//
//  AppDelegate.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "AppDelegate.h"
#import "MachinesWindow.h"

@interface AppDelegate ()
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    MachinesWindow *window = [MachinesWindow new];
    [window makeKeyAndOrderFront:nil];
    [window release];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    
}

- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

@end
