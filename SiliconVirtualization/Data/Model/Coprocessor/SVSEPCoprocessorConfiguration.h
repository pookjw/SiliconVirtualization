//
//  SVSEPCoprocessorConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVCoprocessorConfiguration.h"
#import "SVSEPStorage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVSEPCoprocessorConfiguration : SVCoprocessorConfiguration
+ (NSFetchRequest<SVSEPCoprocessorConfiguration *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (nullable, nonatomic, retain) NSData *romBinaryBookmarkData;
@property (nullable, nonatomic, retain) SVSEPStorage *storage;
@end

NS_ASSUME_NONNULL_END
