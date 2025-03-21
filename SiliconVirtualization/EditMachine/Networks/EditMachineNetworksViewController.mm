//
//  EditMachineNetworksViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineNetworksViewController.h"

@interface EditMachineNetworksViewController ()

@end

@implementation EditMachineNetworksViewController

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
