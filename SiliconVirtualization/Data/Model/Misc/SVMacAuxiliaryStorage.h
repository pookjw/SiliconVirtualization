//
//  SVMacAuxiliaryStorage.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVMacPlatformConfiguration;

@interface SVMacAuxiliaryStorage : NSManagedObject
+ (NSFetchRequest<SVMacAuxiliaryStorage *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (retain, nonatomic, nullable) NSData *bookmarkData;
@property (retain, nonatomic, nullable) SVMacPlatformConfiguration *platform;
@end

NS_ASSUME_NONNULL_END
