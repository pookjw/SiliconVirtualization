//
//  SVStorageDeviceAttachment.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVStorageDeviceConfiguration;

@interface SVStorageDeviceAttachment : NSManagedObject
+ (NSFetchRequest<SVStorageDeviceAttachment *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVStorageDeviceConfiguration *storageDevice;
@end

NS_ASSUME_NONNULL_END
