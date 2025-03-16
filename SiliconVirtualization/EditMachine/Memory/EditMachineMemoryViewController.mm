//
//  EditMachineMemoryViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineMemoryViewController.h"
#import "EditMachineStorageControl.h"

@interface EditMachineMemoryViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;
@property (retain, nonatomic, readonly, getter=_memorySizeLabel) NSTextField *memorySizeLabel;
@property (retain, nonatomic, readonly, getter=_memorySizeControl) EditMachineStorageControl *memorySizeControl;
@end

@implementation EditMachineMemoryViewController
@synthesize gridView = _gridView;
@synthesize memorySizeLabel = _memorySizeLabel;
@synthesize memorySizeControl = _memorySizeControl;

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
    [_memorySizeControl release];
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
    
    self.memorySizeControl.unsignedInt64Value = self.configuration.memorySize;
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    self.memorySizeControl.unsignedInt64Value = configuration.memorySize;
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    NSGridRow *gridRow = [gridView addRowWithViews:@[self.memorySizeLabel, self.memorySizeControl]];
    [gridRow cellAtIndex:1].customPlacementConstraints = @[
        [self.memorySizeControl.widthAnchor constraintEqualToConstant:150.]
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

- (EditMachineStorageControl *)_memorySizeControl {
    if (auto memorySizeControl = _memorySizeControl) return memorySizeControl;
    
    EditMachineStorageControl *memorySizeControl = [EditMachineStorageControl new];
    
    memorySizeControl.minValue = VZVirtualMachineConfiguration.minimumAllowedMemorySize;
    memorySizeControl.maxValue = VZVirtualMachineConfiguration.maximumAllowedMemorySize;
    
    memorySizeControl.target = self;
    memorySizeControl.action = @selector(_didTriggerMemorySizeControl:);
    
    _memorySizeControl = memorySizeControl;
    return memorySizeControl;
}

- (void)_didTriggerMemorySizeControl:(EditMachineStorageControl *)sender {
    self.configuration.memorySize = sender.unsignedInt64Value;
    [self _notifyDelegate];
}

- (void)_notifyDelegate {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    [delegate editMachineMemoryViewController:self didUpdateConfiguration:configuration];
    [configuration release];
}

@end
