//
//  SVXHCIControllerConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "SVXHCIControllerConfiguration.h"

@implementation SVXHCIControllerConfiguration

+ (NSFetchRequest<SVXHCIControllerConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"XHCIControllerConfiguration"];
}

@end
