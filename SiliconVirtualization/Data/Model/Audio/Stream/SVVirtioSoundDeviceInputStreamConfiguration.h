//
//  SVVirtioSoundDeviceInputStreamConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceStreamConfiguration.h"
#import "SVAudioInputStreamSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtioSoundDeviceInputStreamConfiguration : SVVirtioSoundDeviceStreamConfiguration
+ (NSFetchRequest<SVVirtioSoundDeviceInputStreamConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVAudioInputStreamSource *source;
@end

NS_ASSUME_NONNULL_END
