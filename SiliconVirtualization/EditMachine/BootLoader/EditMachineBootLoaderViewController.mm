//
//  EditMachineBootLoaderViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachineBootLoaderViewController.h"

@interface EditMachineBootLoaderViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_bootLoaderLabel) NSTextField *bootLoaderLabel;
@property (retain, nonatomic, readonly, getter=_bootLoaderPopUpButton) NSPopUpButton *bootLoaderPopUpButton;
@end

@implementation EditMachineBootLoaderViewController
@synthesize gridView = _gridView;
@synthesize bootLoaderLabel = _bootLoaderLabel;
@synthesize bootLoaderPopUpButton = _bootLoaderPopUpButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super init]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_gridView release];
    [_bootLoaderLabel release];
    [_bootLoaderPopUpButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
    
    [self _didChangeConfiguration];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    __kindof VZBootLoader * _Nullable bootLoader = self.configuration.bootLoader;
    if (bootLoader == nil) {
        [self.bootLoaderPopUpButton selectItemWithTitle:@"(None)"];
    } else if ([bootLoader isKindOfClass:[VZEFIBootLoader class]]) {
        abort();
    } else if ([bootLoader isKindOfClass:[VZLinuxBootLoader class]]) {
        abort();
    } else if ([bootLoader isKindOfClass:[VZMacOSBootLoader class]]) {
        [self.bootLoaderPopUpButton selectItemWithTitle:@"macOS"];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    [gridView addRowWithViews:@[self.bootLoaderLabel, self.bootLoaderPopUpButton]];
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_bootLoaderLabel {
    if (auto bootLoaderLabel = _bootLoaderLabel) return bootLoaderLabel;
    
    NSTextField *bootLoaderLabel = [NSTextField wrappingLabelWithString:@"Boot Loader"];
    
    _bootLoaderLabel = [bootLoaderLabel retain];
    return bootLoaderLabel;
}

- (NSPopUpButton *)_bootLoaderPopUpButton {
    if (auto bootLoaderPopUpButton = _bootLoaderPopUpButton) return bootLoaderPopUpButton;
    
    NSPopUpButton *bootLoaderPopUpButton = [NSPopUpButton new];
    
    [bootLoaderPopUpButton addItemsWithTitles:@[
        @"(None)",
        @"EFI",
        @"Linux",
        @"macOS"
    ]];
    
    bootLoaderPopUpButton.target = self;
    bootLoaderPopUpButton.action = @selector(_didTriggerBootLoaderPopUpButton:);
    
    _bootLoaderPopUpButton = bootLoaderPopUpButton;
    return bootLoaderPopUpButton;
}

- (void)_didTriggerBootLoaderPopUpButton:(NSPopUpButton *)sender {
    __kindof VZBootLoader * _Nullable bootLoader;
    if ([sender.titleOfSelectedItem isEqualToString:@"(None)"]) {
        bootLoader = nil;
    } else if ([sender.titleOfSelectedItem isEqualToString:@"EFI"]) {
        abort();
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Linux"]) {
        abort();
    } else if ([sender.titleOfSelectedItem isEqualToString:@"macOS"]) {
        bootLoader = [[VZMacOSBootLoader alloc] init];
    } else {
        abort();
    }
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.bootLoader = bootLoader;
    [bootLoader release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineBootLoaderViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
