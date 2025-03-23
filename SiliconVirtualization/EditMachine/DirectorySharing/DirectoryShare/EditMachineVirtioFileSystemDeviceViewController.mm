//
//  EditMachineVirtioFileSystemDeviceViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineVirtioFileSystemDeviceViewController.h"
#import "EditMachineVirtioFileSystemDeviceDirectoriesView.h"

@interface EditMachineVirtioFileSystemDeviceViewController () <EditMachineVirtioFileSystemDeviceDirectoriesViewDelegate>
@property (retain, nonatomic, readonly, getter=_stackView) NSStackView *stackView;

@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_directoryShareLabel) NSTextField *directoryShareLabel;
@property (retain, nonatomic, readonly, getter=_directorySharePopUpButton) NSPopUpButton *directorySharePopUpButton;

@property (retain, nonatomic, readonly, getter=_singleDirectoryShareURLLabel) NSTextField *singleDirectoryShareURLLabel;

@property (retain, nonatomic, readonly, getter=_directoriesView) EditMachineVirtioFileSystemDeviceDirectoriesView *directoriesView;
@end

@implementation EditMachineVirtioFileSystemDeviceViewController
@synthesize stackView = _stackView;
@synthesize gridView = _gridView;
@synthesize directoryShareLabel = _directoryShareLabel;
@synthesize directorySharePopUpButton = _directorySharePopUpButton;
@synthesize singleDirectoryShareURLLabel = _singleDirectoryShareURLLabel;
@synthesize directoriesView = _directoriesView;

