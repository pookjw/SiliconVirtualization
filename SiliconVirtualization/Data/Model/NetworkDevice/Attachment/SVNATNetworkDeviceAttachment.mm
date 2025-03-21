//
//  SVNATNetworkDeviceAttachment.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVNATNetworkDeviceAttachment.h"

@implementation SVNATNetworkDeviceAttachment

+ (NSFetchRequest<SVNATNetworkDeviceAttachment *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"NATNetworkDeviceAttachment"];
}

@end
