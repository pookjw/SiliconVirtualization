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
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

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

@property (retain, nonatomic, readonly, getter=_macOS_hardwareModelLabel) NSTextField *macOS_hardwareModelLabel;
@property (retain, nonatomic, readonly, getter=_macOS_hardwareModelPlatformVersionLabel) NSTextField *macOS_hardwareModelPlatformVersionLabel;
@property (retain, nonatomic, readonly, getter=_macOS_hardwareModelButton) NSButton *macOS_hardwareModelButton;

@property (retain, nonatomic, readonly, getter=_macOS_auxiliaryStorageLabel) NSTextField *macOS_auxiliaryStorageLabel;
@property (retain, nonatomic, readonly, getter=_macOS_auxiliaryStorageURLLabel) NSTextField *macOS_auxiliaryStorageURLLabel;
@property (retain, nonatomic, readonly, getter=_macOS_auxiliaryStorageMenuButton) NSButton *macOS_auxiliaryStorageMenuButton;
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
@synthesize macOS_auxiliaryStorageLabel = _macOS_auxiliaryStorageLabel;
@synthesize macOS_auxiliaryStorageURLLabel = _macOS_auxiliaryStorageURLLabel;
@synthesize macOS_auxiliaryStorageMenuButton = _macOS_auxiliaryStorageMenuButton;
@synthesize macOS_hardwareModelLabel = _macOS_hardwareModelLabel;
@synthesize macOS_hardwareModelPlatformVersionLabel = _macOS_hardwareModelPlatformVersionLabel;
@synthesize macOS_hardwareModelButton = _macOS_hardwareModelButton;

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
    [_macOS_auxiliaryStorageLabel release];
    [_macOS_auxiliaryStorageURLLabel release];
    [_macOS_auxiliaryStorageMenuButton release];
    [_macOS_hardwareModelLabel release];
    [_macOS_hardwareModelPlatformVersionLabel release];
    [_macOS_hardwareModelButton release];
    
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
    
    [self _didChangeConfiguration];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    VZVirtualMachineConfiguration *configuration = self.configuration;
    
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

- (NSTextField *)_macOS_hardwareModelLabel {
    if (auto macOS_hardwareModelLabel = _macOS_hardwareModelLabel) return macOS_hardwareModelLabel;
    
    NSTextField *macOS_hardwareModelLabel = [NSTextField wrappingLabelWithString:@"Hardware Model"];
    macOS_hardwareModelLabel.selectable = NO;
    
    _macOS_hardwareModelLabel = [macOS_hardwareModelLabel retain];
    return macOS_hardwareModelLabel;
}

- (NSTextField *)_macOS_hardwareModelPlatformVersionLabel {
    if (auto macOS_hardwareModelPlatformVersionLabel = _macOS_hardwareModelPlatformVersionLabel) return macOS_hardwareModelPlatformVersionLabel;
    
    NSTextField *macOS_hardwareModelPlatformVersionLabel = [NSTextField wrappingLabelWithString:@"(null)"];
    macOS_hardwareModelPlatformVersionLabel.selectable = NO;
    
    _macOS_hardwareModelPlatformVersionLabel = [macOS_hardwareModelPlatformVersionLabel retain];
    return macOS_hardwareModelPlatformVersionLabel;
}

- (NSButton *)_macOS_hardwareModelButton {
    if (auto macOS_hardwareModelButton = _macOS_hardwareModelButton) return macOS_hardwareModelButton;
    
    NSButton *macOS_hardwareModelButton = [NSButton new];
    macOS_hardwareModelButton.title = @"Open IPSW";
    macOS_hardwareModelButton.target = self;
    macOS_hardwareModelButton.action = @selector(_macOS_didTriggerHardwareModelButton:);
    
    _macOS_hardwareModelButton = macOS_hardwareModelButton;
    return macOS_hardwareModelButton;
}

