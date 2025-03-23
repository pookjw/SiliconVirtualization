//
//  EditMachineVirtioFileSystemDeviceDirectoryShareView.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "EditMachineVirtioFileSystemDeviceDirectoryShareView.h"
#import <Virtualization/Virtualization.h>

@interface EditMachineVirtioFileSystemDeviceDirectoryShareView () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_nameLabel) NSTextField *nameLabel;
@property (retain, nonatomic, readonly, getter=_nameTextField) NSTextField *nameTextField;

@property (retain, nonatomic, readonly, getter=_readOnlyLabel) NSTextField *readOnlyLabel;
@property (retain, nonatomic, readonly, getter=_readOnlySwitch) NSSwitch *readOnlySwitch;

@property (retain, nonatomic, readonly, getter=_validationLabel) NSTextField *validationLabel;
@property (retain, nonatomic, readonly, getter=_validationErrorLabel) NSTextField *validationErrorLabel;

@property (retain, nonatomic, readonly, getter=_canonicalizeButton) NSButton *canonicalizeButton;
@end

@implementation EditMachineVirtioFileSystemDeviceDirectoryShareView
@synthesize gridView = _gridView;
@synthesize nameLabel = _nameLabel;
@synthesize nameTextField = _nameTextField;
@synthesize readOnlyLabel = _readOnlyLabel;
@synthesize readOnlySwitch = _readOnlySwitch;
@synthesize validationLabel = _validationLabel;
@synthesize validationErrorLabel = _validationErrorLabel;
@synthesize canonicalizeButton = _canonicalizeButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSGridView *gridView = self.gridView;
        gridView.frame = self.bounds;
        gridView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:gridView];
    }
    
    return self;
}

- (void)dealloc {
    [_gridView release];
    [_nameLabel release];
    [_nameTextField release];
    [_readOnlyLabel release];
    [_readOnlySwitch release];
    [_validationLabel release];
    [_validationErrorLabel release];
    [_canonicalizeButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.gridView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.gridView.intrinsicContentSize;
}

- (NSString *)name {
    return self.nameTextField.stringValue;
}

- (void)setName:(NSString *)name {
    self.nameTextField.stringValue = name;
    [self _didChangeName];
}

- (BOOL)readOnly {
    return (self.readOnlySwitch.state == NSControlStateValueOn);
}

- (void)setReadOnly:(BOOL)readOnly {
    self.readOnlySwitch.state = (readOnly ? NSControlStateValueOn : NSControlStateValueOff);
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.nameLabel, self.nameTextField]];
        [row cellAtIndex:1].customPlacementConstraints = @[
            [self.nameTextField.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    [gridView addRowWithViews:@[self.readOnlyLabel, self.readOnlySwitch]];
    [gridView addRowWithViews:@[self.validationLabel, self.validationErrorLabel]];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.canonicalizeButton]];
        [row mergeCellsInRange:NSMakeRange(0, 2)];
    }
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_nameLabel {
    if (auto nameLabel = _nameLabel) return nameLabel;
    
    NSTextField *nameLabel = [NSTextField wrappingLabelWithString:@"Name"];
    nameLabel.selectable = NO;
    
    _nameLabel = [nameLabel retain];
    return nameLabel;
}

- (NSTextField *)_nameTextField {
    if (auto nameTextField = _nameTextField) return nameTextField;
    
    NSTextField *nameTextField = [NSTextField new];
    nameTextField.stringValue = [NSUUID UUID].UUIDString;
    nameTextField.delegate = self;
    
    _nameTextField = nameTextField;
    return nameTextField;
}

- (NSTextField *)_readOnlyLabel {
    if (auto readOnlyLabel = _readOnlyLabel) return readOnlyLabel;
    
    NSTextField *readOnlyLabel = [NSTextField wrappingLabelWithString:@"Read Only"];
    readOnlyLabel.selectable = NO;
    
    _readOnlyLabel = [readOnlyLabel retain];
    return readOnlyLabel;
}

- (NSSwitch *)_readOnlySwitch {
    if (auto readOnlySwitch = _readOnlySwitch) return readOnlySwitch;
    
    NSSwitch *readOnlySwitch = [NSSwitch new];
    
    _readOnlySwitch = readOnlySwitch;
    return readOnlySwitch;
}

- (NSTextField *)_validationLabel {
    if (auto validationLabel = _validationLabel) return validationLabel;
    
    NSTextField *validationLabel = [NSTextField wrappingLabelWithString:@"Validation"];
    validationLabel.selectable = NO;
    
    _validationLabel = [validationLabel retain];
    return validationLabel;
}

- (NSTextField *)_validationErrorLabel {
    if (auto validationErrorLabel = _validationErrorLabel) return validationErrorLabel;
    
    NSTextField *validationErrorLabel = [NSTextField wrappingLabelWithString:@""];
    validationErrorLabel.selectable = NO;
    
    _validationErrorLabel = [validationErrorLabel retain];
    return validationErrorLabel;
}

- (NSButton *)_canonicalizeButton {
    if (auto canonicalizeButton = _canonicalizeButton) return canonicalizeButton;
    
    NSButton *canonicalizeButton = [NSButton new];
    canonicalizeButton.title = @"Canonicalize";
    canonicalizeButton.target = self;
    canonicalizeButton.action = @selector(_didTriggerCanonicalizeButton:);
    
    _canonicalizeButton = canonicalizeButton;
    return canonicalizeButton;
}

- (void)_didTriggerCanonicalizeButton:(NSButton *)sender {
    NSString * _Nullable string = [VZMultipleDirectoryShare canonicalizedNameFromName:self.nameTextField.stringValue];
    
    if (string != nil) {
        self.nameTextField.stringValue = string;
    }
}

- (void)controlTextDidChange:(NSNotification *)obj {
    [self _didChangeName];
}

- (void)_didChangeName {
    NSError * _Nullable error = nil;
    [VZMultipleDirectoryShare validateName:self.nameTextField.stringValue error:&error];
    
    if (error != nil) {
        self.validationErrorLabel.stringValue = error.description;
    } else {
        self.validationErrorLabel.stringValue = @"Valid";
    }
}

@end
