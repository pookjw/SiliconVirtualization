//
//  EditMachineBatterySourceDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "EditMachineBatterySourceDevicesViewController.h"

@interface EditMachineBatterySourceDevicesViewController ()

@end

@implementation EditMachineBatterySourceDevicesViewController

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [super dealloc];
}

@end