- (void)_macOS_didTriggerHardwareModelButton:(NSButton *)sender {
    NSOpenPanel *openPanel = [NSOpenPanel new];
    openPanel.canChooseFiles = YES;
    openPanel.canChooseDirectories = NO;
    openPanel.resolvesAliases = YES;
    openPanel.allowsMultipleSelection = NO;
    openPanel.allowedContentTypes = @[[UTType typeWithIdentifier:@"com.apple.itunes.ipsw"]];
    
#warning TODO Indicator
    
    [openPanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = openPanel.URL) {
            [VZMacOSRestoreImage loadFileURL:URL completionHandler:^(VZMacOSRestoreImage * _Nullable restoreImage, NSError * _Nullable error) {
                assert(error == nil);
                
                VZMacOSConfigurationRequirements *mostFeaturefulSupportedConfiguration = restoreImage.mostFeaturefulSupportedConfiguration;
                assert(mostFeaturefulSupportedConfiguration != nil);
                VZMacHardwareModel *hardwareModel = mostFeaturefulSupportedConfiguration.hardwareModel;
                assert(hardwareModel.supported);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
                    auto platformConfiguration = static_cast<VZMacPlatformConfiguration *>(configuration.platform);
                    assert([platformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]);
                    
                    platformConfiguration.hardwareModel = hardwareModel;
                    
                    configuration.platform = platformConfiguration;
                    self.configuration = configuration;
                    
                    if (auto delegate = self.delegate) {
                        [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
                    }
                    
                    [configuration release];
                });
            }];
        }
    }];
    
    [openPanel release];
}

- (NSTextField *)_macOS_auxiliaryStorageLabel {
    if (auto macOS_auxiliaryStorageLabel = _macOS_auxiliaryStorageLabel) return macOS_auxiliaryStorageLabel;
    
    NSTextField *macOS_auxiliaryStorageLabel = [NSTextField wrappingLabelWithString:@"Auxiliary Storage"];
    macOS_auxiliaryStorageLabel.selectable = NO;
    
    _macOS_auxiliaryStorageLabel = [macOS_auxiliaryStorageLabel retain];
    return macOS_auxiliaryStorageLabel;
}

- (NSTextField *)_macOS_auxiliaryStorageURLLabel {
    if (auto macOS_auxiliaryStorageURLLabel = _macOS_auxiliaryStorageURLLabel) return macOS_auxiliaryStorageURLLabel;
    
    NSTextField *macOS_auxiliaryStorageURLLabel = [NSTextField wrappingLabelWithString:@"(null)"];
    
    _macOS_auxiliaryStorageURLLabel = [macOS_auxiliaryStorageURLLabel retain];
    return macOS_auxiliaryStorageURLLabel;
}

- (NSButton *)_macOS_auxiliaryStorageMenuButton {
    if (auto macOS_auxiliaryStorageMenuButton = _macOS_auxiliaryStorageMenuButton) return macOS_auxiliaryStorageMenuButton;
    
    NSButton *macOS_auxiliaryStorageMenuButton = [NSButton new];
    
    macOS_auxiliaryStorageMenuButton.target = self;
    macOS_auxiliaryStorageMenuButton.action = @selector(_macOS_didTriggerAuxiliaryStorageMenuButton:);
    
    _macOS_auxiliaryStorageMenuButton = macOS_auxiliaryStorageMenuButton;
    return macOS_auxiliaryStorageMenuButton;
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

- (void)_macOS_didTriggerAuxiliaryStorageMenuButton:(NSButton *)sender {
    NSMenu *menu = [NSMenu new];
    
    NSMenuItem *addExistingItem = [NSMenuItem new];
    addExistingItem.title = @"Add Existing...";
    addExistingItem.target = self;
    addExistingItem.action = @selector(_macOS_didTriggerAddExistinguxiliaryStorageItem:);
    [menu addItem:addExistingItem];
    [addExistingItem release];
    
    NSMenuItem *createNewItem = [NSMenuItem new];
    createNewItem.title = @"Create new...";
    createNewItem.target = self;
    createNewItem.action = @selector(_macOS_didTriggerCreateNewAuxiliaryStorageItem:);
    [menu addItem:createNewItem];
    [createNewItem release];
    
    [NSMenu popUpContextMenu:menu withEvent:sender.window.currentEvent forView:sender];
    [menu release];
}

- (void)_macOS_didTriggerAddExistinguxiliaryStorageItem:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel new];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.resolvesAliases = YES;
    panel.allowsMultipleSelection = NO;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            VZVirtualMachineConfiguration *configuration = [self.configuration copy];
            
            auto platformConfiguration = static_cast<VZMacPlatformConfiguration *>(configuration.platform);
            assert([platformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]);
            
            VZMacAuxiliaryStorage *auxiliaryStorage = [[VZMacAuxiliaryStorage alloc] initWithURL:URL];
            platformConfiguration.auxiliaryStorage = auxiliaryStorage;
            [auxiliaryStorage release];
            
            configuration.platform = platformConfiguration;
            self.configuration = configuration;
            
            if (auto delegate = self.delegate) {
                [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
            }
            
            [configuration release];
        }
    }];
    [panel release];
}

