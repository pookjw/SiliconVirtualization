//
//  SVHostAudioInputStreamSource.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVHostAudioInputStreamSource.h"

@implementation SVHostAudioInputStreamSource

+ (NSFetchRequest<SVHostAudioInputStreamSource *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"HostAudioInputStreamSource"];
}

@end
