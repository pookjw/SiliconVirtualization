//
//  EditMachineBootLoaderViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachineBootLoaderViewController.h"

@interface EditMachineBootLoaderViewController ()
@property (retain, nonatomic, readonly, getter=_macosBootLoaderButton) NSButton *macosBootLoaderButton;
@end

@implementation EditMachineBootLoaderViewController
@synthesize macosBootLoaderButton = _macosBootLoaderButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_macosBootLoaderButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (NSButton *)_macosBootLoaderButton {
    if (auto macosBootLoaderButton = _macosBootLoaderButton) return macosBootLoaderButton;
    
    NSButton *macosBootLoaderButton = [NSButton new];
    macosBootLoaderButton.title = @"Set macOS BootLoader";
    macosBootLoaderButton.target = self;
    macosBootLoaderButton.action = @selector(_didTriggerMacosBootLoaderButton:);
    
    _macosBootLoaderButton = macosBootLoaderButton;
    return macosBootLoaderButton;
}

- (void)_didTriggerMacosBootLoaderButton:(NSButton *)sender {
    VZMacOSBootLoader *macOSBootLoader = [[VZMacOSBootLoader alloc] init];
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.bootLoader = macOSBootLoader;
    [macOSBootLoader release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineBootLoaderViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
