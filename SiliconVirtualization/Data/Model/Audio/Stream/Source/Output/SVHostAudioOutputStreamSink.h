//
//  SVHostAudioOutputStreamSink.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioOutputStreamSink.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVHostAudioOutputStreamSink : SVAudioOutputStreamSink
+ (NSFetchRequest<SVHostAudioOutputStreamSink *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
