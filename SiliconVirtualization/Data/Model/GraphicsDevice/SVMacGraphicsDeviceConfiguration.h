//
//  SVMacGraphicsDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDeviceConfiguration.h"
#import "SVMacGraphicsDisplayConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVMacGraphicsDeviceConfiguration : SVGraphicsDeviceConfiguration
+ (NSFetchRequest<SVMacGraphicsDeviceConfiguration *> *)fetchRequest;

@property (retain, nonatomic, nullable) NSOrderedSet<SVMacGraphicsDisplayConfiguration *> *displays;

- (void)insertObject:(SVMacGraphicsDisplayConfiguration *)value inDisplaysAtIndex:(NSUInteger)idx;
- (void)removeObjectFromDisplaysAtIndex:(NSUInteger)idx;
- (void)insertDisplays:(NSArray<SVMacGraphicsDisplayConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeDisplaysAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInDisplaysAtIndex:(NSUInteger)idx withObject:(SVMacGraphicsDisplayConfiguration *)value;
- (void)replaceDisplaysAtIndexes:(NSIndexSet *)indexes withDisplays:(NSArray<SVMacGraphicsDisplayConfiguration *> *)values;
- (void)addDisplaysObject:(SVMacGraphicsDisplayConfiguration *)value;
- (void)removeDisplaysObject:(SVMacGraphicsDisplayConfiguration *)value;
- (void)addDisplays:(NSOrderedSet<SVMacGraphicsDisplayConfiguration *> *)values;
- (void)removeDisplays:(NSOrderedSet<SVMacGraphicsDisplayConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
