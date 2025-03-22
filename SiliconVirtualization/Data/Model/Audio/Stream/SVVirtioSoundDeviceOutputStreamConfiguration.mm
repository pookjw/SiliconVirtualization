//
//  SVVirtioSoundDeviceOutputStreamConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "SVVirtioSoundDeviceOutputStreamConfiguration.h"

@implementation SVVirtioSoundDeviceOutputStreamConfiguration
@dynamic sink;

+ (NSFetchRequest<SVVirtioSoundDeviceOutputStreamConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioSoundDeviceOutputStreamConfiguration"];
}

@end
