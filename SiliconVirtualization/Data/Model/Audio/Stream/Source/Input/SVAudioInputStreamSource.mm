//
//  SVAudioInputStreamSource.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioInputStreamSource.h"

@implementation SVAudioInputStreamSource
@dynamic inputStream;

+ (NSFetchRequest<SVAudioInputStreamSource *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"AudioInputStreamSource"];
}

@end
