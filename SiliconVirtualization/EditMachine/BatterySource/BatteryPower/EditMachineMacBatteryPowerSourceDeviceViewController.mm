//
//  EditMachineMacBatteryPowerSourceDeviceViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineMacBatteryPowerSourceDeviceViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineMacBatteryPowerSourceDeviceViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_sourceLabel) NSTextField *sourceLabel;
@property (retain, nonatomic, readonly, getter=_sourcePopUpButton) NSPopUpButton *sourcePopUpButton;

@property (retain, nonatomic, readonly, getter=_chargeLabel) NSTextField *chargeLabel;
@property (retain, nonatomic, readonly, getter=_chargeValueLabel) NSTextField *chargeValueLabel;
@property (retain, nonatomic, readonly, getter=_chargeSlider) NSSlider *chargeSlider;

@property (retain, nonatomic, readonly, getter=_connectivityLabel) NSTextField *connectivityLabel;
@property (retain, nonatomic, readonly, getter=_connectivityPopUpButton) NSPopUpButton *connectivityPopUpButton;
@end

@implementation EditMachineMacBatteryPowerSourceDeviceViewController
@synthesize gridView = _gridView;
@synthesize sourceLabel = _sourceLabel;
@synthesize sourcePopUpButton = _sourcePopUpButton;
@synthesize chargeLabel = _chargeLabel;
@synthesize chargeValueLabel = _chargeValueLabel;
@synthesize chargeSlider = _chargeSlider;
@synthesize connectivityLabel = _connectivityLabel;
@synthesize connectivityPopUpButton = _connectivityPopUpButton;

- (void)dealloc {
    [_powerSourceDevice release];
    [_gridView release];
    [_sourceLabel release];
    [_sourcePopUpButton release];
    [_chargeLabel release];
    [_chargeValueLabel release];
    [_chargeSlider release];
    [_connectivityLabel release];
    [_connectivityPopUpButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor]
    ]];
    
    [self _didChangePowerSourceDevice];
}

- (void)setPowerSourceDevice:(id)powerSourceDevice {
    [_powerSourceDevice release];
    _powerSourceDevice = [powerSourceDevice copy];
    
    [self _didChangePowerSourceDevice];
}

