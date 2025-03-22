//
//  SVAudioDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVAudioDeviceConfiguration.h"

@implementation SVAudioDeviceConfiguration
@dynamic machine;

+ (NSFetchRequest<SVAudioDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"AudioDeviceConfiguration"];
}

@end
