//
//  EditMachineVirtioSoundDeviceInputStreamViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineVirtioSoundDeviceInputStreamViewController.h"

@interface EditMachineVirtioSoundDeviceInputStreamViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_sourceLabel) NSTextField *sourceLabel;
@property (retain, nonatomic, readonly, getter=_sourcePopUpButton) NSPopUpButton *sourcePopUpButton;
@end

@implementation EditMachineVirtioSoundDeviceInputStreamViewController
@synthesize gridView = _gridView;
@synthesize sourceLabel = _sourceLabel;
@synthesize sourcePopUpButton = _sourcePopUpButton;

- (void)dealloc {
    [_configuration release];
    [_gridView release];
    [_sourceLabel release];
    [_sourcePopUpButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
}

- (void)setConfiguration:(VZVirtioSoundDeviceInputStreamConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    __kindof VZAudioInputStreamSource * _Nullable source = self.configuration.source;
    
    if (source == nil) {
        [self.sourcePopUpButton selectItemWithTitle:@"(None)"];
    } else if ([source isKindOfClass:[VZHostAudioInputStreamSource class]]) {
        [self.sourcePopUpButton selectItemWithTitle:@"Host"];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[self.sourceLabel, self.sourcePopUpButton]];
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_sourceLabel {
    if (auto sourceLabel = _sourceLabel) return sourceLabel;
    
    NSTextField *sourceLabel = [NSTextField wrappingLabelWithString:@"Source"];
    sourceLabel.selectable = NO;
    
    _sourceLabel = [sourceLabel retain];
    return sourceLabel;
}

- (NSPopUpButton *)_sourcePopUpButton {
    if (auto sourcePopUpButton = _sourcePopUpButton) return sourcePopUpButton;
    
    NSPopUpButton *sourcePopUpButton = [NSPopUpButton new];
    [sourcePopUpButton addItemsWithTitles:@[
        @"(None)",
        @"Host"
    ]];
    
    sourcePopUpButton.target = self;
    sourcePopUpButton.action = @selector(_didTriggerSourcePopUpButton:);
    
    _sourcePopUpButton = sourcePopUpButton;
    return sourcePopUpButton;
}

- (void)_didTriggerSourcePopUpButton:(NSPopUpButton *)sender {
    VZVirtioSoundDeviceInputStreamConfiguration *configuration = [self.configuration copy];
    assert(configuration != nil);
    
    __kindof VZAudioInputStreamSource * _Nullable source;
    if ([sender.titleOfSelectedItem isEqualToString:@"(None)"]) {
        source = nil;
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Host"]) {
        source = [[VZHostAudioInputStreamSource alloc] init];
    } else {
        abort();
    }
    
    configuration.source = source;
    [source release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioSoundDeviceInputStreamViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}
@end
