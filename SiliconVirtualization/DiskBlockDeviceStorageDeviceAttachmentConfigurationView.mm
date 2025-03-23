//
//  DiskBlockDeviceStorageDeviceAttachmentConfigurationView.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "DiskBlockDeviceStorageDeviceAttachmentConfigurationView.h"
#import "NSStringFromVZDiskSynchronizationMode.h"
#include <ranges>
#include <vector>

@interface DiskBlockDeviceStorageDeviceAttachmentConfigurationView ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_fileDescriptorLabel) NSTextField *fileDescriptorLabel;
@property (retain, nonatomic, readonly, getter=_fileDescriptorTextField) NSTextField *fileDescriptorTextField;

@property (retain, nonatomic, readonly, getter=_readOnlyLabel) NSTextField *readOnlyLabel;
@property (retain, nonatomic, readonly, getter=_readOnlySwitch) NSSwitch *readOnlySwitch;

@property (retain, nonatomic, readonly, getter=_synchronizationModeLabel) NSTextField *synchronizationModeLabel;
@property (retain, nonatomic, readonly, getter=_synchronizationModePopUpButton) NSPopUpButton *synchronizationModePopUpButton;
@end

@implementation DiskBlockDeviceStorageDeviceAttachmentConfigurationView
@synthesize gridView = _gridView;
@synthesize fileDescriptorLabel = _fileDescriptorLabel;
@synthesize fileDescriptorTextField = _fileDescriptorTextField;
@synthesize readOnlyLabel = _readOnlyLabel;
@synthesize readOnlySwitch = _readOnlySwitch;
@synthesize synchronizationModeLabel = _synchronizationModeLabel;
@synthesize synchronizationModePopUpButton = _synchronizationModePopUpButton;

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self _commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    if (self = [super initWithCoder:coder]) {
        [self _commonInit];
    }
    
    return self;
}

- (void)_commonInit {
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.topAnchor constraintEqualToAnchor:self.topAnchor],
        [gridView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor],
        [gridView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
        [gridView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]
    ]];
}

- (void)dealloc {
    [_gridView release];
    [_fileDescriptorLabel release];
    [_fileDescriptorTextField release];
    [_readOnlyLabel release];
    [_readOnlySwitch release];
    [_synchronizationModeLabel release];
    [_synchronizationModePopUpButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.gridView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.gridView.intrinsicContentSize;
}

- (int)fileDescriptor {
    return self.fileDescriptorTextField.stringValue.intValue;
}

- (void)setFileDescriptor:(int)fileDescriptor {
    self.fileDescriptorTextField.stringValue = @(fileDescriptor).stringValue;
}

- (BOOL)readOnly {
    return (self.readOnlySwitch.state == NSControlStateValueOn);
}

- (void)setReadOnly:(BOOL)readOnly {
    self.readOnlySwitch.state = (readOnly ? NSControlStateValueOn : NSControlStateValueOff);
}

- (VZDiskSynchronizationMode)synchronizationMode {
    return VZDiskSynchronizationModeFromString(self.synchronizationModePopUpButton.titleOfSelectedItem);
}

- (void)setSynchronizationMode:(VZDiskSynchronizationMode)synchronizationMode {
    [self.synchronizationModePopUpButton selectItemWithTitle:NSStringFromVZDiskSynchronizationMode(synchronizationMode)];
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[
            self.fileDescriptorLabel, self.fileDescriptorTextField
        ]];
        
        [row cellAtIndex:1].customPlacementConstraints = @[
            [self.fileDescriptorTextField.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    [gridView addRowWithViews:@[
        self.readOnlyLabel, self.readOnlySwitch
    ]];
    
    [gridView addRowWithViews:@[
        self.synchronizationModeLabel, self.synchronizationModePopUpButton
    ]];
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_fileDescriptorLabel {
    if (auto fileDescriptorLabel = _fileDescriptorLabel) return fileDescriptorLabel;
    
    NSTextField *fileDescriptorLabel = [NSTextField wrappingLabelWithString:@"File Descriptor"];
    fileDescriptorLabel.selectable = NO;
    
    _fileDescriptorLabel = [fileDescriptorLabel retain];
    return fileDescriptorLabel;
}

- (NSTextField *)_fileDescriptorTextField {
    if (auto fileDescriptorTextField = _fileDescriptorTextField) return fileDescriptorTextField;
    
    NSTextField *fileDescriptorTextField = [NSTextField new];
    
    _fileDescriptorTextField = fileDescriptorTextField;
    return fileDescriptorTextField;
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

- (NSTextField *)_synchronizationModeLabel {
    if (auto synchronizationModeLabel = _synchronizationModeLabel) return synchronizationModeLabel;
    
    NSTextField *synchronizationModeLabel = [NSTextField wrappingLabelWithString:@"Synchronization Mode"];
    synchronizationModeLabel.selectable = NO;
    
    _synchronizationModeLabel = [synchronizationModeLabel retain];
    return synchronizationModeLabel;
}

- (NSPopUpButton *)_synchronizationModePopUpButton {
    if (auto synchronizationModePopUpButton = _synchronizationModePopUpButton) return synchronizationModePopUpButton;
    
    NSPopUpButton *synchronizationModePopUpButton = [NSPopUpButton new];
    
    NSUInteger count;
    const VZDiskSynchronizationMode *modes = allVZDiskSynchronizationModes(&count);
    
    auto titlesVector = std::views::iota(modes, modes + count)
    | std::views::transform([](const VZDiskSynchronizationMode *ptr) {
        return NSStringFromVZDiskSynchronizationMode(*ptr);
    })
    | std::ranges::to<std::vector<NSString *>>();
    
    NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
    [synchronizationModePopUpButton addItemsWithTitles:titles];
    [titles release];
    
    _synchronizationModePopUpButton = synchronizationModePopUpButton;
    return synchronizationModePopUpButton;
}

@end
