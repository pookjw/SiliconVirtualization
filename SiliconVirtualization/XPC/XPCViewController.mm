//
//  XPCViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "XPCViewController.h"
#import <ServiceManagement/ServiceManagement.h>
#import "HelperXPCInterface.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Virtualization/Virtualization.h>
#import "FileHandlesManager.h"

@interface XPCViewController ()
@property (retain, nonatomic, readonly, getter=_helperService) SMAppService *helperService;
@property (retain, nonatomic, readonly, getter=_helperConnection) NSXPCConnection *helperConnection;

@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;

@property (retain, nonatomic, readonly, getter=_registerHelperButton) NSButton *registerHelperButton;
@property (retain, nonatomic, readonly, getter=_unregisterHelperButton) NSButton *unregisterHelperButton;
@property (retain, nonatomic, readonly, getter=_activateHelperButton) NSButton *activateHelperButton;
@property (retain, nonatomic, readonly, getter=_pingButton) NSButton *pingButton;
@property (retain, nonatomic, readonly, getter=_getFileHandleButton) NSButton *getFileHandleButton;
@property (retain, nonatomic, readonly, getter=_closeFileDescriptorButton) NSButton *closeFileDescriptorButton;
@end

@implementation XPCViewController
@synthesize helperService = _helperService;
@synthesize helperConnection = _helperConnection;

@synthesize stackView = _stackView;
@synthesize registerHelperButton = _registerHelperButton;
@synthesize unregisterHelperButton = _unregisterHelperButton;
@synthesize activateHelperButton = _activateHelperButton;
@synthesize pingButton = _pingButton;
@synthesize getFileHandleButton = _getFileHandleButton;
@synthesize closeFileDescriptorButton = _closeFileDescriptorButton;

- (void)dealloc {
    [_helperService release];
    [_helperConnection invalidate];
    [_helperConnection release];
    [_stackView release];
    [_registerHelperButton release];
    [_unregisterHelperButton release];
    [_activateHelperButton release];
    [_pingButton release];
    [_getFileHandleButton release];
    [_closeFileDescriptorButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
}

- (SMAppService *)_helperService {
    if (auto helperService = _helperService) return helperService;
    
    SMAppService *helperService = [SMAppService daemonServiceWithPlistName:@"com.pookjw.SiliconVirtualization.Helper.plist"];
    
    _helperService = [helperService retain];
    return helperService;
}

- (NSXPCConnection *)_helperConnection {
    if (auto helperConnection = _helperConnection) return helperConnection;
    
    NSXPCConnection *helperConnection = [[NSXPCConnection alloc] initWithMachServiceName:@"com.pookjw.SiliconVirtualization.Helper" options:NSXPCConnectionPrivileged];
    helperConnection.remoteObjectInterface = [NSXPCInterface interfaceWithProtocol:@protocol(HelperXPCInterface)];
    
    __block auto unretained = helperConnection;
    helperConnection.invalidationHandler = ^{
        NSLog(@"%@", reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretained, sel_registerName("_errorDescription")));
        NSLog(@"Invalidated!");
    };
    helperConnection.interruptionHandler = ^{
        NSLog(@"%@", reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(unretained, sel_registerName("_errorDescription")));
        NSLog(@"Interrupted!");
    };
    
    _helperConnection = helperConnection;
    return helperConnection;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.registerHelperButton];
    [stackView addArrangedSubview:self.unregisterHelperButton];
    [stackView addArrangedSubview:self.activateHelperButton];
    [stackView addArrangedSubview:self.pingButton];
    [stackView addArrangedSubview:self.getFileHandleButton];
    [stackView addArrangedSubview:self.closeFileDescriptorButton];
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    
    _stackView = stackView;
    return stackView;
}

- (NSButton *)_registerHelperButton {
    if (auto registerHelperButton = _registerHelperButton) return registerHelperButton;
    
    NSButton *registerHelperButton = [NSButton new];
    registerHelperButton.title = @"Register";
    registerHelperButton.target = self;
    registerHelperButton.action = @selector(_didTriggerRegisterHelperButton:);
    
    _registerHelperButton = registerHelperButton;
    return registerHelperButton;
}

- (NSButton *)_unregisterHelperButton {
    if (auto unregisterHelperButton = _unregisterHelperButton) return unregisterHelperButton;
    
    NSButton *unregisterHelperButton = [NSButton new];
    unregisterHelperButton.title = @"Unregister";
    unregisterHelperButton.target = self;
    unregisterHelperButton.action = @selector(_didTriggerUnregisterHelperButton:);
    
    _unregisterHelperButton = unregisterHelperButton;
    return unregisterHelperButton;
}

