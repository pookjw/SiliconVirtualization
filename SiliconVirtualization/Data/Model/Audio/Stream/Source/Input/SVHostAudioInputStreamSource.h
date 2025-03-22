//
//  SVHostAudioInputStreamSource.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioInputStreamSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVHostAudioInputStreamSource : SVAudioInputStreamSource
+ (NSFetchRequest<SVHostAudioInputStreamSource *> *)fetchRequest;
@end

NS_ASSUME_NONNULL_END
