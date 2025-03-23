//
//  SVVirtioFileSystemDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDirectorySharingDeviceConfiguration.h"
#import "SVDirectoryShare.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioFileSystemDeviceConfiguration : SVDirectorySharingDeviceConfiguration
+ (NSFetchRequest<SVVirtioFileSystemDeviceConfiguration *> *)fetchRequest;
@property (copy, nonatomic, nullable) NSString *tag;
@property (retain, nonatomic, nullable) SVDirectoryShare *share;
@end

NS_ASSUME_NONNULL_END
