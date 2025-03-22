//
//  EditMachineVirtioSoundDeviceOutputStreamViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineVirtioSoundDeviceOutputStreamViewController.h"

@interface EditMachineVirtioSoundDeviceOutputStreamViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_sinkLabel) NSTextField *sinkLabel;
@property (retain, nonatomic, readonly, getter=_sinkPopUpButton) NSPopUpButton *sinkPopUpButton;
@end

@implementation EditMachineVirtioSoundDeviceOutputStreamViewController
@synthesize gridView = _gridView;
@synthesize sinkLabel = _sinkLabel;
@synthesize sinkPopUpButton = _sinkPopUpButton;

- (void)dealloc {
    [_configuration release];
    [_gridView release];
    [_sinkLabel release];
    [_sinkPopUpButton release];
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

- (void)setConfiguration:(VZVirtioSoundDeviceOutputStreamConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    __kindof VZAudioOutputStreamSink * _Nullable sink = self.configuration.sink;
    
    if (sink == nil) {
        [self.sinkPopUpButton selectItemWithTitle:@"(None)"];
    } else if ([sink isKindOfClass:[VZHostAudioOutputStreamSink class]]) {
        [self.sinkPopUpButton selectItemWithTitle:@"Host"];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[self.sinkLabel, self.sinkPopUpButton]];
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_sinkLabel {
    if (auto sinkLabel = _sinkLabel) return sinkLabel;
    
    NSTextField *sinkLabel = [NSTextField wrappingLabelWithString:@"Sink"];
    sinkLabel.selectable = NO;
    
    _sinkLabel = [sinkLabel retain];
    return sinkLabel;
}

- (NSPopUpButton *)_sinkPopUpButton {
    if (auto sinkPopUpButton = _sinkPopUpButton) return sinkPopUpButton;
    
    NSPopUpButton *sinkPopUpButton = [NSPopUpButton new];
    [sinkPopUpButton addItemsWithTitles:@[
        @"(None)",
        @"Host"
    ]];
    
    sinkPopUpButton.target = self;
    sinkPopUpButton.action = @selector(_didTriggerSinkPopUpButton:);
    
    _sinkPopUpButton = sinkPopUpButton;
    return sinkPopUpButton;
}

- (void)_didTriggerSinkPopUpButton:(NSPopUpButton *)sender {
    VZVirtioSoundDeviceOutputStreamConfiguration *configuration = [self.configuration copy];
    assert(configuration != nil);
    
    __kindof VZAudioOutputStreamSink * _Nullable sink;
    if ([sender.titleOfSelectedItem isEqualToString:@"(None)"]) {
        sink = nil;
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Host"]) {
        sink = [[VZHostAudioOutputStreamSink alloc] init];
    } else {
        abort();
    }
    
    configuration.sink = sink;
    [sink release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioSoundDeviceOutputStreamViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
