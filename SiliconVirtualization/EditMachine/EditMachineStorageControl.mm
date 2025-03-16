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
@property (assign, nonatomic, getter=_bytes, setter=_setBytes:) uint64_t bytes;
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
    uint64_t bytes = self.bytes;
    
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
#warning Send Event
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    if ([obj.object isEqual:self.memorySizeTextField]) {
        BOOL adjusted;
        
#warning Send Event
        
        if (adjusted) {
            [self _updateMemorySizeTextField];
        }
    }
}

- (void)_didChangeMemorySizePopUpButtonValue:(NSPopUpButton *)sender {
    [self _updateMemorySizeTextField];
}

@end
