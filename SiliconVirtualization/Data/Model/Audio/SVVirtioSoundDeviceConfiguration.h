//
//  SVVirtioSoundDeviceConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioDeviceConfiguration.h"
#import "SVVirtioSoundDeviceStreamConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioSoundDeviceConfiguration : SVAudioDeviceConfiguration
+ (NSFetchRequest<SVVirtioSoundDeviceConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) NSOrderedSet<SVVirtioSoundDeviceStreamConfiguration *> *streams;

- (void)insertObject:(SVVirtioSoundDeviceStreamConfiguration *)value inStreamsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromStreamsAtIndex:(NSUInteger)idx;
- (void)insertStreams:(NSArray<SVVirtioSoundDeviceStreamConfiguration *> *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeStreamsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInStreamsAtIndex:(NSUInteger)idx withObject:(SVVirtioSoundDeviceStreamConfiguration *)value;
- (void)replaceStreamsAtIndexes:(NSIndexSet *)indexes withStreams:(NSArray<SVVirtioSoundDeviceStreamConfiguration *> *)values;
- (void)addStreamsObject:(SVVirtioSoundDeviceStreamConfiguration *)value;
- (void)removeStreamsObject:(SVVirtioSoundDeviceStreamConfiguration *)value;
- (void)addStreams:(NSOrderedSet<SVVirtioSoundDeviceStreamConfiguration *> *)values;
- (void)removeStreams:(NSOrderedSet<SVVirtioSoundDeviceStreamConfiguration *> *)values;
@end

NS_ASSUME_NONNULL_END
