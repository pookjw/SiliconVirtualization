//
//  SVDiskBlockDeviceStorageDeviceAttachment.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVStorageDeviceAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDiskBlockDeviceStorageDeviceAttachment : SVStorageDeviceAttachment
@property (nonatomic) int32_t fileDescriptor;
@property (nonatomic) BOOL readOnly;
@property (nonatomic) int64_t synchronizationMode;
+ (NSFetchRequest<SVDiskBlockDeviceStorageDeviceAttachment *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
