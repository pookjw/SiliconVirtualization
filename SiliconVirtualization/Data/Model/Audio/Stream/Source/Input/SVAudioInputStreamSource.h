//
//  SVAudioInputStreamSource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtioSoundDeviceInputStreamConfiguration;

@interface SVAudioInputStreamSource : NSManagedObject
@property (nullable, nonatomic, retain) SVVirtioSoundDeviceInputStreamConfiguration *inputStream;
+ (NSFetchRequest<SVAudioInputStreamSource *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
