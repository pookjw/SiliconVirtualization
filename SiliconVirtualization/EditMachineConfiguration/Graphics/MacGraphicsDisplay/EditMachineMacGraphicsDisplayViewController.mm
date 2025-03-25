//
//  EditMachineMacGraphicsDisplayViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineMacGraphicsDisplayViewController.h"
#import "EditMachineNumberTextField.h"

@interface EditMachineMacGraphicsDisplayViewController () <NSTextFieldDelegate>
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_heightInPixelsLabel) NSTextField *heightInPixelsLabel;
@property (retain, nonatomic, readonly, getter=_heightInPixelsTextField) EditMachineNumberTextField *heightInPixelsTextField;

@property (retain, nonatomic, readonly, getter=_widthInPixelsLabel) NSTextField *widthInPixelsLabel;
@property (retain, nonatomic, readonly, getter=_widthInPixelsTextField) EditMachineNumberTextField *widthInPixelsTextField;

@property (retain, nonatomic, readonly, getter=_pixelsPerInchLabel) NSTextField *pixelsPerInchLabel;
@property (retain, nonatomic, readonly, getter=_pixelsPerInchTextField) EditMachineNumberTextField *pixelsPerInchTextField;
@end

@implementation EditMachineMacGraphicsDisplayViewController
@synthesize gridView = _gridView;
@synthesize heightInPixelsLabel = _heightInPixelsLabel;
@synthesize heightInPixelsTextField = _heightInPixelsTextField;
@synthesize widthInPixelsLabel = _widthInPixelsLabel;
@synthesize widthInPixelsTextField = _widthInPixelsTextField;
@synthesize pixelsPerInchLabel = _pixelsPerInchLabel;
@synthesize pixelsPerInchTextField = _pixelsPerInchTextField;

