//
//  SVMacOSBootLoader.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVBootLoader.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacOSBootLoader : SVBootLoader
+ (NSFetchRequest<SVMacOSBootLoader *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
