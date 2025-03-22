//
//  SVXHCIControllerConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import "SVUSBControllerConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVXHCIControllerConfiguration : SVUSBControllerConfiguration
+ (NSFetchRequest<SVXHCIControllerConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
