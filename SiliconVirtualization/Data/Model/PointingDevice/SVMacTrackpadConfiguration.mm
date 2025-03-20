//
//  SVMacTrackpadConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import "SVMacTrackpadConfiguration.h"

@implementation SVMacTrackpadConfiguration

+ (NSFetchRequest<SVMacTrackpadConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacTrackpadConfiguration"];
}

@end
