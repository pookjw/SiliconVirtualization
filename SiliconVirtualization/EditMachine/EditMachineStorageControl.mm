//
//  EditMachineStorageControl.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "EditMachineStorageControl.h"
#import "EditMachineNumberTextField.h"

@interface EditMachineStorageControl () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;
@property (retain, nonatomic, readonly, getter=_memorySizeTextField) EditMachineNumberTextField *memorySizeTextField;
@property (retain, nonatomic, readonly, getter=_memorySizePopUpButton) NSPopUpButton *memorySizePopUpButton;
@end

@implementation EditMachineStorageControl
@synthesize stackView = _stackView;
@synthesize memorySizeTextField = _memorySizeTextField;
@synthesize memorySizePopUpButton = _memorySizePopUpButton;

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
    [_memorySizeTextField release];
    [_memorySizePopUpButton release];
    [super dealloc];
}

- (NSSize)fittingSize {
    return self.stackView.fittingSize;
}

- (NSSize)intrinsicContentSize {
    return self.stackView.intrinsicContentSize;
}

- (BOOL)isEnabled {
    return self.memorySizeTextField.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    self.memorySizeTextField.enabled = enabled;
}

- (void)setUnsignedInt64Value:(uint64_t)unsignedInt64Value {
    unsignedInt64Value = MAX(MIN(unsignedInt64Value, self.maxValue), self.minValue);
    _unsignedInt64Value = unsignedInt64Value;
    [self _updateMemorySizeTextField];
}

- (void)setMaxValue:(uint64_t)maxValue {
    _maxValue = maxValue;
    self.unsignedInt64Value = self.unsignedInt64Value;
}

- (void)setMinValue:(uint64_t)minValue {
    _minValue = minValue;
    self.unsignedInt64Value = self.unsignedInt64Value;
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.memorySizeTextField];
    [stackView addArrangedSubview:self.memorySizePopUpButton];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    stackView.alignment = NSLayoutAttributeWidth;
    stackView.distribution = NSStackViewDistributionFillProportionally;
    
    _stackView = stackView;
    return stackView;
}

- (EditMachineNumberTextField *)_memorySizeTextField {
    if (auto memorySizeTextField = _memorySizeTextField) return memorySizeTextField;
    
    EditMachineNumberTextField *memorySizeTextField = [EditMachineNumberTextField new];
    memorySizeTextField.delegate = self;
    memorySizeTextField.allowsDoubleValue = NO;
    
    _memorySizeTextField = memorySizeTextField;
    [self _updateMemorySizeTextField];
    
    return memorySizeTextField;
}

- (NSPopUpButton *)_memorySizePopUpButton {
    if (auto memorySizePopUpButton = _memorySizePopUpButton) return memorySizePopUpButton;
    
    NSPopUpButton *memorySizePopUpButton = [NSPopUpButton new];
    
    [memorySizePopUpButton addItemsWithTitles:@[
        NSUnitInformationStorage.megabytes.symbol,
        NSUnitInformationStorage.gigabytes.symbol,
        NSUnitInformationStorage.terabytes.symbol
    ]];
    
    [memorySizePopUpButton selectItemWithTitle:NSUnitInformationStorage.megabytes.symbol];
    
    memorySizePopUpButton.target = self;
    memorySizePopUpButton.action = @selector(_didChangeMemorySizePopUpButtonValue:);
    
    _memorySizePopUpButton = memorySizePopUpButton;
    return memorySizePopUpButton;
}

- (NSUnitInformationStorage *)selectedUnit {
    NSString *selectedTitle = self.memorySizePopUpButton.titleOfSelectedItem;
    if ([selectedTitle isEqualToString:NSUnitInformationStorage.megabytes.symbol]) {
        return NSUnitInformationStorage.megabytes;
    } else if ([selectedTitle isEqualToString:NSUnitInformationStorage.gigabytes.symbol]) {
        return NSUnitInformationStorage.gigabytes;
    } else if ([selectedTitle isEqualToString:NSUnitInformationStorage.terabytes.symbol]) {
        return NSUnitInformationStorage.terabytes;
    } else {
        abort();
    }
}

- (void)setSelectedUnit:(NSUnitInformationStorage *)selectedUnit {
    [self.memorySizePopUpButton selectItemWithTitle:selectedUnit.symbol];
    [self _updateMemorySizeTextField];
}

- (void)_updateMemorySizeTextField {
    EditMachineNumberTextField *memorySizeTextField = self.memorySizeTextField;
    uint64_t bytes = self.unsignedInt64Value;
    
    // double 변환을 피하기 위해 NSMeasurement를 사용하지 않음
    if ([self.selectedUnit isEqual:NSUnitInformationStorage.megabytes]) {
        memorySizeTextField.stringValue = @(bytes / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowsDoubleValue = NO;
    } else if ([self.selectedUnit isEqual:NSUnitInformationStorage.gigabytes]) {
        memorySizeTextField.stringValue = @(static_cast<double>(bytes / 1024ull) / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowsDoubleValue = YES;
    } else if ([self.selectedUnit isEqual:NSUnitInformationStorage.terabytes]) {
        memorySizeTextField.stringValue = @(static_cast<double>(bytes / 1024ull) / 1024ull / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowsDoubleValue = YES;
    } else {
        abort();
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    if ([obj.object isEqual:self.memorySizeTextField]) {
        NSString *stringValue = self.memorySizeTextField.stringValue;
        
        if (stringValue.length == 0) {
            _unsignedInt64Value = self.minValue;
            return;
        }
        
        uint64_t memorySize;
        
        // double 변환을 피하기 위해 NSMeasurement를 사용하지 않음
        if ([self.selectedUnit isEqual:NSUnitInformationStorage.megabytes]) {
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            memorySize = [numberFormatter numberFromString:self.memorySizeTextField.stringValue].unsignedLongLongValue;
            [numberFormatter release];
        } else if ([self.selectedUnit isEqual:NSUnitInformationStorage.gigabytes]) {
            memorySize = self.memorySizeTextField.stringValue.doubleValue * 1024ull * 1024ull * 1024ull;
        } else if ([self.selectedUnit isEqual:NSUnitInformationStorage.terabytes]) {
            memorySize = self.memorySizeTextField.stringValue.doubleValue * 1024ull * 1024ull * 1024ull * 1024ull;
        } else {
            abort();
        }
        
        uint64_t adjustedSize = MAX(MIN(memorySize, self.maxValue), self.minValue);
        
        _unsignedInt64Value = adjustedSize;
        
        if (adjustedSize != memorySize) {
            [self _updateMemorySizeTextField];
        }
        
        [self sendAction:self.action to:self.target];
    }
}

- (void)_didChangeMemorySizePopUpButtonValue:(NSPopUpButton *)sender {
    [self _updateMemorySizeTextField];
}

@end
