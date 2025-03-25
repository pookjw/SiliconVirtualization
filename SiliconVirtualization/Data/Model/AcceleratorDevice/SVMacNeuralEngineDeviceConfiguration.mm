//
//  SVMacNeuralEngineDeviceConfiguration.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "SVMacNeuralEngineDeviceConfiguration.h"

@implementation SVMacNeuralEngineDeviceConfiguration

+ (NSFetchRequest<SVMacNeuralEngineDeviceConfiguration *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"MacNeuralEngineDeviceConfiguration"];
}

@end
