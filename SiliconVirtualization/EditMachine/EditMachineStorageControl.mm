//
//  EditMachineStorageControl.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "EditMachineStorageControl.h"
#import "EditMachineNumberTextField.h"
#import <objc/message.h>
#import <objc/runtime.h>

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

- (double)doubleValue {
    return self.unsignedInt64Value;
}

- (void)setDoubleValue:(double)doubleValue {
    self.unsignedInt64Value = doubleValue;
}

- (float)floatValue {
    return self.unsignedInt64Value;
}

- (void)setFloatValue:(float)floatValue {
    self.unsignedInt64Value = floatValue;
}

- (int)intValue {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
    return self.unsignedInt64Value;
#pragma clang diagnostic pop
}

- (void)setIntValue:(int)intValue {
    self.unsignedInt64Value = intValue;
}

- (NSInteger)integerValue {
    return self.unsignedInt64Value;
}

- (void)setIntegerValue:(NSInteger)integerValue {
    self.unsignedInt64Value = integerValue;
}

- (id)objectValue {
    return @(self.unsignedInt64Value);
}

- (void)setObjectValue:(id)objectValue {
    assert([objectValue isKindOfClass:[NSNumber class]]);
    self.unsignedInt64Value = static_cast<NSNumber *>(objectValue).unsignedLongLongValue;
}

- (NSString *)stringValue {
    return @(self.unsignedInt64Value).stringValue;
}

- (void)setStringValue:(NSString *)stringValue {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    self.unsignedInt64Value = [formatter numberFromString:stringValue].unsignedLongLongValue;
    [formatter release];
}

- (NSAttributedString *)attributedStringValue {
    NSMutableDictionary<NSAttributedStringKey, id> *attributes = [NSMutableDictionary new];
    
    EditMachineNumberTextField *memorySizeTextField = self.memorySizeTextField;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = memorySizeTextField.alignment;
    paragraphStyle.lineBreakMode = memorySizeTextField.lineBreakMode;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    [paragraphStyle release];
    
    if (NSFont *font = memorySizeTextField.font) {
        attributes[NSFontAttributeName] = font;
    }
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.stringValue attributes:attributes];
    [attributes release];
    return [attributedString autorelease];
}

- (void)setAttributedStringValue:(NSAttributedString *)attributedStringValue {
    NSDictionary<NSAttributedStringKey, id> *attributes = [attributedStringValue attributesAtIndex:0 effectiveRange:NULL];
    
    EditMachineNumberTextField *memorySizeTextField = self.memorySizeTextField;
    
    if (NSParagraphStyle *paragraphStyle = attributes[NSParagraphStyleAttributeName]) {
        memorySizeTextField.alignment = paragraphStyle.alignment;
        memorySizeTextField.lineBreakMode = paragraphStyle.lineBreakMode;
    } else {
        memorySizeTextField.alignment = NSTextAlignmentNatural;
        memorySizeTextField.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    memorySizeTextField.font = [attributedStringValue attribute:NSFontAttributeName atIndex:0 effectiveRange:NULL];
    
    self.stringValue = attributedStringValue.string;
}

- (NSTextAlignment)alignment {
    return self.memorySizeTextField.alignment;
}

- (void)setAlignment:(NSTextAlignment)alignment {
    self.memorySizeTextField.alignment = alignment;
}

- (NSFont *)font {
    return self.memorySizeTextField.font;
}

- (void)setFont:(NSFont *)font {
    self.memorySizeTextField.font = font;
}

- (NSLineBreakMode)lineBreakMode {
    return self.memorySizeTextField.lineBreakMode;
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode {
    self.memorySizeTextField.lineBreakMode = lineBreakMode;
}

- (BOOL)abortEditing {
    return [self.memorySizeTextField abortEditing];
}

- (NSText *)currentEditor {
    return [self.memorySizeTextField currentEditor];
}

- (void)validateEditing {
    [self.memorySizeTextField validateEditing];
}

- (void)editWithFrame:(NSRect)rect editor:(NSText *)textObj delegate:(id)delegate event:(NSEvent *)event {
    return [self.memorySizeTextField editWithFrame:rect editor:textObj delegate:delegate event:event];
}

- (void)endEditing:(NSText *)textObj {
    [self.memorySizeTextField endEditing:textObj];
}

- (void)selectWithFrame:(NSRect)rect editor:(NSText *)textObj delegate:(id)delegate start:(NSInteger)selStart length:(NSInteger)selLength {
    return [self.memorySizeTextField selectWithFrame:rect editor:textObj delegate:delegate start:selStart length:selLength];
}

#warning NSControlTextDidBeginEditingNotification...

- (NSControlSize)controlSize {
    return self.memorySizeTextField.controlSize;
}

- (void)setControlSize:(NSControlSize)controlSize {
    self.memorySizeTextField.controlSize = controlSize;
    self.memorySizePopUpButton.controlSize = controlSize;
}

- (NSSize)sizeThatFits:(NSSize)size {
    return self.stackView.intrinsicContentSize;
}

- (void)sizeToFit {
    NSStackView *stackView = self.stackView;
    [stackView setFrameSize:stackView.intrinsicContentSize];
}

- (BOOL)isHighlighted {
    return self.memorySizeTextField.highlighted or self.memorySizePopUpButton.highlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
    self.memorySizeTextField.highlighted = highlighted;
    self.memorySizePopUpButton.highlighted = highlighted;
}

- (void)performClick:(id)sender {
    [self.memorySizeTextField performClick:sender];
}

- (BOOL)refusesFirstResponder {
    return self.memorySizeTextField.refusesFirstResponder;
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
