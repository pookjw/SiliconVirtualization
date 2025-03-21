//
//  SVMACAddress.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVNetworkDeviceConfiguration;

@interface SVMACAddress : NSManagedObject
+ (NSFetchRequest<SVMACAddress *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSData *ethernetAddress;
@property (retain, nonatomic, nullable) SVNetworkDeviceConfiguration *networkDevice;
@end

NS_ASSUME_NONNULL_END
