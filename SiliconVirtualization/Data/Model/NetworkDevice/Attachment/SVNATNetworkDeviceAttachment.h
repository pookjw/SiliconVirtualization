//
//  SVNATNetworkDeviceAttachment.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVNetworkDeviceAttachment.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVNATNetworkDeviceAttachment : SVNetworkDeviceAttachment
+ (NSFetchRequest<SVNATNetworkDeviceAttachment *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
