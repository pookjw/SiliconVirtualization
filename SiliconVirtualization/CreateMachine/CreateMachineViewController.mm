//
//  CreateMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "CreateMachineViewController.h"
#import <Virtualization/Virtualization.h>
#import "EditMachineViewController.h"

@interface _CreateMachineMemorySizeTextField : NSTextField <NSTextViewDelegate>
@property (assign, nonatomic, getter=isAllowedDoubleValue) BOOL allowedDoubleValue;
@end
@implementation _CreateMachineMemorySizeTextField

- (BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    NSString *oldString = textView.string;
    NSString *newString = [oldString stringByReplacingCharactersInRange:affectedCharRange withString:replacementString];
    
    if (newString.length == 0) return YES;
    
    if (self.allowedDoubleValue) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        BOOL isNumber = [formatter numberFromString:newString] != nil;
        [formatter release];
        return isNumber;
    } else {
        NSCharacterSet *searchSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSString *trimmedString = [newString stringByTrimmingCharactersInSet:searchSet];
        return newString.length == trimmedString.length;
    }
}

@end

@interface CreateMachineViewController () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_CPUCountLabel) NSTextField *CPUCountLabel;
@property (retain, nonatomic, readonly, getter=_CPUCountValueLabel) NSTextField *CPUCountValueLabel;
@property (retain, nonatomic, readonly, getter=_CPUCountStepper) NSStepper *CPUCountStepper;

@property (retain, nonatomic, readonly, getter=_memorySizeLabel) NSTextField *memorySizeLabel;
@property (retain, nonatomic, readonly, getter=_memorySizeTextField) _CreateMachineMemorySizeTextField *memorySizeTextField;
@property (retain, nonatomic, readonly, getter=_memorySizePopUpButton) NSPopUpButton *memorySizePopUpButton;

@property (retain, nonatomic, readonly, getter=_machineConfiguration) VZVirtualMachineConfiguration *machineConfiguration;
@end

@implementation CreateMachineViewController
@synthesize gridView = _gridView;
@synthesize CPUCountLabel = _CPUCountLabel;
@synthesize CPUCountValueLabel = _CPUCountValueLabel;
@synthesize CPUCountStepper = _CPUCountStepper;
@synthesize memorySizeLabel = _memorySizeLabel;
@synthesize memorySizeTextField = _memorySizeTextField;
@synthesize memorySizePopUpButton = _memorySizePopUpButton;
@synthesize machineConfiguration = _machineConfiguration;

- (void)dealloc {
    [_gridView release];
    [_CPUCountLabel release];
    [_CPUCountValueLabel release];
    [_CPUCountStepper release];
    [_memorySizeLabel release];
    [_memorySizeTextField release];
    [_memorySizePopUpButton release];
    [_machineConfiguration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EditMachineViewController *editMachineViewController = [[EditMachineViewController alloc] initWithConfiguration:self.machineConfiguration];
    editMachineViewController.view.frame = self.view.bounds;
    editMachineViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:editMachineViewController.view];
    [self addChildViewController:editMachineViewController];
    [editMachineViewController release];
//    [self.view addSubview:self.gridView];
//    self.gridView.frame = NSMakeRect(0., 0., self.gridView.fittingSize.width, self.gridView.fittingSize.height);
}

//- (NSSize)preferredMinimumSize {
//    return self.gridView.fittingSize;
//}
//
//- (NSSize)preferredMaximumSize {
//    return self.gridView.fittingSize;
//}
//
//- (NSSize)preferredContentSize {
//    return self.gridView.fittingSize;
//}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[self.CPUCountLabel, self.CPUCountValueLabel, self.CPUCountStepper]];
    
    {
        NSGridRow *gridRow = [gridView addRowWithViews:@[self.memorySizeLabel, self.memorySizeTextField, self.memorySizePopUpButton]];
        [gridRow cellAtIndex:1].customPlacementConstraints = @[
            [self.memorySizeTextField.widthAnchor constraintEqualToConstant:100.]
        ];
    }
    
    [gridView columnAtIndex:0].xPlacement = NSGridCellPlacementTrailing;
    [gridView columnAtIndex:1].xPlacement = NSGridCellPlacementLeading;
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_CPUCountLabel {
    if (auto CPUCountLabel = _CPUCountLabel) return CPUCountLabel;
    
    NSTextField *CPUCountLabel = [NSTextField wrappingLabelWithString:@"CPU Count"];
    
    _CPUCountLabel = [CPUCountLabel retain];
    return CPUCountLabel;
}

