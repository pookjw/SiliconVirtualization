//
//  SVAudioOutputStreamSink.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioOutputStreamSink.h"

@implementation SVAudioOutputStreamSink
@dynamic outputStream;

+ (NSFetchRequest<SVAudioOutputStreamSink *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"AudioOutputStreamSink"];
}

@end
