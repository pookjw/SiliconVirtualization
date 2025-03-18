//
//  EditMachinePlatformViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "EditMachinePlatformViewController.h"

@interface EditMachinePlatformViewController ()

@end

@implementation EditMachinePlatformViewController

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
