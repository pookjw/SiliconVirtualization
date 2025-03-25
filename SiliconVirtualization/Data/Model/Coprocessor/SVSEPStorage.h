//
//  SVSEPStorage.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVSEPCoprocessorConfiguration;

@interface SVSEPStorage : NSManagedObject
+ (NSFetchRequest<SVSEPStorage *> *)fetchRequest;
@property (nullable, nonatomic, retain) NSData *bookmarkData;
@property (nullable, nonatomic, retain) SVSEPCoprocessorConfiguration *sepCoprocessor;
@end

NS_ASSUME_NONNULL_END
