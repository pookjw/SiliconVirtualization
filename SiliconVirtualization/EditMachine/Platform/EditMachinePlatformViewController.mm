//
//  EditMachinePlatformViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachinePlatformViewController.h"
#include <ranges>
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachinePlatformViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_platformLabel) NSTextField *platformLabel;
@property (retain, nonatomic, readonly, getter=_platformPopUpButton) NSPopUpButton *platformPopUpButton;

@property (retain, nonatomic, readonly, getter=_generic_machineIdentifierLabel) NSTextField *generic_machineIdentifierLabel;
@property (retain, nonatomic, readonly, getter=_generic_machineIdentifierUUIDLabel) NSTextField *generic_machineIdentifierUUIDLabel;
@property (retain, nonatomic, readonly, getter=_generic_regenerateMachineIdentifierButton) NSButton *generic_regenerateMachineIdentifierButton;

@property (retain, nonatomic, readonly, getter=_generic_nestedVirtualizationEnabledLabel) NSTextField *generic_nestedVirtualizationEnabledLabel;
@property (retain, nonatomic, readonly, getter=_generic_nestedVirtualizationEnabledSwitch) NSSwitch *generic_nestedVirtualizationEnabledSwitch;

@property (retain, nonatomic, readonly, getter=_macOS_machineIdentifierLabel) NSTextField *macOS_machineIdentifierLabel;
@property (retain, nonatomic, readonly, getter=_macOS_machineIdentifierECIDLabel) NSTextField *macOS_machineIdentifierECIDLabel;
@property (retain, nonatomic, readonly, getter=_macOS_regenerateMachineIdentifierButton) NSButton *macOS_regenerateMachineIdentifierButton;
@end

@implementation EditMachinePlatformViewController
@synthesize gridView = _gridView;
@synthesize platformLabel = _platformLabel;
@synthesize platformPopUpButton = _platformPopUpButton;
@synthesize generic_machineIdentifierLabel = _generic_machineIdentifierLabel;
@synthesize generic_machineIdentifierUUIDLabel = _generic_machineIdentifierUUIDLabel;
@synthesize generic_regenerateMachineIdentifierButton = _generic_regenerateMachineIdentifierButton;
@synthesize generic_nestedVirtualizationEnabledLabel = _generic_nestedVirtualizationEnabledLabel;
@synthesize generic_nestedVirtualizationEnabledSwitch = _generic_nestedVirtualizationEnabledSwitch;
@synthesize macOS_machineIdentifierLabel = _macOS_machineIdentifierLabel;
@synthesize macOS_machineIdentifierECIDLabel = _macOS_machineIdentifierECIDLabel;
@synthesize macOS_regenerateMachineIdentifierButton = _macOS_regenerateMachineIdentifierButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_gridView release];
    [_platformLabel release];
    [_platformPopUpButton release];
    [_generic_machineIdentifierLabel release];
    [_generic_machineIdentifierUUIDLabel release];
    [_generic_regenerateMachineIdentifierButton release];
    [_generic_nestedVirtualizationEnabledLabel release];
    [_generic_nestedVirtualizationEnabledSwitch release];
    [_macOS_machineIdentifierLabel release];
    [_macOS_machineIdentifierECIDLabel release];
    [_macOS_regenerateMachineIdentifierButton release];
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
        [gridView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.topAnchor],
        [gridView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.leadingAnchor],
        [gridView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.trailingAnchor],
        [gridView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.bottomAnchor]
    ]];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    __kindof VZPlatformConfiguration *platform = configuration.platform;
    if ([platform isKindOfClass:[VZGenericPlatformConfiguration class]]) {
        [self _setupGridViewWithGenericPlatform];
    } else if ([platform isKindOfClass:[VZMacPlatformConfiguration class]]) {
        [self _setupGridViewWithMacOSPlatform];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[self.platformLabel, self.platformPopUpButton]];
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_platformLabel {
    if (auto platformLabel = _platformLabel) return platformLabel;
    
    NSTextField *platformLabel = [NSTextField wrappingLabelWithString:@"Platform"];
    platformLabel.selectable = NO;
    
    _platformLabel = [platformLabel retain];
    return platformLabel;
}

