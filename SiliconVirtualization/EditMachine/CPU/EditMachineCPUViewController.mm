//
//  EditMachineCPUViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineCPUViewController.h"
#include <ranges>
#include <vector>

@interface EditMachineCPUViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_CPUCountLabel) NSTextField *CPUCountLabel;
@property (retain, nonatomic, readonly, getter=_CPUCountPopUpButton) NSPopUpButton *CPUCountPopUpButton;
@end

@implementation EditMachineCPUViewController
@synthesize gridView = _gridView;
@synthesize CPUCountLabel = _CPUCountLabel;
@synthesize CPUCountPopUpButton = _CPUCountPopUpButton;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_gridView release];
    [_CPUCountLabel release];
    [_CPUCountPopUpButton release];
    [_configuration release];
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

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[self.CPUCountLabel, self.CPUCountPopUpButton]];
    [gridView columnAtIndex:0].xPlacement = NSGridCellPlacementTrailing;
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_CPUCountLabel {
    if (auto CPUCountLabel = _CPUCountLabel) return CPUCountLabel;
    
    NSTextField *CPUCountLabel = [NSTextField wrappingLabelWithString:@"CPU Count"];
    
    _CPUCountLabel = [CPUCountLabel retain];
    return CPUCountLabel;
}

//- (NSSlider *)_CPUCountSlider {
//    if (auto CPUCountSlider = _CPUCountSlider) return CPUCountSlider;
//    
//    NSSlider *CPUCountSlider = [NSSlider new];
//    CPUCountSlider.minValue = VZVirtualMachineConfiguration.minimumAllowedCPUCount;
//    CPUCountSlider.maxValue = VZVirtualMachineConfiguration.maximumAllowedCPUCount;
//    CPUCountSlider.doubleValue = self.configuration.CPUCount;
//    CPUCountSlider.continuous = NO;
//    CPUCountSlider.target = self;
//    CPUCountSlider.action = @selector(_didChangeCPUCountSliderValue:);
//    CPUCountSlider.tickMarkPosition = NSTickMarkPositionBelow;
//    CPUCountSlider.numberOfTickMarks = VZVirtualMachineConfiguration.maximumAllowedCPUCount - VZVirtualMachineConfiguration.minimumAllowedCPUCount;
//    CPUCountSlider.allowsTickMarkValuesOnly = YES;
//    
//    _CPUCountSlider = CPUCountSlider;
//    return CPUCountSlider;
//}

- (NSPopUpButton *)_CPUCountPopUpButton {
    if (auto CPUCountPopUpButton = _CPUCountPopUpButton) return CPUCountPopUpButton;
    
    NSPopUpButton *CPUCountPopUpButton = [NSPopUpButton new];
    CPUCountPopUpButton.target = self;
    CPUCountPopUpButton.action = @selector(_didChangeCPUCountPopUpButtonSelection:);
    
    NSUInteger minimumAllowedCPUCount = VZVirtualMachineConfiguration.minimumAllowedCPUCount;
    NSUInteger maximumAllowedCPUCount = VZVirtualMachineConfiguration.maximumAllowedCPUCount;
    
    auto titlesVector = std::views::iota(static_cast<NSInteger>(minimumAllowedCPUCount), static_cast<NSInteger>(maximumAllowedCPUCount + 1))
    | std::views::transform([](auto count) {
        return @(count).stringValue;
    })
    | std::ranges::to<std::vector<NSString *>>();
    
    NSArray<NSString *> *titles = [[NSArray alloc] initWithObjects:titlesVector.data() count:titlesVector.size()];
    [CPUCountPopUpButton addItemsWithTitles:titles];
    [titles release];
    
    _CPUCountPopUpButton = CPUCountPopUpButton;
    return CPUCountPopUpButton;
}

- (void)_didChangeCPUCountPopUpButtonSelection:(NSPopUpButton *)sender {
    self.configuration.CPUCount = sender.titleOfSelectedItem.integerValue;
    
    if (auto delegate = self.delegate) {
        VZVirtualMachineConfiguration *copy = [self.configuration copy];
        [delegate editMachineCPUViewController:self didUpdateConfiguration:copy];
        [copy release];
    }
}

- (void)_didChangeConfiguration {
    [self.CPUCountPopUpButton selectItemWithTitle:@(self.configuration.CPUCount).stringValue];
}

@end
