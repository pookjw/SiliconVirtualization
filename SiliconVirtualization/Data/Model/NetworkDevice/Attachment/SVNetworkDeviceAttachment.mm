//
//  SVNetworkDeviceAttachment.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVNetworkDeviceAttachment.h"

@implementation SVNetworkDeviceAttachment
@dynamic networkDevice;

+ (NSFetchRequest<SVNetworkDeviceAttachment *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"NetworkDeviceAttachment"];
}

@end