- (NSPopUpButton *)_platformPopUpButton {
    if (auto platformPopUpButton = _platformPopUpButton) return platformPopUpButton;
    
    NSPopUpButton *platformPopUpButton = [NSPopUpButton new];
    
    [platformPopUpButton addItemsWithTitles:@[@"Generic", @"macOS"]];
    platformPopUpButton.target = self;
    platformPopUpButton.action = @selector(_didTriggerPlatformPopUpButton:);
    
    _platformPopUpButton = platformPopUpButton;
    return platformPopUpButton;
}

- (NSTextField *)_generic_machineIdentifierLabel {
    if (auto generic_machineIdentifierLabel = _generic_machineIdentifierLabel) return generic_machineIdentifierLabel;
    
    NSTextField *generic_machineIdentifierLabel = [NSTextField wrappingLabelWithString:@"Machine Identifier"];
    generic_machineIdentifierLabel.selectable = NO;
    
    _generic_machineIdentifierLabel = [generic_machineIdentifierLabel retain];
    return generic_machineIdentifierLabel;
}

- (NSTextField *)_generic_machineIdentifierUUIDLabel {
    if (auto generic_machineIdentifierUUIDLabel = _generic_machineIdentifierUUIDLabel) return generic_machineIdentifierUUIDLabel;
    
    NSTextField *generic_machineIdentifierUUIDLabel = [NSTextField wrappingLabelWithString:@"(nil)"];
    
    _generic_machineIdentifierUUIDLabel = [generic_machineIdentifierUUIDLabel retain];
    return generic_machineIdentifierUUIDLabel;
}

- (NSButton *)_generic_regenerateMachineIdentifierButton {
    if (auto generic_regenerateMachineIdentifierButton = _generic_regenerateMachineIdentifierButton) return generic_regenerateMachineIdentifierButton;
    
    NSButton *generic_regenerateMachineIdentifierButton = [NSButton new];
    generic_regenerateMachineIdentifierButton.title = @"Regenerate";
    generic_regenerateMachineIdentifierButton.target = self;
    generic_regenerateMachineIdentifierButton.action = @selector(_generic_didTriggerRegenerateMachineIdentifierButton:);
    
    _generic_regenerateMachineIdentifierButton = generic_regenerateMachineIdentifierButton;
    return generic_regenerateMachineIdentifierButton;
}

- (NSTextField *)_generic_nestedVirtualizationEnabledLabel {
    if (auto generic_nestedVirtualizationEnabledLabel = _generic_nestedVirtualizationEnabledLabel) return generic_nestedVirtualizationEnabledLabel;
    
    NSTextField *generic_nestedVirtualizationEnabledLabel = [NSTextField wrappingLabelWithString:@"Nested Virtualization Enabled"];
    
    _generic_nestedVirtualizationEnabledLabel = [generic_nestedVirtualizationEnabledLabel retain];
    return generic_nestedVirtualizationEnabledLabel;
}

- (NSSwitch *)_generic_nestedVirtualizationEnabledSwitch {
    if (auto generic_nestedVirtualizationEnabledSwitch = _generic_nestedVirtualizationEnabledSwitch) return generic_nestedVirtualizationEnabledSwitch;
    
    NSSwitch *generic_nestedVirtualizationEnabledSwitch = [NSSwitch new];
    generic_nestedVirtualizationEnabledSwitch.enabled = VZGenericPlatformConfiguration.nestedVirtualizationSupported;
    generic_nestedVirtualizationEnabledSwitch.target = self;
    generic_nestedVirtualizationEnabledSwitch.action = @selector(_didTriggerNestedVirtualizationEnabledSwitch:);
    
    _generic_nestedVirtualizationEnabledSwitch = generic_nestedVirtualizationEnabledSwitch;
    return generic_nestedVirtualizationEnabledSwitch;
}

- (NSTextField *)_macOS_machineIdentifierLabel {
    if (auto macOS_machineIdentifierLabel = _macOS_machineIdentifierLabel) return macOS_machineIdentifierLabel;
    
    NSTextField *macOS_machineIdentifierLabel = [NSTextField wrappingLabelWithString:@"Machine Identifier"];
    macOS_machineIdentifierLabel.selectable = NO;
    
    _macOS_machineIdentifierLabel = [macOS_machineIdentifierLabel retain];
    return macOS_machineIdentifierLabel;
}

