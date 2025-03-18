//
//  SVVirtioGraphicsScanoutConfiguration.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVVirtioGraphicsScanoutConfiguration.h"

@implementation SVVirtioGraphicsScanoutConfiguration
@dynamic heightInPixels;
@dynamic widthInPixels;
@dynamic graphicsDevice;

+ (NSFetchRequest<SVVirtioGraphicsScanoutConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"VirtioGraphicsScanoutConfiguration"];
}

@end