- (void)dealloc {
    [_stackView release];
    [_gridView release];
    [_directoryShareLabel release];
    [_directorySharePopUpButton release];
    [_singleDirectoryShareURLLabel release];
    [_directoriesView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSStackView *stackView = self.stackView;
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    [NSLayoutConstraint activateConstraints:@[
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
}

- (void)setConfiguration:(VZVirtioFileSystemDeviceConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    __kindof VZDirectoryShare * _Nullable share = self.configuration.share;
    
    if (share == nil) {
        [self.directorySharePopUpButton selectItemWithTitle:@"(None)"];
        [self.gridView rowAtIndex:1].hidden = YES;
        self.directoriesView.hidden = YES;
    } else if ([share isKindOfClass:[VZSingleDirectoryShare class]]) {
        auto casted = static_cast<VZSingleDirectoryShare *>(share);
        
        [self.directorySharePopUpButton selectItemWithTitle:@"Single"];
        self.singleDirectoryShareURLLabel.stringValue = casted.directory.URL.absoluteString;
        [self.gridView rowAtIndex:1].hidden = NO;
        self.directoriesView.hidden = YES;
    } else if ([share isKindOfClass:[VZMultipleDirectoryShare class]]) {
        auto casted = static_cast<VZMultipleDirectoryShare *>(share);
        
        [self.directorySharePopUpButton selectItemWithTitle:@"Multiple"];
        [self.gridView rowAtIndex:1].hidden = YES;
        self.directoriesView.hidden = NO;
        self.directoriesView.directories = casted.directories;
    } else {
        abort();
    }
}

- (NSStackView *)_stackView {
    if (auto stackView = _stackView) return stackView;
    
    NSStackView *stackView = [NSStackView new];
    [stackView addArrangedSubview:self.gridView];
    [stackView addArrangedSubview:self.directoriesView];
    
    stackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    stackView.alignment = NSLayoutAttributeWidth;
    stackView.distribution = NSStackViewDistributionFillEqually;
    
    _stackView = stackView;
    return stackView;
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    [gridView addRowWithViews:@[
        self.directoryShareLabel, self.directorySharePopUpButton
    ]];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.singleDirectoryShareURLLabel]];
        [row mergeCellsInRange:NSMakeRange(0, 2)];
        row.yPlacement = NSGridCellPlacementTop;
    }
    
    gridView.xPlacement = NSGridCellPlacementCenter;
    gridView.yPlacement = NSGridCellPlacementCenter;
    gridView.rowAlignment = NSGridRowAlignmentNone;
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_directoryShareLabel {
    if (auto directoryShareLabel = _directoryShareLabel) return directoryShareLabel;
    
    NSTextField *directoryShareLabel = [NSTextField wrappingLabelWithString:@"Directory Share"];
    directoryShareLabel.selectable = NO;
    
    _directoryShareLabel = [directoryShareLabel retain];
    return directoryShareLabel;
}

- (NSPopUpButton *)_directorySharePopUpButton {
    if (auto directorySharePopUpButton = _directorySharePopUpButton) return directorySharePopUpButton;
    
    NSPopUpButton *directorySharePopUpButton = [NSPopUpButton new];
    
    [directorySharePopUpButton addItemsWithTitles:@[
        @"(None)", @"Single", @"Multiple"
    ]];
    directorySharePopUpButton.target = self;
    directorySharePopUpButton.action = @selector(_didTriggerDirectorySharePopUpButton:);
    
    _directorySharePopUpButton = directorySharePopUpButton;
    return directorySharePopUpButton;
}

- (NSTextField *)_singleDirectoryShareURLLabel {
    if (auto singleDirectoryShareURLLabel = _singleDirectoryShareURLLabel) return singleDirectoryShareURLLabel;
    
    NSTextField *singleDirectoryShareURLLabel = [NSTextField wrappingLabelWithString:@""];
    singleDirectoryShareURLLabel.selectable = NO;
    
    _singleDirectoryShareURLLabel = [singleDirectoryShareURLLabel retain];
    return singleDirectoryShareURLLabel;
}

- (EditMachineVirtioFileSystemDeviceDirectoriesView *)_directoriesView {
    if (auto directoriesView = _directoriesView) return directoriesView;
    
    EditMachineVirtioFileSystemDeviceDirectoriesView *directoriesView = [EditMachineVirtioFileSystemDeviceDirectoriesView new];
    directoriesView.hidden = YES;
    directoriesView.delegate = self;
    
    _directoriesView = directoriesView;
    return directoriesView;
}

- (void)_didTriggerDirectorySharePopUpButton:(NSPopUpButton *)sender {
    if ([sender.titleOfSelectedItem isEqualToString:@"(None)"]) {
        [self _updateWithShare:nil];
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Single"]) {
        NSOpenPanel *panel = [NSOpenPanel new];
        panel.canChooseFiles = NO;
        panel.canChooseDirectories = YES;
        panel.allowsMultipleSelection = NO;
        
        NSTextField *readOnlyLabel = [NSTextField wrappingLabelWithString:@"Read Only"];
        readOnlyLabel.selectable = NO;
        
        NSSwitch *readOnlySwitch = [NSSwitch new];
        
        NSStackView *accessoryView = [NSStackView new];
        [accessoryView addArrangedSubview:readOnlyLabel];
        [accessoryView addArrangedSubview:readOnlySwitch];
        accessoryView.frame = NSMakeRect(0., 0., accessoryView.fittingSize.width, accessoryView.fittingSize.height);
        panel.accessoryView = accessoryView;
        [accessoryView release];
        
        [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
            if (NSURL *URL = panel.URL) {
                BOOL readOnly = (readOnlySwitch.state == NSControlStateValueOn);
                
                VZSharedDirectory *directory = [[VZSharedDirectory alloc] initWithURL:URL readOnly:readOnly];
                VZSingleDirectoryShare *share = [[VZSingleDirectoryShare alloc] initWithDirectory:directory];
                [directory release];
                
                [self _updateWithShare:share];
                [share release];
            }
        }];
        
        [readOnlySwitch release];
        [panel release];
    } else if ([sender.titleOfSelectedItem isEqualToString:@"Multiple"]) {
        VZMultipleDirectoryShare *share = [[VZMultipleDirectoryShare alloc] initWithDirectories:@{}];
        [self _updateWithShare:share];
        [share release];
    } else {
        abort();
    }
}

- (void)_updateWithShare:(__kindof VZDirectoryShare * _Nullable)share {
    VZVirtioFileSystemDeviceConfiguration *configuration = [self.configuration copy];
    assert(configuration != nil);
    configuration.share = share;
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioFileSystemDeviceViewController:self didChangeConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineVirtioFileSystemDeviceDirectoriesView:(EditMachineVirtioFileSystemDeviceDirectoriesView *)editMachineVirtioFileSystemDeviceDirectoriesView didUpdateDirectories:(NSDictionary<NSString *,VZSharedDirectory *> *)directories {
    VZVirtioFileSystemDeviceConfiguration *configuration = [self.configuration copy];
    assert([configuration.share isKindOfClass:[VZMultipleDirectoryShare class]]);
    
    VZMultipleDirectoryShare *share = [[VZMultipleDirectoryShare alloc] initWithDirectories:directories];
    configuration.share = share;
    [share release];
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioFileSystemDeviceViewController:self didChangeConfiguration:configuration];
    }
    
    [configuration release];
}

@end
