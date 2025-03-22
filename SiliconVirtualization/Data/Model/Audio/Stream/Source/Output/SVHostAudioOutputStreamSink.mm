//
//  SVHostAudioOutputStreamSink.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVHostAudioOutputStreamSink.h"

@implementation SVHostAudioOutputStreamSink

+ (NSFetchRequest<SVHostAudioOutputStreamSink *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"HostAudioOutputStreamSink"];
}

@end
