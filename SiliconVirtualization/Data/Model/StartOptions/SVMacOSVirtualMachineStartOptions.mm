//
//  SVMacOSVirtualMachineStartOptions.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import "SVMacOSVirtualMachineStartOptions.h"

@implementation SVMacOSVirtualMachineStartOptions
@dynamic startUpFromMacOSRecovery;

+ (NSFetchRequest<SVMacOSVirtualMachineStartOptions *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacOSVirtualMachineStartOptions"];
}

@end