- (NSButton *)_activateHelperButton {
    if (auto activateHelperButton = _activateHelperButton) return activateHelperButton;
    
    NSButton *activateHelperButton = [NSButton new];
    activateHelperButton.title = @"Activate";
    activateHelperButton.target = self;
    activateHelperButton.action = @selector(_didTriggerActivateHelperButton:);
    
    _activateHelperButton = activateHelperButton;
    return activateHelperButton;
}

- (NSButton *)_pingButton {
    if (auto pingButton = _pingButton) return pingButton;
    
    NSButton *pingButton = [NSButton new];
    pingButton.title = @"Ping";
    pingButton.target = self;
    pingButton.action = @selector(_didTriggerPingButton:);
    
    _pingButton = pingButton;
    return pingButton;
}

- (NSButton *)_getFileHandleButton {
    if (auto getFileHandleButton = _getFileHandleButton) return getFileHandleButton;
    
    NSButton *getFileHandleButton = [NSButton new];
    getFileHandleButton.title = @"Get File Handle";
    getFileHandleButton.target = self;
    getFileHandleButton.action = @selector(_didTriggerGetFileHandleButton:);
    
    _getFileHandleButton = getFileHandleButton;
    return getFileHandleButton;
}

- (NSButton *)_closeFileDescriptorButton {
    if (auto closeFileDescriptorButton = _closeFileDescriptorButton) return closeFileDescriptorButton;
    
    NSButton *closeFileDescriptorButton = [NSButton new];
    closeFileDescriptorButton.title = @"Close File Descriptor";
    closeFileDescriptorButton.target = self;
    closeFileDescriptorButton.action = @selector(didTriggerCloseFileDescriptorButton:);
    
    _closeFileDescriptorButton = closeFileDescriptorButton;
    return closeFileDescriptorButton;
}

- (void)_didTriggerRegisterHelperButton:(NSButton *)sender {
    NSError * _Nullable error = nil;
    [self.helperService registerAndReturnError:&error];
    assert(error == nil);
}

- (void)_didTriggerUnregisterHelperButton:(NSButton *)sender {
    [self.helperService unregisterWithCompletionHandler:^(NSError * _Nullable error) {
        assert(error == nil);
    }];
}

- (void)_didTriggerActivateHelperButton:(NSButton *)sender {
    [self.helperConnection activate];
}

- (void)_didTriggerPingButton:(NSButton *)sender {
    id<HelperXPCInterface> remoteObjectProxy = self.helperConnection.remoteObjectProxy;
    [remoteObjectProxy pingWithCompletionHandler:^(NSString *string) {
        NSLog(@"%@", string);
    }];
}

- (void)_didTriggerGetFileHandleButton:(NSButton *)sender {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"URL";
    
    NSTextField *textField = [NSTextField new];
    textField.stringValue = @"/dev/rdisk";
    [textField sizeToFit];
    textField.frame = NSMakeRect(0., 0., 200., textField.fittingSize.height);
    alert.accessoryView = textField;
    
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            NSURL *URL = [NSURL fileURLWithPath:textField.stringValue];
            
            id<HelperXPCInterface> remoteObjectProxy = self.helperConnection.remoteObjectProxy;
            [remoteObjectProxy openFromURL:URL completionHandler:^(NSFileHandle * _Nonnull fileHandle) {
                [FileHandlesManager.sharedInstance withLock:^(NSMutableSet<NSFileHandle *> * _Nonnull handles) {
                    [handles addObject:fileHandle];
                }];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSAlert *alert = [NSAlert new];
                    alert.messageText = @"File Descriptor";
                    alert.informativeText = @(fileHandle.fileDescriptor).stringValue;
                    
                    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
                        
                    }];
                    [alert release];
                });
            }];
        }
    }];
    
    [textField release];
    [alert release];
}

- (void)didTriggerCloseFileDescriptorButton:(NSButton *)sender {
    NSAlert *alert = [NSAlert new];
    alert.messageText = @"File Descriptor";
    
    NSTextField *textField = [NSTextField new];
    [textField sizeToFit];
    textField.frame = NSMakeRect(0., 0., 200., textField.fittingSize.height);
    alert.accessoryView = textField;
    
    [alert addButtonWithTitle:@"OK"];
    [alert addButtonWithTitle:@"Cancel"];
    
    [alert beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse returnCode) {
        if (returnCode == NSAlertFirstButtonReturn) {
            int fd = textField.stringValue.intValue;
            
            id<HelperXPCInterface> remoteObjectProxy = self.helperConnection.remoteObjectProxy;
            [remoteObjectProxy closeWithFileDescriptor:fd completionHandler:^(int result) {
                NSLog(@"%d", result);
            }];
        }
    }];
    [textField release];
    [alert release];
}

@end
