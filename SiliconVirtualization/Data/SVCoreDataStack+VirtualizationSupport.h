//
//  SVCoreDataStack+VirtualizationSupport.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVCoreDataStack.h"
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVCoreDataStack (VirtualizationSupport)
- (SVVirtualMachineConfiguration *)isolated_makeManagedObjectFromVirtualMachineConfiguration:(VZVirtualMachineConfiguration *)virtualMachineConfiguration;
- (VZVirtualMachineConfiguration *)isolated_makeVirtualMachineConfigurationFromManagedObject:(SVVirtualMachineConfiguration *)virtualMachineConfigurationObject;
- (void)isolated_updateManagedObject:(SVVirtualMachineConfiguration *)virtualMachineConfiguration withMachineConfiguration:(VZVirtualMachineConfiguration *)machineConfiguration;
@end

NS_ASSUME_NONNULL_END
