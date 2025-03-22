//
//  EditMachineUSBViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "EditMachineUSBViewController.h"

@interface EditMachineUSBViewController ()

@end

@implementation EditMachineUSBViewController

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
