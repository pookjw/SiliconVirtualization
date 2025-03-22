//
//  SVVirtioSoundDeviceInputStreamConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceInputStreamConfiguration.h"

@implementation SVVirtioSoundDeviceInputStreamConfiguration
@dynamic source;

+ (NSFetchRequest<SVVirtioSoundDeviceInputStreamConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioSoundDeviceInputStreamConfiguration"];
}

@end
