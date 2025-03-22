//
//  EditMachineSidebarViewItem.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineSidebarViewItem.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineSidebarViewItem ()
@property (retain, nonatomic, readonly, getter=_visualEffectView) NSVisualEffectView *visualEffectView;
@end

@implementation EditMachineSidebarViewItem
@synthesize visualEffectView = _visualEffectView;

- (void)dealloc {
    [_itemModel release];
    [_visualEffectView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSView *view = self.view;
    NSVisualEffectView *visualEffectView = self.visualEffectView;
    NSTextField *textField = [NSTextField wrappingLabelWithString:@""];
    textField.selectable = NO;
    NSImageView *imageView = [NSImageView new];
    
    textField.translatesAutoresizingMaskIntoConstraints = NO;
    imageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [textField setContentHuggingPriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    [textField setContentCompressionResistancePriority:NSLayoutPriorityDefaultLow forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [imageView setContentHuggingPriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    [imageView setContentCompressionResistancePriority:NSLayoutPriorityDefaultHigh forOrientation:NSLayoutConstraintOrientationHorizontal];
    
    [view addSubview:visualEffectView];
    [view addSubview:textField];
    [view addSubview:imageView];
    
    visualEffectView.frame = view.bounds;
    visualEffectView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    
    [NSLayoutConstraint activateConstraints:@[
        [imageView.topAnchor constraintGreaterThanOrEqualToAnchor:view.topAnchor constant:10.],
        [imageView.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:10.],
        [imageView.trailingAnchor constraintEqualToAnchor:textField.leadingAnchor constant:-10.],
        [imageView.bottomAnchor constraintLessThanOrEqualToAnchor:view.bottomAnchor constant:-10.],
        [imageView.centerYAnchor constraintEqualToAnchor:view.centerYAnchor],
        
        [textField.topAnchor constraintGreaterThanOrEqualToAnchor:view.topAnchor constant:10.],
        [textField.trailingAnchor constraintEqualToAnchor:view.trailingAnchor constant:-10.],
        [textField.bottomAnchor constraintLessThanOrEqualToAnchor:view.bottomAnchor constant:-10.],
        [textField.centerYAnchor constraintEqualToAnchor:view.centerYAnchor]
    ]];
    
    self.textField = textField;
    self.imageView = imageView;
    [imageView release];
    
    [self _updateVisualEffectView];
}

- (void)setItemModel:(EditMachineSidebarItemModel *)itemModel {
    [_itemModel release];
    _itemModel = [itemModel retain];
    
    [self _updateTextField];
    [self _updateImageView];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self _updateVisualEffectView];
    [self _updateImageView];
}

- (void)_updateVisualEffectView {
    self.visualEffectView.hidden = !self.selected;
}

- (void)_updateTextField {
    NSTextField *textField = self.textField;
    
    switch (self.itemModel.type) {
        case EditMachineSidebarItemModelTypeBootLoader: {
            textField.stringValue = @"BootLoader";
            break;
        }
        case EditMachineSidebarItemModelTypePlatform: {
            textField.stringValue = @"Platform";
            break;
        }
        case EditMachineSidebarItemModelTypeCPU: {
            textField.stringValue = @"CPU";
            break;
        }
        case EditMachineSidebarItemModelTypeMemory: {
            textField.stringValue = @"Memory";
            break;
        }
        case EditMachineSidebarItemModelTypeAudio: {
            textField.stringValue = @"Audio";
            break;
        }
        case EditMachineSidebarItemModelTypeKeyboards: {
            textField.stringValue = @"Keyboards";
            break;
        }
        case EditMachineSidebarItemModelTypeNetworks: {
            textField.stringValue = @"Networks";
            break;
        }
        case EditMachineSidebarItemModelTypePointingDevices: {
            textField.stringValue = @"Pointing Devices";
            break;
        }
        case EditMachineSidebarItemModelTypeGraphics: {
            textField.stringValue = @"Graphics";
            break;
        }
        case EditMachineSidebarItemModelTypeStorages: {
            textField.stringValue = @"Storages";
            break;
        }
        case EditMachineSidebarItemModelTypeUSB: {
            textField.stringValue = @"USB";
            break;
        }
        default:
            abort();
    }
}

- (void)_updateImageView {
    BOOL selected = self.selected;
    NSImageView *imageView = self.imageView;
    
    switch (self.itemModel.type) {
        case EditMachineSidebarItemModelTypeBootLoader: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"desktopcomputer.and.macbook" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypePlatform: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"desktopcomputer.and.macbook" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeCPU: {
            imageView.image = [NSImage imageWithSystemSymbolName:selected ? @"cpu.fill" : @"cpu" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeAudio: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"airpods.pro" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeKeyboards: {
            imageView.image = [NSImage imageWithSystemSymbolName:selected ? @"keyboard.fill" : @"keyboard" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeNetworks: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"network" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypePointingDevices: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"cursorarrow" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeMemory: {
            imageView.image = [NSImage imageWithSystemSymbolName:selected ? @"memorychip.fill" : @"memorychip" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeGraphics: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"display" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeStorages: {
            imageView.image = [NSImage imageWithSystemSymbolName:selected ? @"externaldrive.fill" : @"externaldrive" accessibilityDescription:nil];
            break;
        }
        case EditMachineSidebarItemModelTypeUSB: {
            imageView.image = [NSImage imageWithSystemSymbolName:@"cable.connector" accessibilityDescription:nil];
            break;
        }
        default:
            abort();
    }
}

- (NSVisualEffectView *)_visualEffectView {
    if (auto visualEffectView = _visualEffectView) return visualEffectView;
    
    NSVisualEffectView *visualEffectView = [NSVisualEffectView new];
    
    visualEffectView.material = NSVisualEffectMaterialSelection;
    visualEffectView.blendingMode = NSVisualEffectBlendingModeBehindWindow;
    visualEffectView.emphasized = NO;
    
    _visualEffectView = visualEffectView;
    return visualEffectView;
}

@end