- (void)dealloc {
    [_configuration release];
    [_gridView release];
    [_heightInPixelsLabel release];
    [_heightInPixelsTextField release];
    [_widthInPixelsLabel release];
    [_widthInPixelsTextField release];
    [_pixelsPerInchLabel release];
    [_pixelsPerInchTextField release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSGridView *gridView = self.gridView;
    gridView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:gridView];
    [NSLayoutConstraint activateConstraints:@[
        [gridView.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [gridView.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor],
        [gridView.topAnchor constraintGreaterThanOrEqualToAnchor:self.view.layoutMarginsGuide.topAnchor],
        [gridView.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.view.layoutMarginsGuide.leadingAnchor],
        [gridView.trailingAnchor constraintLessThanOrEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [gridView.bottomAnchor constraintLessThanOrEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (void)setConfiguration:(VZMacGraphicsDisplayConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _updateTextFields];
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView gridViewWithViews:@[
        @[self.heightInPixelsLabel, self.heightInPixelsTextField],
        @[self.widthInPixelsLabel, self.widthInPixelsTextField],
        @[self.pixelsPerInchLabel, self.pixelsPerInchTextField]
    ]];
    
    [gridView cellAtColumnIndex:0 rowIndex:0].xPlacement = NSGridCellPlacementTrailing;
    [gridView cellAtColumnIndex:0 rowIndex:1].xPlacement = NSGridCellPlacementTrailing;
    [gridView cellAtColumnIndex:0 rowIndex:2].xPlacement = NSGridCellPlacementTrailing;
    
    [gridView cellAtColumnIndex:1 rowIndex:0].customPlacementConstraints = @[
        [self.widthInPixelsTextField.widthAnchor constraintEqualToConstant:100.]
    ];
    [gridView cellAtColumnIndex:1 rowIndex:1].customPlacementConstraints = @[
        [self.heightInPixelsTextField.widthAnchor constraintEqualToConstant:100.]
    ];
    [gridView cellAtColumnIndex:1 rowIndex:2].customPlacementConstraints = @[
        [self.pixelsPerInchTextField.widthAnchor constraintEqualToConstant:100.]
    ];
    
    _gridView = [gridView retain];
    return gridView;
}

- (NSTextField *)_heightInPixelsLabel {
    if (auto heightInPixelsLabel = _heightInPixelsLabel) return heightInPixelsLabel;
    
    NSTextField *heightInPixelsLabel = [NSTextField wrappingLabelWithString:@"Height In Pixels"];
    
    _heightInPixelsLabel = [heightInPixelsLabel retain];
    return heightInPixelsLabel;
}

- (EditMachineNumberTextField *)_heightInPixelsTextField {
    if (auto heightInPixelsTextField = _heightInPixelsTextField) return heightInPixelsTextField;
    
    EditMachineNumberTextField *heightInPixelsTextField = [EditMachineNumberTextField new];
    heightInPixelsTextField.delegate = self;
    
    _heightInPixelsTextField = heightInPixelsTextField;
    return heightInPixelsTextField;
}

- (NSTextField *)_widthInPixelsLabel {
    if (auto widthInPixelsLabel = _widthInPixelsLabel) return widthInPixelsLabel;
    
    NSTextField *widthInPixelsLabel = [NSTextField wrappingLabelWithString:@"Width In Pixels"];
    
    _widthInPixelsLabel = [widthInPixelsLabel retain];
    return widthInPixelsLabel;
}

- (EditMachineNumberTextField *)_widthInPixelsTextField {
    if (auto widthInPixelsTextField = _widthInPixelsTextField) return widthInPixelsTextField;
    
    EditMachineNumberTextField *widthInPixelsTextField = [EditMachineNumberTextField new];
    widthInPixelsTextField.delegate = self;
    
    _widthInPixelsTextField = widthInPixelsTextField;
    return widthInPixelsTextField;
}

- (NSTextField *)_pixelsPerInchLabel {
    if (auto pixelsPerInchLabel = _pixelsPerInchLabel) return pixelsPerInchLabel;
    
    NSTextField *pixelsPerInchLabel = [NSTextField wrappingLabelWithString:@"Pixels Per Inch"];
    
    _pixelsPerInchLabel = [pixelsPerInchLabel retain];
    return pixelsPerInchLabel;
}

- (EditMachineNumberTextField *)_pixelsPerInchTextField {
    if (auto pixelsPerInchTextField = _pixelsPerInchTextField) return pixelsPerInchTextField;
    
    EditMachineNumberTextField *pixelsPerInchTextField = [EditMachineNumberTextField new];
    pixelsPerInchTextField.delegate = self;
    
    _pixelsPerInchTextField = pixelsPerInchTextField;
    return pixelsPerInchTextField;
}

- (void)_updateTextFields {
    VZMacGraphicsDisplayConfiguration * _Nullable configuration = self.configuration;
    
    if (configuration != nil) {
        self.heightInPixelsTextField.hidden = NO;
        self.widthInPixelsTextField.hidden = NO;
        self.pixelsPerInchTextField.hidden = NO;
        
        self.heightInPixelsTextField.stringValue = @(configuration.heightInPixels).stringValue;
        self.widthInPixelsTextField.stringValue = @(configuration.widthInPixels).stringValue;
        self.pixelsPerInchTextField.stringValue = @(configuration.pixelsPerInch).stringValue;
    } else {
        self.heightInPixelsTextField.hidden = YES;
        self.widthInPixelsTextField.hidden = YES;
        self.pixelsPerInchTextField.hidden = YES;
    }
}

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    VZMacGraphicsDisplayConfiguration *configuration = [self.configuration copy];
    assert(configuration != nil);
    
    if ([self.heightInPixelsTextField isEqual:obj.object]) {
        configuration.heightInPixels = self.heightInPixelsTextField.stringValue.integerValue;
    } else if ([self.widthInPixelsTextField isEqual:obj.object]) {
        configuration.widthInPixels = self.widthInPixelsTextField.stringValue.integerValue;
    } else if ([self.pixelsPerInchTextField isEqual:obj.object]) {
        configuration.pixelsPerInch = self.pixelsPerInchTextField.stringValue.integerValue;
    } else {
        abort();
    }
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacGraphicsDisplayViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

@end
