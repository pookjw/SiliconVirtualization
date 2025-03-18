//
//  SVGenericMachineIdentifier.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVGenericPlatformConfiguration;

@interface SVGenericMachineIdentifier : NSManagedObject
+ (NSFetchRequest<SVGenericMachineIdentifier *> *)fetchRequest NS_SWIFT_NAME(fetchRequest());
@property (retain, nonatomic, nullable) NSData *dataRepresentation;
@property (retain, nonatomic, nullable) SVGenericPlatformConfiguration *platform;
@end

NS_ASSUME_NONNULL_END