- (NSTextField *)_CPUCountValueLabel {
    if (auto CPUCountValueLabel = _CPUCountValueLabel) return CPUCountValueLabel;
    
    NSTextField *CPUCountValueLabel = [NSTextField wrappingLabelWithString:@""];
    
    _CPUCountValueLabel = CPUCountValueLabel;
    [self _updateCPUCountStepper];
    
    return CPUCountValueLabel;
}

- (NSStepper *)_CPUCountStepper {
    if (auto CPUCountStepper = _CPUCountStepper) return CPUCountStepper;
    
    NSStepper *CPUCountStepper = [NSStepper new];
    CPUCountStepper.minValue = VZVirtualMachineConfiguration.minimumAllowedCPUCount;
    CPUCountStepper.maxValue = VZVirtualMachineConfiguration.maximumAllowedCPUCount;
    CPUCountStepper.increment = 1.;
    CPUCountStepper.doubleValue = self.machineConfiguration.CPUCount;
    CPUCountStepper.autorepeat = YES;
    CPUCountStepper.continuous = YES;
    CPUCountStepper.valueWraps = NO;
    CPUCountStepper.target = self;
    CPUCountStepper.action = @selector(_didChangeCPUCountStepperValue:);
    
    _CPUCountStepper = CPUCountStepper;
    return CPUCountStepper;
}

- (void)_didChangeCPUCountStepperValue:(NSStepper *)sender {
    self.machineConfiguration.CPUCount = sender.doubleValue;
    [self _updateCPUCountStepper];
}

- (void)_updateCPUCountStepper {
    self.CPUCountValueLabel.stringValue = @(self.machineConfiguration.CPUCount).stringValue;
}

- (NSTextField *)_memorySizeLabel {
    if (auto memorySizeLabel = _memorySizeLabel) return memorySizeLabel;
    
    NSTextField *memorySizeLabel = [NSTextField wrappingLabelWithString:@"Memory Size"];
    
    _memorySizeLabel = [memorySizeLabel retain];
    return memorySizeLabel;
}

- (_CreateMachineMemorySizeTextField *)_memorySizeTextField {
    if (auto memorySizeTextField = _memorySizeTextField) return memorySizeTextField;
    
    _CreateMachineMemorySizeTextField *memorySizeTextField = [_CreateMachineMemorySizeTextField new];
    memorySizeTextField.delegate = self;
    memorySizeTextField.allowedDoubleValue = NO;
    
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

- (void)_didChangeMemorySizePopUpButtonValue:(NSPopUpButton *)sender {
    [self _updateMemorySizeTextField];
}

- (void)_updateMemorySizeTextField {
    _CreateMachineMemorySizeTextField *memorySizeTextField = self.memorySizeTextField;
    uint64_t memorySize = self.machineConfiguration.memorySize;
    
    NSString *selectedTitle = self.memorySizePopUpButton.titleOfSelectedItem;
    if ([selectedTitle isEqualToString:NSUnitInformationStorage.megabytes.symbol]) {
        memorySizeTextField.stringValue = @(memorySize / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowedDoubleValue = NO;
    } else if ([selectedTitle isEqualToString:NSUnitInformationStorage.gigabytes.symbol]) {
        memorySizeTextField.stringValue = @(static_cast<double>(memorySize / 1024ull) / 1024ull / 1024ull).stringValue;
        memorySizeTextField.allowedDoubleValue = YES;
    } else {
        abort();
    }
}

- (VZVirtualMachineConfiguration *)_machineConfiguration {
    if (auto machineConfiguration = _machineConfiguration) return machineConfiguration;
    
    VZVirtualMachineConfiguration *machineConfiguration = [VZVirtualMachineConfiguration new];
    
    _machineConfiguration = machineConfiguration;
    return machineConfiguration;
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

- (void)_updateMemorySizeConfiguration:(BOOL * _Nullable)adjusted {
    NSString *stringValue = self.memorySizeTextField.stringValue;
    
    if (stringValue.length == 0) {
        self.machineConfiguration.memorySize = VZVirtualMachineConfiguration.minimumAllowedMemorySize;
        
        if (adjusted != NULL) {
            *adjusted = YES;
        }
        
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
    self.machineConfiguration.memorySize = possibleMemorySize;
    
    if (memorySize != possibleMemorySize) {
        if (adjusted != NULL) {
            *adjusted = YES;
        }
    }
}

@end
