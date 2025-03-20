//
//  EditMachineBootLoaderViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachineBootLoaderViewController.h"

@interface EditMachineBootLoaderViewController ()
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_currentBootLoaderLabel) NSTextField *currentBootLoaderLabel;
@property (retain, nonatomic, readonly, getter=_macOSBootLoaderButton) NSButton *macOSBootLoaderButton;
@end

@implementation EditMachineBootLoaderViewController
@synthesize stackView = _stackView;
@synthesize currentBootLoaderLabel = _currentBootLoaderLabel;
@synthesize macOSBootLoaderButton = _macOSBootLoaderButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super init]) {
        VZXHCIControllerConfiguration *config = [[VZXHCIControllerConfiguration alloc] init];
        
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_stackView release];
    [_currentBootLoaderLabel release];
    [_macOSBootLoaderButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [stackView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor],
        [stackView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor],
        [stackView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [self _didChangeConfiguration];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    if (__kindof VZBootLoader *bootLoader = self.configuration.bootLoader) {
        self.currentBootLoaderLabel.stringValue = bootLoader.description;
    } else {
        self.currentBootLoaderLabel.stringValue = @"(null)";
    }
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.currentBootLoaderLabel];
    [stackView addArrangedSubview:self.macOSBootLoaderButton];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeCenterX;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    
    _stackView = stackView;
    return stackView;
}

- (NSTextField *)_currentBootLoaderLabel {
    if (auto currentBootLoaderLabel = _currentBootLoaderLabel) return currentBootLoaderLabel;
    
    NSTextField *currentBootLoaderLabel = [NSTextField wrappingLabelWithString:@""];
    
    _currentBootLoaderLabel = [currentBootLoaderLabel retain];
    return currentBootLoaderLabel;
}

- (NSButton *)_macOSBootLoaderButton {
    if (auto macOSBootLoaderButton = _macOSBootLoaderButton) return macOSBootLoaderButton;
    
    NSButton *macOSBootLoaderButton = [NSButton new];
    macOSBootLoaderButton.title = @"Set macOS BootLoader";
    macOSBootLoaderButton.target = self;
    macOSBootLoaderButton.action = @selector(_didTriggermacOSBootLoaderButton:);
    
    _macOSBootLoaderButton = macOSBootLoaderButton;
    return macOSBootLoaderButton;
}

- (void)_didTriggermacOSBootLoaderButton:(NSButton *)sender {
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