- (void)_didChangePowerSourceDevice {
    id powerSourceDevice = self.powerSourceDevice;
    if (powerSourceDevice == nil) {
        self.gridView.hidden = YES;
        return;
    } else {
        self.gridView.hidden = NO;
    }
    
    assert([powerSourceDevice isKindOfClass:objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration")]);
    id _Nullable source = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(powerSourceDevice, sel_registerName("source"));
    
    if (source == nil) {
        [self.sourcePopUpButton selectItemWithTitle:@"(None)"];
        [self.gridView rowAtIndex:1].hidden = YES;
        [self.gridView rowAtIndex:2].hidden = YES;
    } else if ([source isKindOfClass:objc_lookUpClass("_VZMacHostBatterySource")]) {
        [self.sourcePopUpButton selectItemWithTitle:@"Host Battery"];
        [self.gridView rowAtIndex:1].hidden = YES;
        [self.gridView rowAtIndex:2].hidden = YES;
    } else if ([source isKindOfClass:objc_lookUpClass("_VZMacSyntheticBatterySource")]) {
        [self.sourcePopUpButton selectItemWithTitle:@"Synthetic Battery"];
        [self.gridView rowAtIndex:1].hidden = NO;
        [self.gridView rowAtIndex:2].hidden = NO;
        
        double charge = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(source, sel_registerName("charge"));
        NSInteger connectivity = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(source, sel_registerName("connectivity"));
        
        self.chargeValueLabel.stringValue = @(charge).stringValue;
        self.chargeSlider.doubleValue = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(source, sel_registerName("charge"));
        [self.connectivityPopUpButton selectItemWithTitle:@(connectivity).stringValue];
    } else {
        abort();
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    [gridView addRowWithViews:@[self.sourceLabel, self.sourcePopUpButton]];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.chargeLabel, self.chargeValueLabel, self.chargeSlider]];
        [row cellAtIndex:2].customPlacementConstraints = @[
            [self.chargeSlider.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    [gridView addRowWithViews:@[self.connectivityLabel, self.connectivityPopUpButton]];
    
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
        @"(None)", @"Host Battery", @"Synthetic Battery"
    ]];
    
    sourcePopUpButton.target = self;
    sourcePopUpButton.action = @selector(_didTriggerSourcePopUpButton:);
    
    _sourcePopUpButton = sourcePopUpButton;
    return sourcePopUpButton;
}

- (NSTextField *)_chargeLabel {
    if (auto chargeLabel = _chargeLabel) return chargeLabel;
    
    NSTextField *chargeLabel = [NSTextField wrappingLabelWithString:@"Charge"];
    chargeLabel.selectable = NO;
    
    _chargeLabel = [chargeLabel retain];
    return chargeLabel;
}

- (NSTextField *)_chargeValueLabel {
    if (auto chargeValueLabel = _chargeValueLabel) return chargeValueLabel;
    
    NSTextField *chargeValueLabel = [NSTextField wrappingLabelWithString:@""];
    chargeValueLabel.selectable = NO;
    
    _chargeValueLabel = [chargeValueLabel retain];
    return chargeValueLabel;
}

- (NSSlider *)_chargeSlider {
    if (auto chargeSlider = _chargeSlider) return chargeSlider;
    
    NSSlider *chargeSlider = [NSSlider new];
    chargeSlider.minValue = 0.;
    chargeSlider.maxValue = 100.;
    chargeSlider.continuous = NO;
    chargeSlider.target = self;
    chargeSlider.action = @selector(_didTriggerChargeSlider:);
    
    _chargeSlider = chargeSlider;
    return chargeSlider;
}

- (NSTextField *)_connectivityLabel {
    if (auto connectivityLabel = _connectivityLabel) return connectivityLabel;
    
    NSTextField *connectivityLabel = [NSTextField wrappingLabelWithString:@"Connectivity"];
    connectivityLabel.selectable = NO;
    
    _connectivityLabel = [connectivityLabel retain];
    return connectivityLabel;
}

- (NSPopUpButton *)_connectivityPopUpButton {
    if (auto connectivityPopUpButton = _connectivityPopUpButton) return connectivityPopUpButton;
    
    NSPopUpButton *connectivityPopUpButton = [NSPopUpButton new];
    [connectivityPopUpButton addItemsWithTitles:@[@"0", @"1", @"2", @"3", @"4", @"5"]];
    connectivityPopUpButton.target = self;
    connectivityPopUpButton.action = @selector(_didTriggerConnectivityPopUpButton:);
    
    _connectivityPopUpButton = connectivityPopUpButton;
    return connectivityPopUpButton;
}

- (void)_didTriggerSourcePopUpButton:(NSPopUpButton *)sender {
    id _Nullable source;
    if ([sender.titleOfSelectedItem isEqualToString:@"(None)"]) {
        source = nil;
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Host Battery"]) {
        source = [objc_lookUpClass("_VZMacHostBatterySource") new];
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Synthetic Battery"]) {
        source = [objc_lookUpClass("_VZMacSyntheticBatterySource") new];
    } else {
        abort();
    }
    
    id powerSourceDevice = [self.powerSourceDevice copy];
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(powerSourceDevice, sel_registerName("setSource:"), source);
    [source release];
    
    self.powerSourceDevice = powerSourceDevice;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacBatteryPowerSourceDeviceViewController:self didUpdatePowerSourceDevice:powerSourceDevice];
    }
    
    [powerSourceDevice release];
}

- (void)_didTriggerChargeSlider:(NSSlider *)sender {
    id powerSourceDevice = [self.powerSourceDevice copy];
    
    id source = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(powerSourceDevice, sel_registerName("source"));
    assert([source isKindOfClass:objc_lookUpClass("_VZMacSyntheticBatterySource")]);
    
    reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(source, sel_registerName("setCharge:"), sender.doubleValue);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(powerSourceDevice, sel_registerName("setSource:"), source);
    
    self.powerSourceDevice = powerSourceDevice;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacBatteryPowerSourceDeviceViewController:self didUpdatePowerSourceDevice:powerSourceDevice];
    }
    
    [powerSourceDevice release];
}

- (void)_didTriggerConnectivityPopUpButton:(NSPopUpButton *)sender {
    id powerSourceDevice = [self.powerSourceDevice copy];
    
    id source = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(powerSourceDevice, sel_registerName("source"));
    assert([source isKindOfClass:objc_lookUpClass("_VZMacSyntheticBatterySource")]);
    
    reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(source, sel_registerName("setConnectivity:"), sender.titleOfSelectedItem.integerValue);
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(powerSourceDevice, sel_registerName("setSource:"), source);
    
    self.powerSourceDevice = powerSourceDevice;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacBatteryPowerSourceDeviceViewController:self didUpdatePowerSourceDevice:powerSourceDevice];
    }
    
    [powerSourceDevice release];
}

@end
