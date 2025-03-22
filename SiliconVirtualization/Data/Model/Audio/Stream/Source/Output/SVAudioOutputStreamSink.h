//
//  SVAudioOutputStreamSink.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtioSoundDeviceOutputStreamConfiguration;

@interface SVAudioOutputStreamSink : NSManagedObject
@property (nullable, nonatomic, retain) SVVirtioSoundDeviceOutputStreamConfiguration *outputStream;
+ (NSFetchRequest<SVAudioOutputStreamSink *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
