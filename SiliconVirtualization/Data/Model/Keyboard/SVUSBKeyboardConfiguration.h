//
//  SVUSBKeyboardConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVKeyboardConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVUSBKeyboardConfiguration : SVKeyboardConfiguration
+ (NSFetchRequest<SVUSBKeyboardConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
