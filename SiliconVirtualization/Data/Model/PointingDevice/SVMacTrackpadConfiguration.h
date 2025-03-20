//
//  SVMacTrackpadConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVPointingDeviceConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacTrackpadConfiguration : SVPointingDeviceConfiguration
+ (NSFetchRequest<SVMacTrackpadConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
