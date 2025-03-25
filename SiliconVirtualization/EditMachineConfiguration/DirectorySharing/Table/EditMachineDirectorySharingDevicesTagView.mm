//
//  EditMachineDirectorySharingDevicesTagView.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineDirectorySharingDevicesTagView.h"
#import <Virtualization/Virtualization.h>
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineDirectorySharingDevicesTagView () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_tagTextField) NSTextField *tagTextField;
@property (retain, nonatomic, readonly, getter=_macOSGuestAutomountTagButton) NSButton *macOSGuestAutomountTagButton;
@property (retain, nonatomic, readonly, getter=_validationLabel) NSTextField *validationLabel;
@property (copy, nonatomic, nullable, setter=_setValidationError:) NSError *validationError;
@end

@implementation EditMachineDirectorySharingDevicesTagView
@synthesize stackView = _stackView;
@synthesize tagTextField = _tagTextField;
@synthesize macOSGuestAutomountTagButton = _macOSGuestAutomountTagButton;
@synthesize validationLabel = _validationLabel;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSStackView *stackView = self.stackView;
        stackView.frame = self.bounds;
        stackView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:stackView];
    }
    
    return self;
}

- (void)dealloc {
    [_stackView release];
    [_tagTextField release];
    [_macOSGuestAutomountTagButton release];
    [_validationLabel release];
    [_validationError release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (NSString *)deviceTag {
    return self.tagTextField.stringValue;
}

- (void)setDeviceTag:(NSString *)deviceTag {
    self.tagTextField.stringValue = deviceTag;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    
    [stackView addArrangedSubview:self.tagTextField];
    [stackView addArrangedSubview:self.macOSGuestAutomountTagButton];
    [stackView addArrangedSubview:self.validationLabel];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    stackView.alignment = NSLayoutAttributeCenterX;
    
    _stackView = stackView;
    return stackView;
}

- (NSTextField *)_tagTextField {
    if (auto tagTextField = _tagTextField) return tagTextField;
    
    NSTextField *tagTextField = [NSTextField new];
    tagTextField.stringValue = VZVirtioFileSystemDeviceConfiguration.macOSGuestAutomountTag;
    tagTextField.delegate = self;
    
    _tagTextField = tagTextField;
    return tagTextField;
}

- (NSButton *)_macOSGuestAutomountTagButton {
    if (auto macOSGuestAutomountTagButton = _macOSGuestAutomountTagButton) return macOSGuestAutomountTagButton;
    
    NSButton *macOSGuestAutomountTagButton = [NSButton new];
    macOSGuestAutomountTagButton.title = @"Set macOS Guest Automount Tag";
    macOSGuestAutomountTagButton.target = self;
    macOSGuestAutomountTagButton.action = @selector(_didTriggerMacOSGuestAutomountTagButton:);
    
    _macOSGuestAutomountTagButton = macOSGuestAutomountTagButton;
    return macOSGuestAutomountTagButton;
}

- (NSTextField *)_validationLabel {
    if (auto validationLabel = _validationLabel) return validationLabel;
    
    NSTextField *validationLabel = [NSTextField wrappingLabelWithString:@""];
    validationLabel.selectable = NO;
    
    _validationLabel = [validationLabel retain];
    [self _updateValidationLabel];
    return validationLabel;
}

- (void)_didTriggerMacOSGuestAutomountTagButton:(NSButton *)sender {
    self.tagTextField.stringValue = VZVirtioFileSystemDeviceConfiguration.macOSGuestAutomountTag;
    [self _updateValidationLabel];
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self _updateValidationLabel];
}

- (void)_updateValidationLabel {
    NSError * _Nullable error = nil;
    [VZVirtioFileSystemDeviceConfiguration validateTag:self.tagTextField.stringValue error:&error];
    
    if (error != nil) {
        self.validationLabel.stringValue = error.description;
    } else {
        self.validationLabel.stringValue = @"Valid";
    }
    
    if (NSWindow *window = self.window) {
        NSAlert *alert = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(self.window, sel_registerName("alert"));
        assert([alert.accessoryView isEqual:self]);
        self.frame = NSMakeRect(0., 0., NSWidth(self.frame), self.fittingSize.height);
        [alert layout];
    }
}

@end
