//
//  SVNetworkDeviceAttachment.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVNetworkDeviceConfiguration;

@interface SVNetworkDeviceAttachment : NSManagedObject
+ (NSFetchRequest<SVNetworkDeviceAttachment *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVNetworkDeviceConfiguration *networkDevice;
@end

NS_ASSUME_NONNULL_END
