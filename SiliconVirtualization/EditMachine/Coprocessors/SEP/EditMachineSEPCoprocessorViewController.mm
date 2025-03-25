//
//  EditMachineSEPCoprocessorViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineSEPCoprocessorViewController.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>

@interface EditMachineSEPCoprocessorViewController ()
@property (retain, nonatomic, readonly, getter=_gridView) NSGridView *gridView;

@property (retain, nonatomic, readonly, getter=_storageLabel) NSTextField *storageLabel;
@property (retain, nonatomic, readonly, getter=_storageValueLabel) NSTextField *storageValueLabel;

@property (retain, nonatomic, readonly, getter=_romBinaryLabel) NSTextField *romBinaryLabel;
@property (retain, nonatomic, readonly, getter=_romBinaryValueLabel) NSTextField *romBinaryValueLabel;
@property (retain, nonatomic, readonly, getter=_romBinaryButton) NSButton *romBinaryButton;
@end

@implementation EditMachineSEPCoprocessorViewController
@synthesize gridView = _gridView;
@synthesize storageLabel = _storageLabel;
@synthesize storageValueLabel = _storageValueLabel;
@synthesize romBinaryLabel = _romBinaryLabel;
@synthesize romBinaryValueLabel = _romBinaryValueLabel;
@synthesize romBinaryButton = _romBinaryButton;

- (void)dealloc {
    [_gridView release];
    [_storageLabel release];
    [_storageValueLabel release];
    [_romBinaryLabel release];
    [_romBinaryValueLabel release];
    [_romBinaryButton release];
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
    
    [self _didChangeSEPCoprocessor];
}

- (void)setSEPCoprocessorConfigurtion:(id)SEPCoprocessorConfigurtion {
    if (SEPCoprocessorConfigurtion != nil) {
        assert([SEPCoprocessorConfigurtion isKindOfClass:objc_lookUpClass("_VZSEPCoprocessorConfiguration")]);
    }
    
    [_SEPCoprocessorConfigurtion release];
    _SEPCoprocessorConfigurtion = [SEPCoprocessorConfigurtion copy];
    
    [self _didChangeSEPCoprocessor];
}

- (void)_didChangeSEPCoprocessor {
    id _Nullable SEPCoprocessorConfigurtion = self.SEPCoprocessorConfigurtion;
    
    if (SEPCoprocessorConfigurtion != nil) {
        id storage = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(SEPCoprocessorConfigurtion, sel_registerName("storage"));
        NSURL * storageURL = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(storage, sel_registerName("URL"));
        self.storageValueLabel.stringValue = storageURL.absoluteString;
        
        NSURL * _Nullable romBinaryURL = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(SEPCoprocessorConfigurtion, sel_registerName("romBinaryURL"));
        if (romBinaryURL != nil) {
            self.romBinaryValueLabel.stringValue = romBinaryURL.absoluteString;
        } else {
            self.romBinaryValueLabel.stringValue = @"(null)";
        }
    } else {
        self.storageValueLabel.stringValue = @"(null)";
        self.romBinaryValueLabel.stringValue = @"(null)";
    }
}

- (NSGridView *)_gridView {
    if (auto gridView = _gridView) return gridView;
    
    NSGridView *gridView = [NSGridView new];
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.storageLabel, self.storageValueLabel]];
        [row cellAtIndex:1].customPlacementConstraints = @[
            [self.storageValueLabel.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    {
        NSGridRow *row = [gridView addRowWithViews:@[self.romBinaryLabel, self.romBinaryValueLabel, self.romBinaryButton]];
        [row cellAtIndex:1].customPlacementConstraints = @[
            [self.romBinaryValueLabel.widthAnchor constraintEqualToConstant:150.]
        ];
    }
    
    _gridView = gridView;
    return gridView;
}

- (NSTextField *)_storageLabel {
    if (auto storageLabel = _storageLabel) return storageLabel;
    
    NSTextField *storageLabel = [NSTextField wrappingLabelWithString:@"Storage"];
    storageLabel.selectable = NO;
    
    _storageLabel = [storageLabel retain];
    return storageLabel;
}

- (NSTextField *)_storageValueLabel {
    if (auto storageValueLabel = _storageValueLabel) return storageValueLabel;
    
    NSTextField *storageValueLabel = [NSTextField wrappingLabelWithString:@""];
    storageValueLabel.selectable = NO;
    
    _storageValueLabel = [storageValueLabel retain];
    return storageValueLabel;
}

- (NSTextField *)_romBinaryLabel {
    if (auto romBinaryLabel = _romBinaryLabel) return romBinaryLabel;
    
    NSTextField *romBinaryLabel = [NSTextField wrappingLabelWithString:@"ROM Binary"];
    romBinaryLabel.selectable = NO;
    
    _romBinaryLabel = [romBinaryLabel retain];
    return romBinaryLabel;
}

- (NSTextField *)_romBinaryValueLabel {
    if (auto romBinaryValueLabel = _romBinaryValueLabel) return romBinaryValueLabel;
    
    NSTextField *romBinaryValueLabel = [NSTextField wrappingLabelWithString:@""];
    romBinaryValueLabel.selectable = NO;
    
    _romBinaryValueLabel = [romBinaryValueLabel retain];
    return romBinaryValueLabel;
}

- (NSButton *)_romBinaryButton {
    if (auto romBinaryButton = _romBinaryButton) return romBinaryButton;
    
    NSButton *romBinaryButton = [NSButton new];
    romBinaryButton.title = @"Change";
    romBinaryButton.target = self;
    romBinaryButton.action = @selector(_didTriggerRomBinaryButton:);
    
    _romBinaryButton = romBinaryButton;
    return romBinaryButton;
}

- (void)_didTriggerRomBinaryButton:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel new];
    
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowsMultipleSelection = NO;
    panel.allowedContentTypes = @[
        [UTType typeWithIdentifier:@"dyn.ah62d4rv4ge80w5mysa"] // .im4p
    ];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            id configuration = [self.SEPCoprocessorConfigurtion copy];
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(configuration, sel_registerName("setRomBinaryURL:"), URL);
            
            self.SEPCoprocessorConfigurtion = configuration;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineSEPCoprocessorViewController:self didUpdateSEPCoprocessorConfigurtion:configuration];
            }
            
            [configuration release];
        }
    }];
    
    [panel release];
}

@end
