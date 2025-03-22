//
//  EditMachineNetworkDeviceViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineNetworkDeviceViewController.h"

@interface EditMachineNetworkDeviceViewController () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_MACAddressLabel) NSTextField *MACAddressLabel;
@property (retain, nonatomic, readonly, getter=_MACAddressTextField) NSTextField *MACAddressTextField;
@property (retain, nonatomic, readonly, getter=_MACAddressGenerateRandomAddressButton) NSButton *MACAddressGenerateRandomAddressButton;

@property (retain, nonatomic, readonly, getter=_attachmentLabel) NSTextField *attachmentLabel;
@property (retain, nonatomic, readonly, getter=_attachmentPopUpButton) NSPopUpButton *attachmentPopUpButton;
@end

@implementation EditMachineNetworkDeviceViewController
@synthesize gridView = _gridView;
@synthesize MACAddressLabel = _MACAddressLabel;
@synthesize MACAddressTextField = _MACAddressTextField;
@synthesize MACAddressGenerateRandomAddressButton = _MACAddressGenerateRandomAddressButton;
@synthesize attachmentLabel = _attachmentLabel;
@synthesize attachmentPopUpButton = _attachmentPopUpButton;

- (void)dealloc {
    [_gridView release];
    [_MACAddressLabel release];
    [_MACAddressTextField release];
    [_MACAddressGenerateRandomAddressButton release];
    [_attachmentLabel release];
    [_attachmentPopUpButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
//        [gridView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor],
//        [gridView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor],
//        [gridView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor],
//        [gridView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    [self _didChangeNetworkDevice];
}

- (void)setNetworkDevice:(__kindof VZNetworkDeviceConfiguration *)networkDevice {
    [_networkDevice release];
    _networkDevice = [networkDevice copy];
    
    [self _didChangeNetworkDevice];
}

- (void)_didChangeNetworkDevice {
    __kindof VZNetworkDeviceConfiguration *networkDevice = self.networkDevice;
    
    self.MACAddressTextField.stringValue = networkDevice.MACAddress.string;
    
    __kindof VZNetworkDeviceAttachment * _Nullable attachment = networkDevice.attachment;
    if (attachment == nil) {
        [self.attachmentPopUpButton selectItemWithTitle:@"(None)"];
    } else if ([attachment isKindOfClass:[VZNATNetworkDeviceAttachment class]]) {
        [self.attachmentPopUpButton selectItemWithTitle:@"NAT"];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.MACAddressLabel, self.MACAddressTextField, self.MACAddressGenerateRandomAddressButton]];
        row.yPlacement = NSGridCellPlacementCenter;
        [row cellAtIndex:1].customPlacementConstraints = @[
            [self.MACAddressTextField.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    {
        [gridView addRowWithViews:@[self.attachmentLabel, self.attachmentPopUpButton]];
    }
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_MACAddressLabel {
    if (auto MACAddressLabel = _MACAddressLabel) return MACAddressLabel;
    
    NSTextField *MACAddressLabel = [NSTextField wrappingLabelWithString:@"MAC Address"];
    MACAddressLabel.selectable = NO;
    
    _MACAddressLabel = [MACAddressLabel retain];
    return MACAddressLabel;
}

- (NSTextField *)_MACAddressTextField {
    if (auto MACAddressTextField = _MACAddressTextField) return MACAddressTextField;
    
    NSTextField *MACAddressTextField = [NSTextField new];
    MACAddressTextField.delegate = self;
    
    _MACAddressTextField = MACAddressTextField;
    return MACAddressTextField;
}

- (NSButton *)_MACAddressGenerateRandomAddressButton {
    if (auto MACAddressGenerateRandomAddressButton = _MACAddressGenerateRandomAddressButton) return MACAddressGenerateRandomAddressButton;
    
    NSButton *MACAddressGenerateRandomAddressButton = [NSButton new];
    MACAddressGenerateRandomAddressButton.image = [NSImage imageWithSystemSymbolName:@"shuffle" accessibilityDescription:nil];
    MACAddressGenerateRandomAddressButton.toolTip = @"Generate Random Address";
    MACAddressGenerateRandomAddressButton.target = self;
    MACAddressGenerateRandomAddressButton.action = @selector(_didTriggerMACAddressGenerateRandomAddressButton:);
    
    _MACAddressGenerateRandomAddressButton = MACAddressGenerateRandomAddressButton;
    return MACAddressGenerateRandomAddressButton;
}

- (NSTextField *)_attachmentLabel {
    if (auto attachmentLabel = _attachmentLabel) return attachmentLabel;
    
    NSTextField *attachmentLabel = [NSTextField wrappingLabelWithString:@"Attachment"];
    attachmentLabel.selectable = NO;
    
    _attachmentLabel = [attachmentLabel retain];
    return attachmentLabel;
}

- (NSPopUpButton *)_attachmentPopUpButton {
    if (auto attachmentPopUpButton = _attachmentPopUpButton) return attachmentPopUpButton;
    
    NSPopUpButton *attachmentPopUpButton = [NSPopUpButton new];
    
    attachmentPopUpButton.target = self;
    attachmentPopUpButton.action = @selector(_didTriggerAttachmentPopUpButton:);
    
    [attachmentPopUpButton addItemsWithTitles:@[
        @"(None)",
        @"Bridged",
        @"File Handle",
        @"NAT"
    ]];
    
    _attachmentPopUpButton = attachmentPopUpButton;
    return attachmentPopUpButton;
}

- (void)_didTriggerMACAddressGenerateRandomAddressButton:(NSButton *)sender {
    VZMACAddress *MACAddress = [VZMACAddress randomLocallyAdministeredAddress];
    self.networkDevice.MACAddress = MACAddress;
    [self _notifyDelegate];
}

- (void)_notifyDelegate {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    VZNetworkDeviceConfiguration *networkDevice = [self.networkDevice copy];
    [delegate editMachineNetworkDeviceViewController:self didUpdateNetworkDevice:networkDevice];
    [networkDevice release];
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    if ([self.MACAddressTextField isEqual:obj.object]) {
        VZMACAddress * _Nullable MACAddress = [[VZMACAddress alloc] initWithString:self.MACAddressTextField.stringValue];
        
        if (MACAddress != nil) {
            self.networkDevice.MACAddress = MACAddress;
            [self _notifyDelegate];
        }
        
        [MACAddress release];
    } else {
        abort();
    }
}

- (void)_didTriggerAttachmentPopUpButton:(NSPopUpButton *)sender {
    NSString *titleOfSelectedItem = sender.titleOfSelectedItem;
    
    if ([titleOfSelectedItem isEqualToString:@"(None)"]) {
        [self _updateAttachment:nil];
    } else if ([titleOfSelectedItem isEqualToString:@"NAT"]) {
        VZNATNetworkDeviceAttachment *attachment = [[VZNATNetworkDeviceAttachment alloc] init];
        [self _updateAttachment:attachment];
        [attachment release];
    } else {
        abort();
    }
}

- (void)_updateAttachment:(__kindof VZNetworkDeviceAttachment * _Nullable)attachment {
    self.networkDevice.attachment = attachment;
    
    if (auto delegate = self.delegate) {
        VZNetworkDeviceConfiguration *copy = [self.networkDevice copy];
        [delegate editMachineNetworkDeviceViewController:self didUpdateNetworkDevice:copy];
        [copy release];
    }
}

@end