- (NSTextField *)_macOS_machineIdentifierECIDLabel {
    if (auto macOS_machineIdentifierECIDLabel = _macOS_machineIdentifierECIDLabel) return macOS_machineIdentifierECIDLabel;
    
    NSTextField *macOS_machineIdentifierECIDLabel = [NSTextField wrappingLabelWithString:@"(null)"];
    macOS_machineIdentifierECIDLabel.selectable = NO;
    
    _macOS_machineIdentifierECIDLabel = [macOS_machineIdentifierECIDLabel retain];
    return macOS_machineIdentifierECIDLabel;
}

- (NSButton *)_macOS_regenerateMachineIdentifierButton {
    if (auto macOS_regenerateMachineIdentifierButton = _macOS_regenerateMachineIdentifierButton) return macOS_regenerateMachineIdentifierButton;
    
    NSButton *macOS_regenerateMachineIdentifierButton = [NSButton new];
    macOS_regenerateMachineIdentifierButton.title = @"Regenerate";
    macOS_regenerateMachineIdentifierButton.target = self;
    macOS_regenerateMachineIdentifierButton.action = @selector(_macOS_didTriggerRegenerateMachineIdentifierButton:);
    
    _macOS_regenerateMachineIdentifierButton = macOS_regenerateMachineIdentifierButton;
    return macOS_regenerateMachineIdentifierButton;
}

