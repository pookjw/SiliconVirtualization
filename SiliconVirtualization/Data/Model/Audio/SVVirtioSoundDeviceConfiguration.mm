//
//  SVVirtioSoundDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceConfiguration.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincomplete-implementation"
@implementation SVVirtioSoundDeviceConfiguration
#pragma clang diagnostic pop

@dynamic streams;

+ (NSFetchRequest<SVVirtioSoundDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioSoundDeviceConfiguration"];
}

@end
