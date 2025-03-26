//
//  SVMacGraphicsDisplayConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVMacGraphicsDisplayConfiguration.h"

@implementation SVMacGraphicsDisplayConfiguration
@dynamic displayMode;
@dynamic heightInPixels;
@dynamic pixelsPerInch;
@dynamic widthInPixels;
@dynamic graphicsDevice;

+ (NSFetchRequest<SVMacGraphicsDisplayConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacGraphicsDisplayConfiguration"];
}

@end
