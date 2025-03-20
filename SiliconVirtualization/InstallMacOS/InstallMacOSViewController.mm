//
//  InstallMacOSViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "InstallMacOSViewController.h"
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface InstallMacOSViewController ()
@property (copy, nonatomic, readonly, getter=_virtualMachineConfiguration) VZVirtualMachineConfiguration *virtualMachineConfiguration;
@property (retain, nonatomic, readonly, getter=_openRestoreImageButton) NSButton *openRestoreImageButton;
@property (retain, nonatomic, readonly, getter=_processIndicator) NSProgressIndicator *processIndicator;
@end

@implementation InstallMacOSViewController
@synthesize openRestoreImageButton = _openRestoreImageButton;
@synthesize processIndicator = _processIndicator;

- (instancetype)initWithVirtualMachineConfiguration:(VZVirtualMachineConfiguration *)virtualMachineConfiguration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _virtualMachineConfiguration = [virtualMachineConfiguration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_virtualMachineConfiguration release];
    [_openRestoreImageButton release];
    [_processIndicator release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *openRestoreImageButton = self.openRestoreImageButton;
    [self.view addSubview:openRestoreImageButton];
    openRestoreImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [openRestoreImageButton.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [openRestoreImageButton.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
    
    NSProgressIndicator *processIndicator = self.processIndicator;
    [self.view addSubview:processIndicator];
    processIndicator.translatesAutoresizingMaskIntoConstraints = NO;
    [NSLayoutConstraint activateConstraints:@[
        [processIndicator.leadingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [processIndicator.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [processIndicator.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
}

- (NSButton *)_openRestoreImageButton {
    if (auto openRestoreImageButton = _openRestoreImageButton) return openRestoreImageButton;
    
    NSButton *openRestoreImageButton = [NSButton new];
    openRestoreImageButton.title = @"Open IPSW";
    openRestoreImageButton.target = self;
    openRestoreImageButton.action = @selector(_didTriggerOpenRestoreImageButton:);
    
    _openRestoreImageButton = openRestoreImageButton;
    return openRestoreImageButton;
}

- (NSProgressIndicator *)_processIndicator {
    if (auto processIndicator = _processIndicator) return processIndicator;
    
    NSProgressIndicator *processIndicator = [NSProgressIndicator new];
    processIndicator.style = NSProgressIndicatorStyleBar;
    processIndicator.hidden = YES;
    
    _processIndicator = processIndicator;
    return processIndicator;
}

- (void)_didTriggerOpenRestoreImageButton:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel new];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.resolvesAliases = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.itunes.ipsw"]];
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = openPanel.URL) {
            [VZMacOSRestoreImage loadFileURL:URL completionHandler:^(VZMacOSRestoreImage * _Nullable restoreImage, NSError * _Nullable error) {
                assert(error == nil);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    VZVirtualMachineConfiguration *configuration = self.virtualMachineConfiguration;
                    
                    assert(restoreImage.mostFeaturefulSupportedConfiguration.minimumSupportedCPUCount <= configuration.CPUCount);
                    assert(restoreImage.mostFeaturefulSupportedConfiguration.minimumSupportedMemorySize <= configuration.memorySize);
                    
                    VZVirtualMachine *machine = [[VZVirtualMachine alloc] initWithConfiguration:configuration];
                    VZMacOSInstaller *installer = [[VZMacOSInstaller alloc] initWithVirtualMachine:machine restoreImageURL:restoreImage.URL];
                    [machine release];
                    
                    self.openRestoreImageButton.hidden = YES;
                    
                    [installer installWithCompletionHandler:^(NSError * _Nullable error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (auto delegate = self.delegate) {
                                [delegate installMacOSViewController:self didCompleteInstallationWithError:error];
                            } else {
                                assert(error == nil);
                            }
                        });
                    }];
                    
                    NSProgressIndicator *processIndicator = self.processIndicator;
                    processIndicator.hidden = NO;
                    processIndicator.observedProgress = installer.progress;
                    
                    [installer release];
                });
            }];
        }
    }];
    
    [openPanel release];
}

@end
