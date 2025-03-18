//
//  SVStorageDeviceAttachment.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVStorageDeviceAttachment.h"

@implementation SVStorageDeviceAttachment
@dynamic storageDevice;

+ (NSFetchRequest<SVStorageDeviceAttachment *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"StorageDeviceAttachment"];
}

@end
