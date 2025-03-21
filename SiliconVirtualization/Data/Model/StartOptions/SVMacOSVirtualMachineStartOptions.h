//
//  SVMacOSVirtualMachineStartOptions.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import "SVVirtualMachineStartOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacOSVirtualMachineStartOptions : SVVirtualMachineStartOptions
+ (NSFetchRequest<SVMacOSVirtualMachineStartOptions *> *)fetchRequest;
@property (nonatomic) BOOL startUpFromMacOSRecovery;
@end

NS_ASSUME_NONNULL_END
