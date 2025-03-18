//
//  SVMacHardwareModel.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVMacPlatformConfiguration;

@interface SVMacHardwareModel : NSManagedObject
+ (NSFetchRequest<SVMacHardwareModel *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (retain, nonatomic, nullable) NSData *dataRepresentation;
@property (retain, nonatomic, nullable) SVMacPlatformConfiguration *platform;
@end

NS_ASSUME_NONNULL_END
