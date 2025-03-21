//
//  SVMACAddress.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVMACAddress.h"

@implementation SVMACAddress
@dynamic ethernetAddress;
@dynamic networkDevice;

+ (NSFetchRequest<SVMACAddress *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MACAddress"];
}

@end