- (void)_macOS_didTriggerCreateNewAuxiliaryStorageItem:(NSMenuItem *)sender {
    NSSavePanel *savePanel = [NSSavePanel new];
    
    [savePanel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = savePanel.URL) {
            VZVirtualMachineConfiguration *configuration = [self.configuration copy];
            auto platformConfiguration = static_cast<VZMacPlatformConfiguration *>(configuration.platform);
            assert([platformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]);
            
            NSError * _Nullable error = nil;
            VZMacAuxiliaryStorage *auxiliaryStorage = [[VZMacAuxiliaryStorage alloc] initCreatingStorageAtURL:URL hardwareModel:platformConfiguration.hardwareModel options:VZMacAuxiliaryStorageInitializationOptionAllowOverwrite error:&error];
            assert(error == nil);
            
            platformConfiguration.auxiliaryStorage = auxiliaryStorage;
            [auxiliaryStorage release];
            
            configuration.platform = platformConfiguration;
            self.configuration = configuration;
            
            if (auto delegate = self.delegate) {
                [delegate editMachinePlatformViewController:self didUpdateConfiguration:configuration];
            }
            
            [configuration release];
        }
    }];
    
    [savePanel release];
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
    
    [gridView addRowWithViews:@[
        self.macOS_machineIdentifierLabel,
        self.macOS_machineIdentifierECIDLabel,
        self.macOS_regenerateMachineIdentifierButton
    ]];
    
    [gridView addRowWithViews:@[
        self.macOS_hardwareModelLabel,
        self.macOS_hardwareModelPlatformVersionLabel,
        self.macOS_hardwareModelButton
    ]];
    
    [gridView addRowWithViews:@[
        self.macOS_auxiliaryStorageLabel,
        self.macOS_auxiliaryStorageURLLabel,
        self.macOS_auxiliaryStorageMenuButton
    ]];
    
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
    
    {
        NSData *dataRepresentation = platformConfiguration.hardwareModel.dataRepresentation;
        NSError * _Nullable error = nil;
        NSDictionary<NSString *, id> *dic = [NSPropertyListSerialization propertyListWithData:dataRepresentation options:0 format:NULL error:&error];
        assert(error == nil);
        
        auto platformVersionNumber = static_cast<NSNumber *>(dic[@"PlatformVersion"]);
        
        if (platformVersionNumber != nil) {
            self.macOS_hardwareModelPlatformVersionLabel.stringValue = platformVersionNumber.stringValue;
        } else {
            self.macOS_hardwareModelPlatformVersionLabel.stringValue = @"(null)";
        }
    }
    
    {
        NSURL * _Nullable URL = platformConfiguration.auxiliaryStorage.URL;
        
        if (URL != nil) {
            self.macOS_auxiliaryStorageURLLabel.stringValue = URL.path;
        } else {
            self.macOS_auxiliaryStorageURLLabel.stringValue = @"(null)";
        }
    }
    
    //
    
//    {
//        NSData *dataRepresentation = platformConfiguration.hardwareModel.dataRepresentation;
//        NSError * _Nullable error = nil;
//        NSDictionary<NSString *, NSData *> *dictionary = [NSPropertyListSerialization propertyListWithData:dataRepresentation options:0 format:0 error:&error];
//        assert(error == nil);
//        NSLog(@"%@", dictionary);
//    }
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
