//
//  SVMacPlatformConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVPlatformConfiguration.h"
#import "SVMacAuxiliaryStorage.h"
#import "SVMacHardwareModel.h"
#import "SVMacMachineIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacPlatformConfiguration : SVPlatformConfiguration
+ (NSFetchRequest<SVMacPlatformConfiguration *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (retain, nonatomic, nullable) SVMacAuxiliaryStorage *auxiliaryStorage;
@property (retain, nonatomic, nullable) SVMacHardwareModel *hardwareModel;
@property (retain, nonatomic, nullable) SVMacMachineIdentifier *machineIdentifier;
@end

NS_ASSUME_NONNULL_END