- (void)_didTriggerPlatformPopUpButton:(NSPopUpButton *)sender {
    NSString *title = sender.titleOfSelectedItem;
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    if ([title isEqualToString:@"Generic"]) {
        VZGenericPlatformConfiguration *genericPlatformConfiguration = [[VZGenericPlatformConfiguration alloc] init];
        configuration.platform = genericPlatformConfiguration;
        [genericPlatformConfiguration release];
    } else if ([title isEqualToString:@"macOS"]) {
        VZMacPlatformConfiguration *macPlatformConfiguration = [[VZMacPlatformConfiguration alloc] init];
        configuration.platform = macPlatformConfiguration;
        [macPlatformConfiguration release];
    } else {
        abort();
    }
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)_generic_didTriggerRegenerateMachineIdentifierButton:(NSButton *)sender {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    auto genericPlatformConfiguration = static_cast<VZGenericPlatformConfiguration *>(configuration.platform);
    assert([genericPlatformConfiguration isKindOfClass:[VZGenericPlatformConfiguration class]]);
    
//    VZGenericMachineIdentifier *machineIdentifier = [VZGenericMachineIdentifier new];
//    genericPlatformConfiguration.machineIdentifier = machineIdentifier;
//    [machineIdentifier release];
    
    NSUUID *UUID = [NSUUID UUID];
    unsigned char bytes[16];
    [UUID getUUIDBytes:bytes];
    NSDictionary<NSString *, NSData *> *dic = @{
        @"UUID": [NSData dataWithBytes:bytes length:sizeof(bytes)]
    };
    NSError * _Nullable error = nil;
    NSData *dataRepresentation = [NSPropertyListSerialization dataWithPropertyList:dic format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
    assert(error == nil);
    
    VZGenericMachineIdentifier *machineIdentifier = [[VZGenericMachineIdentifier alloc] initWithDataRepresentation:dataRepresentation];
    genericPlatformConfiguration.machineIdentifier = machineIdentifier;
    [machineIdentifier release];
    
    configuration.platform = genericPlatformConfiguration;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)_macOS_didTriggerRegenerateMachineIdentifierButton:(NSButton *)sender {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    auto macPlatformConfiguration = static_cast<VZMacPlatformConfiguration *>(configuration.platform);
    assert([macPlatformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]);
    
    VZMacMachineIdentifier *machineIdentifier = [VZMacMachineIdentifier new];
    macPlatformConfiguration.machineIdentifier = machineIdentifier;
    [machineIdentifier release];
    
    configuration.platform = macPlatformConfiguration;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)_didTriggerNestedVirtualizationEnabledSwitch:(NSSwitch *)sender {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    __kindof VZPlatformConfiguration *platformConfiguration = configuration.platform;
    if ([platformConfiguration isKindOfClass:[VZGenericPlatformConfiguration class]]) {
        auto genericPlatformConfiguration = static_cast<VZGenericPlatformConfiguration *>(configuration.platform);
        genericPlatformConfiguration.nestedVirtualizationEnabled = (sender.state == NSControlStateValueOn);
    } else {
        abort();
    }
    
    configuration.platform = platformConfiguration;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)_setupGridViewWithGenericPlatform {
    [self _removeGridRowsWithoutCommonRows];
    
    NSGridView *gridView = self.gridView;
    [gridView addRowWithViews:@[self.generic_machineIdentifierLabel, self.generic_machineIdentifierUUIDLabel, self.generic_regenerateMachineIdentifierButton]];
    [gridView addRowWithViews:@[self.generic_nestedVirtualizationEnabledLabel, self.generic_nestedVirtualizationEnabledSwitch]];
    
    //
    
    [self.platformPopUpButton selectItemWithTitle:@"Generic"];
    
    //
    
    auto platformConfiguration = static_cast<VZGenericPlatformConfiguration *>(self.configuration.platform);
    assert([platformConfiguration isKindOfClass:[VZGenericPlatformConfiguration class]]);
    
    {
        NSData *dataRepresentation = platformConfiguration.machineIdentifier.dataRepresentation;
        NSError * _Nullable error = nil;
        NSDictionary<NSString *, NSData *> *dictionary = [NSPropertyListSerialization propertyListWithData:dataRepresentation options:0 format:0 error:&error];
        assert(error == nil);
        NSData *UUIDData = dictionary[@"UUID"];
        NSUUID *UUID = [[NSUUID alloc] initWithUUIDBytes:reinterpret_cast<const unsigned char *>(UUIDData.bytes)];
        self.generic_machineIdentifierUUIDLabel.stringValue = UUID.UUIDString;
        [UUID release];
    }
    
    //
    
    self.generic_nestedVirtualizationEnabledSwitch.state = platformConfiguration.nestedVirtualizationEnabled ? NSControlStateValueOn : NSControlStateValueOff;
}

- (void)_setupGridViewWithMacOSPlatform {
    [self _removeGridRowsWithoutCommonRows];
    
    NSGridView *gridView = self.gridView;
    [gridView addRowWithViews:@[self.macOS_machineIdentifierLabel, self.macOS_machineIdentifierECIDLabel, self.macOS_regenerateMachineIdentifierButton]];
    
    //
    
    [self.platformPopUpButton selectItemWithTitle:@"macOS"];
    
    //
    
    auto platformConfiguration = static_cast<VZMacPlatformConfiguration *>(self.configuration.platform);
    assert([platformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]);
    
    {
        NSUInteger ECID = reinterpret_cast<NSUInteger (*)(id, SEL)>(objc_msgSend)(platformConfiguration.machineIdentifier, sel_registerName("_ECID"));
        assert(ECID != 0);
        self.macOS_machineIdentifierECIDLabel.stringValue = @(ECID).stringValue;
    }
    
    //
    
    {
        NSData *dataRepresentation = platformConfiguration.hardwareModel.dataRepresentation;
        NSError * _Nullable error = nil;
        NSDictionary<NSString *, NSData *> *dictionary = [NSPropertyListSerialization propertyListWithData:dataRepresentation options:0 format:0 error:&error];
        assert(error == nil);
        NSLog(@"%@", dictionary);
    }
}

- (void)_removeGridRowsWithoutCommonRows {
    NSGridView *gridView = self.gridView;
    
    NSInteger numberOfRows = gridView.numberOfRows;
    for (NSInteger rowIndex : std::views::iota(1, numberOfRows) | std::views::reverse) {
        NSGridRow *row = [gridView rowAtIndex:rowIndex];
        
        for (NSInteger cellIndex : std::views::iota(0, row.numberOfCells)) {
            NSGridCell *cell = [row cellAtIndex:cellIndex];
            [cell.contentView removeFromSuperview];
        }
        
        [gridView removeRowAtIndex:rowIndex];
    }
}

@end
