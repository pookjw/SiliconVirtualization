//
//  NSManagedObjectModel+Category.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "NSManagedObjectModel+Category.h"

@implementation NSManagedObjectModel (Category)

+ (NSManagedObjectModel *)sv_managedObjectModel {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel new];
    
    NSEntityDescription *virtualMachineConfigurationEntity;
    {
        virtualMachineConfigurationEntity = [NSEntityDescription new];
        virtualMachineConfigurationEntity.name = @"VirtualMachineConfiguration";
        
        NSAttributeDescription *CPUCountAttributeDescription = [NSAttributeDescription new];
        CPUCountAttributeDescription.name = @"cpuCount"; // 소문자로 시작해야함
        CPUCountAttributeDescription.optional = YES;
        CPUCountAttributeDescription.attributeType = NSTransformableAttributeType;
        CPUCountAttributeDescription.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
        CPUCountAttributeDescription.attributeValueClassName = NSStringFromClass([NSNumber class]);
        
        NSAttributeDescription *memorySizeAttributeDescription = [NSAttributeDescription new];
        memorySizeAttributeDescription.name = @"memorySize";
        memorySizeAttributeDescription.optional = YES;
        memorySizeAttributeDescription.attributeType = NSTransformableAttributeType;
        memorySizeAttributeDescription.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
        memorySizeAttributeDescription.attributeValueClassName = NSStringFromClass([NSNumber class]);
        
        NSCompositeAttributeDescription *graphicsDevicesAttributeDescription = [NSCompositeAttributeDescription new];
        graphicsDevicesAttributeDescription.name = @"graphicsDevices";
        graphicsDevicesAttributeDescription.optional = YES;
        graphicsDevicesAttributeDescription.elements = @[
            
        ];
        
        virtualMachineConfigurationEntity.properties = @[
            CPUCountAttributeDescription,
            memorySizeAttributeDescription,
            graphicsDevicesAttributeDescription
        ];
        
        [CPUCountAttributeDescription release];
        [memorySizeAttributeDescription release];
        [graphicsDevicesAttributeDescription release];
    }
    
    managedObjectModel.entities = @[
        virtualMachineConfigurationEntity
    ];
    [virtualMachineConfigurationEntity release];
    
    return [managedObjectModel autorelease];
}

@end
