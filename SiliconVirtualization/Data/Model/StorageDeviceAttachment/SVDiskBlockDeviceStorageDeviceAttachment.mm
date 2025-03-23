//
//  SVDiskBlockDeviceStorageDeviceAttachment.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVDiskBlockDeviceStorageDeviceAttachment.h"

@implementation SVDiskBlockDeviceStorageDeviceAttachment
@dynamic fileDescriptor;
@dynamic readOnly;
@dynamic synchronizationMode;

+ (NSFetchRequest<SVDiskBlockDeviceStorageDeviceAttachment *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"DiskBlockDeviceStorageDeviceAttachment"];
}

@end
