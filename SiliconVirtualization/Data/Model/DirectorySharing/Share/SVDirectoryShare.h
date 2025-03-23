//
//  SVDirectoryShare.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtioFileSystemDeviceConfiguration;

@interface SVDirectoryShare : NSManagedObject
+ (NSFetchRequest<SVDirectoryShare *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtioFileSystemDeviceConfiguration *fileSystemDevice;
@end

NS_ASSUME_NONNULL_END
