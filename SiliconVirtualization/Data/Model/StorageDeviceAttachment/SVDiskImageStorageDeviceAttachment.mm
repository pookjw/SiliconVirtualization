//
//  SVDiskImageStorageDeviceAttachment.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVDiskImageStorageDeviceAttachment.h"

@implementation SVDiskImageStorageDeviceAttachment
@dynamic bookmarkData;
@dynamic cachingMode;
@dynamic readOnly;
@dynamic synchronizationMode;

+ (NSFetchRequest<SVDiskImageStorageDeviceAttachment *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"DiskImageStorageDeviceAttachment"];
}

@end
