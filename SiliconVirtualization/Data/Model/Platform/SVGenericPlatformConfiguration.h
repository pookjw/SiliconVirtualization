//
//  SVGenericPlatformConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVPlatformConfiguration.h"
#import "SVGenericMachineIdentifier.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVGenericPlatformConfiguration : SVPlatformConfiguration
+ (NSFetchRequest<SVGenericPlatformConfiguration *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (nonatomic) BOOL nestedVirtualizationEnabled;
@property (retain, nonatomic, nullable) SVGenericMachineIdentifier *machineIdentifier;
@end

NS_ASSUME_NONNULL_END
