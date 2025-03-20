//
//  EditMachineUSBKeyboardViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "EditMachineUSBKeyboardViewController.h"

@interface EditMachineUSBKeyboardViewController ()
@property (retain, nonatomic, readonly, getter=_triggerButton) NSButton *triggerButton;
@end

@implementation EditMachineUSBKeyboardViewController
@synthesize triggerButton = _triggerButton;

- (void)dealloc {
    [_USBKeyboardConfiguration release];
    [_triggerButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSButton *triggerButton = self.triggerButton;
    triggerButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:triggerButton];
    [NSLayoutConstraint activateConstraints:@[
        [triggerButton.centerXAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerXAnchor],
        [triggerButton.centerYAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.centerYAnchor]
    ]];
}

- (NSButton *)_triggerButton {
    if (auto triggerButton = _triggerButton) return triggerButton;
    
    NSButton *triggerButton = [NSButton new];
    triggerButton.title = @"Trigger";
    triggerButton.target = self;
    triggerButton.action = @selector(_didTriggerButton:);
    
    _triggerButton = triggerButton;
    return triggerButton;
}

- (void)_didTriggerButton:(NSButton *)sender {
    assert(self.USBKeyboardConfiguration != nil);
    
    if (auto delegate = self.delegate) {
        [delegate editMachineUSBKeyboardViewController:self didUpdateKeyboardConfiguration:self.USBKeyboardConfiguration];
    }
}

@end
