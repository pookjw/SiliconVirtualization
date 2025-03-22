//
//  SVVirtioSoundDeviceStreamConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceStreamConfiguration.h"

@implementation SVVirtioSoundDeviceStreamConfiguration
@dynamic soundDevice;

+ (NSFetchRequest<SVVirtioSoundDeviceStreamConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioSoundDeviceStreamConfiguration"];
}

@end
