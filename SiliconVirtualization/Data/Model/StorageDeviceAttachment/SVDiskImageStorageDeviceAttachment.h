//
//  SVDiskImageStorageDeviceAttachment.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVStorageDeviceAttachment.h"
#import "SVDiskImageStorageDeviceAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVDiskImageStorageDeviceAttachment : SVStorageDeviceAttachment
+ (NSFetchRequest<SVDiskImageStorageDeviceAttachment *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());

@property (retain, nonatomic, nullable) NSData *bookmarkData;
@property (nonatomic) int64_t cachingMode;
@property (nonatomic) BOOL readOnly;
@property (nonatomic) int64_t synchronizationMode;
@end

NS_ASSUME_NONNULL_END
