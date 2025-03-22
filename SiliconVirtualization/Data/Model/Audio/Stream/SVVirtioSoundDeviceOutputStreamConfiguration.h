//
//  SVVirtioSoundDeviceOutputStreamConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceStreamConfiguration.h"
#import "SVAudioOutputStreamSink.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioSoundDeviceOutputStreamConfiguration : SVVirtioSoundDeviceStreamConfiguration
@property (retain, nonatomic, nullable) SVAudioOutputStreamSink *sink;
+ (NSFetchRequest<SVVirtioSoundDeviceOutputStreamConfiguration *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
