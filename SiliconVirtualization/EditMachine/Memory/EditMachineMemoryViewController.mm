//
//  EditMachineMemoryViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineMemoryViewController.h"
#import "EditMachineNumberTextField.h"

@interface EditMachineMemoryViewController () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;
@property (retain, nonatomic, readonly, getter=_memorySizeLabel) NSTextField *memorySizeLabel;
@property (retain, nonatomic, readonly, getter=_memorySizeTextField) EditMachineNumberTextField *memorySizeTextField;
@property (retain, nonatomic, readonly, getter=_memorySizePopUpButton) NSPopUpButton *memorySizePopUpButton;
@end

@implementation EditMachineMemoryViewController
@synthesize gridView = _gridView;
@synthesize memorySizeLabel = _memorySizeLabel;
@synthesize memorySizeTextField = _memorySizeTextField;
@synthesize memorySizePopUpButton = _memorySizePopUpButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_gridView release];
    [_configuration release];
    [_memorySizeLabel release];
    [_memorySizeTextField release];
    [_memorySizePopUpButton release];
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
    
    [self _updateMemorySizeTextField];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _updateMemorySizeTextField];
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    NSGridRow *gridRow = [gridView addRowWithViews:@[self.memorySizeLabel, self.memorySizeTextField, self.memorySizePopUpButton]];
    [gridRow cellAtIndex:1].customPlacementConstraints = @[
        [self.memorySizeTextField.widthAnchor constraintEqualToConstant:100.]
    ];
    
    [gridView columnAtIndex:0].xPlacement = NSGridCellPlacementTrailing;
    [gridView columnAtIndex:1].xPlacement = NSGridCellPlacementLeading;
    
    _gridView = gridView;
    return gridView;
}


- (NSTextField *)_memorySizeLabel {
    if (auto memorySizeLabel = _memorySizeLabel) return memorySizeLabel;
    
    NSTextField *memorySizeLabel = [NSTextField wrappingLabelWithString:@"Memory Size"];
    
    _memorySizeLabel = [memorySizeLabel retain];
    return memorySizeLabel;
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
        NSUnitInformationStorage.gigabytes.symbol
    ]];
    
    [memorySizePopUpButton selectItemWithTitle:NSUnitInformationStorage.megabytes.symbol];
    
    memorySizePopUpButton.target = self;
    memorySizePopUpButton.action = @selector(_didChangeMemorySizePopUpButtonValue:);
    
    _memorySizePopUpButton = memorySizePopUpButton;
    return memorySizePopUpButton;
}

- (void)_updateMemorySizeTextField {
    EditMachineNumberTextField *memorySizeTextField = self.memorySizeTextField;
    uint64_t memorySize = self.configuration.memorySize;
    
    NSString *selectedTitle = self.memorySizePopUpButton.titleOfSelectedItem;
    if ([selectedTitle isEqualToString:NSUnitInformationStorage.megabytes.symbol]) {
        memorySizeTextField.stringValue = @(memorySize / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowsDoubleValue = NO;
    } else if ([selectedTitle isEqualToString:NSUnitInformationStorage.gigabytes.symbol]) {
        memorySizeTextField.stringValue = @(static_cast<double>(memorySize / 1024ull) / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowsDoubleValue = YES;
    } else {
        abort();
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    if ([obj.object isEqual:self.memorySizeTextField]) {
        BOOL adjusted;
        [self _updateMemorySizeConfiguration:&adjusted];
        if (adjusted) {
            [self _updateMemorySizeTextField];
        }
    }
}

- (void)_didChangeMemorySizePopUpButtonValue:(NSPopUpButton *)sender {
    [self _updateMemorySizeTextField];
}

- (void)_updateMemorySizeConfiguration:(BOOL * _Nullable)adjusted {
    NSString *stringValue = self.memorySizeTextField.stringValue;
    
    if (stringValue.length == 0) {
        self.configuration.memorySize = VZVirtualMachineConfiguration.minimumAllowedMemorySize;
        
        if (adjusted != NULL) {
            *adjusted = YES;
        }
        
        [self _notifyDelegate];
        return;
    }
    
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    
    double inputDoubleValue = [numberFormatter numberFromString:stringValue].doubleValue;
    uint64_t memorySize;
    
    NSString *selectedTitle = self.memorySizePopUpButton.titleOfSelectedItem;
    if ([selectedTitle isEqualToString:NSUnitInformationStorage.megabytes.symbol]) {
        memorySize = inputDoubleValue * 1024ull * 1024ull;
    } else if ([selectedTitle isEqualToString:NSUnitInformationStorage.gigabytes.symbol]) {
        memorySize = inputDoubleValue * 1024ull * 1024ull * 1024ull;
    } else {
        abort();
    }
    
    uint64_t possibleMemorySize = MAX(MIN(memorySize, VZVirtualMachineConfiguration.maximumAllowedMemorySize), VZVirtualMachineConfiguration.minimumAllowedMemorySize);
    self.configuration.memorySize = possibleMemorySize;
    
    if (memorySize != possibleMemorySize) {
        if (adjusted != NULL) {
            *adjusted = YES;
        }
    }
    
    [self _notifyDelegate];
}

- (void)_notifyDelegate {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    [delegate editMachineMemoryViewController:self didUpdateConfiguration:self.configuration];
}

@end
