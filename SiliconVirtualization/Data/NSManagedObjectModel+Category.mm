//
//  NSManagedObjectModel+Category.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "NSManagedObjectModel+Category.h"
#import "Model.h"

#warning TODO BootLoader Entities

@implementation NSManagedObjectModel (Category)

+ (NSManagedObjectModel *)sv_makeManagedObjectModel {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel new];
    
    NSEntityDescription *virtualMachineConfigurationEntity;
    {
        virtualMachineConfigurationEntity = [NSEntityDescription new];
        virtualMachineConfigurationEntity.name = @"VirtualMachineConfiguration";
        virtualMachineConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtualMachineConfiguration class]);
        
        NSAttributeDescription *CPUCountAttribute = [NSAttributeDescription new];
        CPUCountAttribute.name = @"cpuCount"; // 소문자로 시작해야함
        CPUCountAttribute.optional = YES;
        CPUCountAttribute.attributeType = NSTransformableAttributeType;
        CPUCountAttribute.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
        CPUCountAttribute.attributeValueClassName = NSStringFromClass([NSNumber class]);
        
        NSAttributeDescription *memorySizeAttribute = [NSAttributeDescription new];
        memorySizeAttribute.name = @"memorySize";
        memorySizeAttribute.optional = YES;
        memorySizeAttribute.attributeType = NSTransformableAttributeType;
        memorySizeAttribute.valueTransformerName = NSSecureUnarchiveFromDataTransformerName;
        memorySizeAttribute.attributeValueClassName = NSStringFromClass([NSNumber class]);
        
        NSAttributeDescription *timestampAttribute = [NSAttributeDescription new];
        timestampAttribute.name = @"timestamp";
        timestampAttribute.optional = YES;
        timestampAttribute.attributeType = NSDateAttributeType;
        
        virtualMachineConfigurationEntity.properties = @[
            CPUCountAttribute,
            memorySizeAttribute,
            timestampAttribute
        ];
        
        [CPUCountAttribute release];
        [memorySizeAttribute release];
        [timestampAttribute release];
    }
    
    //
    
    NSEntityDescription *macGraphicsDeviceConfigurationEntity;
    {
        macGraphicsDeviceConfigurationEntity = [NSEntityDescription new];
        macGraphicsDeviceConfigurationEntity.name = @"MacGraphicsDeviceConfiguration";
        macGraphicsDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVMacGraphicsDeviceConfiguration class]);
    }
    
    NSEntityDescription *virtioGraphicsDeviceConfigurationEntity;
    {
        virtioGraphicsDeviceConfigurationEntity = [NSEntityDescription new];
        virtioGraphicsDeviceConfigurationEntity.name = @"VirtioGraphicsDeviceConfiguration";
        virtioGraphicsDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioGraphicsDeviceConfiguration class]);
    }
    
    NSEntityDescription *graphicsDeviceConfigurationEntity;
    {
        graphicsDeviceConfigurationEntity = [NSEntityDescription new];
        graphicsDeviceConfigurationEntity.name = @"GraphicsDeviceConfiguration";
        graphicsDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVGraphicsDeviceConfiguration class]);
        graphicsDeviceConfigurationEntity.abstract = YES;
        graphicsDeviceConfigurationEntity.subentities = @[macGraphicsDeviceConfigurationEntity, virtioGraphicsDeviceConfigurationEntity];
    }
    
    //
    
    NSEntityDescription *macGraphicsDisplayConfigurationEntity;
    {
        macGraphicsDisplayConfigurationEntity = [NSEntityDescription new];
        macGraphicsDisplayConfigurationEntity.name = @"MacGraphicsDisplayConfiguration";
        macGraphicsDisplayConfigurationEntity.managedObjectClassName = NSStringFromClass([SVMacGraphicsDisplayConfiguration class]);
        
        NSAttributeDescription *heightInPixelsAttribute = [NSAttributeDescription new];
        heightInPixelsAttribute.name = @"heightInPixels";
        heightInPixelsAttribute.optional = YES;
        heightInPixelsAttribute.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *pixelsPerInchAttribute = [NSAttributeDescription new];
        pixelsPerInchAttribute.name = @"pixelsPerInch";
        pixelsPerInchAttribute.optional = YES;
        pixelsPerInchAttribute.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *widthInPixelsAttribute = [NSAttributeDescription new];
        widthInPixelsAttribute.name = @"widthInPixels";
        widthInPixelsAttribute.optional = YES;
        widthInPixelsAttribute.attributeType = NSInteger64AttributeType;
        
        macGraphicsDisplayConfigurationEntity.properties = @[
            heightInPixelsAttribute,
            pixelsPerInchAttribute,
            widthInPixelsAttribute
        ];
        
        [heightInPixelsAttribute release];
        [pixelsPerInchAttribute release];
        [widthInPixelsAttribute release];
    }
    
    NSEntityDescription *virtioGraphicsScanoutConfigurationEntity;
    {
        virtioGraphicsScanoutConfigurationEntity = [NSEntityDescription new];
        virtioGraphicsScanoutConfigurationEntity.name = @"VirtioGraphicsScanoutConfiguration";
        virtioGraphicsScanoutConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioGraphicsScanoutConfiguration class]);
        
        NSAttributeDescription *heightInPixelsAttribute = [NSAttributeDescription new];
        heightInPixelsAttribute.name = @"heightInPixels";
        heightInPixelsAttribute.optional = YES;
        heightInPixelsAttribute.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *widthInPixelsAttribute = [NSAttributeDescription new];
        widthInPixelsAttribute.name = @"widthInPixels";
        widthInPixelsAttribute.optional = YES;
        widthInPixelsAttribute.attributeType = NSInteger64AttributeType;
        
        virtioGraphicsScanoutConfigurationEntity.properties = @[
            heightInPixelsAttribute,
            widthInPixelsAttribute
        ];
        
        [heightInPixelsAttribute release];
        [widthInPixelsAttribute release];
    }
    
    NSEntityDescription *graphicsDisplayConfigurationEntity;
    {
        graphicsDisplayConfigurationEntity = [NSEntityDescription new];
        graphicsDisplayConfigurationEntity.name = @"GraphicsDisplayConfiguration";
        graphicsDisplayConfigurationEntity.managedObjectClassName = NSStringFromClass([SVGraphicsDisplayConfiguration class]);
        
        graphicsDisplayConfigurationEntity.abstract = YES;
        graphicsDisplayConfigurationEntity.subentities = @[
            macGraphicsDisplayConfigurationEntity,
            virtioGraphicsScanoutConfigurationEntity
        ];
    }
    
    //
    
    NSEntityDescription *virtioBlockDeviceConfigurationEntity;
    {
        virtioBlockDeviceConfigurationEntity = [NSEntityDescription new];
        virtioBlockDeviceConfigurationEntity.name = @"VirtioBlockDeviceConfiguration";
        virtioBlockDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioBlockDeviceConfiguration class]);
    }
    
    NSEntityDescription *storageDeviceConfigurationEntity;
    {
        storageDeviceConfigurationEntity = [NSEntityDescription new];
        storageDeviceConfigurationEntity.name = @"StorageDeviceConfiguration";
        storageDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVStorageDeviceConfiguration class]);
        storageDeviceConfigurationEntity.abstract = YES;
        storageDeviceConfigurationEntity.subentities = @[virtioBlockDeviceConfigurationEntity];
    }
    
    NSEntityDescription *diskImageStorageDeviceAttachmentEntity;
    {
        diskImageStorageDeviceAttachmentEntity = [NSEntityDescription new];
        diskImageStorageDeviceAttachmentEntity.name = @"DiskImageStorageDeviceAttachment";
        diskImageStorageDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVDiskImageStorageDeviceAttachment class]);
        
        NSAttributeDescription *bookmarkDataAttribute = [NSAttributeDescription new];
        bookmarkDataAttribute.name = @"bookmarkData";
        bookmarkDataAttribute.optional = YES;
        bookmarkDataAttribute.attributeType = NSBinaryDataAttributeType;
        
        NSAttributeDescription *cachingModeAttribute = [NSAttributeDescription new];
        cachingModeAttribute.name = @"cachingMode";
        cachingModeAttribute.optional = YES;
        cachingModeAttribute.attributeType = NSInteger64AttributeType;
        
        NSAttributeDescription *readOnlyAttribute = [NSAttributeDescription new];
        readOnlyAttribute.name = @"readOnly";
        readOnlyAttribute.optional = YES;
        readOnlyAttribute.attributeType = NSBooleanAttributeType;
        
        NSAttributeDescription *synchronizationModeAttribute = [NSAttributeDescription new];
        synchronizationModeAttribute.name = @"synchronizationMode";
        synchronizationModeAttribute.optional = YES;
        synchronizationModeAttribute.attributeType = NSInteger64AttributeType;
        
        diskImageStorageDeviceAttachmentEntity.properties = @[
            bookmarkDataAttribute,
            cachingModeAttribute,
            readOnlyAttribute,
            synchronizationModeAttribute
        ];
        
        [bookmarkDataAttribute release];
        [cachingModeAttribute release];
        [readOnlyAttribute release];
        [synchronizationModeAttribute release];
    }
    
    NSEntityDescription *storageDeviceAttachmentEntity;
    {
        storageDeviceAttachmentEntity = [NSEntityDescription new];
        storageDeviceAttachmentEntity.name = @"StorageDeviceAttachment";
        storageDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVStorageDeviceAttachment class]);
        storageDeviceAttachmentEntity.abstract = YES;
        storageDeviceAttachmentEntity.subentities = @[diskImageStorageDeviceAttachmentEntity];
    }
    
    //
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_graphicsDevices_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_graphicsDevices_relationship.name = @"graphicsDevices";
        virtualMachineConfiguration_graphicsDevices_relationship.optional = YES;
        virtualMachineConfiguration_graphicsDevices_relationship.minCount = 0;
        virtualMachineConfiguration_graphicsDevices_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_graphicsDevices_relationship.toMany);
        virtualMachineConfiguration_graphicsDevices_relationship.ordered = YES;
        virtualMachineConfiguration_graphicsDevices_relationship.destinationEntity = graphicsDeviceConfigurationEntity;
        virtualMachineConfiguration_graphicsDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *graphicsDeviceConfiguration_machine_relationship = [NSRelationshipDescription new];
        graphicsDeviceConfiguration_machine_relationship.name = @"machine";
        graphicsDeviceConfiguration_machine_relationship.optional = YES;
        graphicsDeviceConfiguration_machine_relationship.minCount = 0;
        graphicsDeviceConfiguration_machine_relationship.maxCount = 1;
        assert(!graphicsDeviceConfiguration_machine_relationship.toMany);
        graphicsDeviceConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        graphicsDeviceConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_graphicsDevices_relationship.inverseRelationship = graphicsDeviceConfiguration_machine_relationship;
        graphicsDeviceConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_graphicsDevices_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_graphicsDevices_relationship];
        graphicsDeviceConfigurationEntity.properties = [graphicsDeviceConfigurationEntity.properties arrayByAddingObject:graphicsDeviceConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_graphicsDevices_relationship release];
        [graphicsDeviceConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_storageDevices_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_storageDevices_relationship.name = @"storageDevices";
        virtualMachineConfiguration_storageDevices_relationship.optional = YES;
        virtualMachineConfiguration_storageDevices_relationship.minCount = 0;
        virtualMachineConfiguration_storageDevices_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_storageDevices_relationship.toMany);
        virtualMachineConfiguration_storageDevices_relationship.ordered = YES;
        virtualMachineConfiguration_storageDevices_relationship.destinationEntity = storageDeviceConfigurationEntity;
        virtualMachineConfiguration_storageDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *storageDeviceConfiguration_machine_relationship = [NSRelationshipDescription new];
        storageDeviceConfiguration_machine_relationship.name = @"machine";
        storageDeviceConfiguration_machine_relationship.optional = YES;
        storageDeviceConfiguration_machine_relationship.minCount = 0;
        storageDeviceConfiguration_machine_relationship.maxCount = 1;
        assert(!storageDeviceConfiguration_machine_relationship.toMany);
        storageDeviceConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        storageDeviceConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_storageDevices_relationship.inverseRelationship = storageDeviceConfiguration_machine_relationship;
        storageDeviceConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_storageDevices_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_storageDevices_relationship];
        storageDeviceConfigurationEntity.properties = [storageDeviceConfigurationEntity.properties arrayByAddingObject:storageDeviceConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_storageDevices_relationship release];
        [storageDeviceConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *macGraphicsDeviceConfiguration_displays_relationship = [NSRelationshipDescription new];
        macGraphicsDeviceConfiguration_displays_relationship.name = @"displays";
        macGraphicsDeviceConfiguration_displays_relationship.optional = YES;
        macGraphicsDeviceConfiguration_displays_relationship.minCount = 0;
        macGraphicsDeviceConfiguration_displays_relationship.maxCount = 0;
        assert(macGraphicsDeviceConfiguration_displays_relationship.toMany);
        macGraphicsDeviceConfiguration_displays_relationship.ordered = YES;
        macGraphicsDeviceConfiguration_displays_relationship.destinationEntity = macGraphicsDisplayConfigurationEntity;
        macGraphicsDeviceConfiguration_displays_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *macGraphicsDisplayConfiguration_graphicsDevice_relationship = [NSRelationshipDescription new];
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.name = @"graphicsDevice";
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.optional = YES;
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.minCount = 0;
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.maxCount = 1;
        assert(!macGraphicsDisplayConfiguration_graphicsDevice_relationship.toMany);
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.destinationEntity = macGraphicsDeviceConfigurationEntity;
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        macGraphicsDeviceConfiguration_displays_relationship.inverseRelationship = macGraphicsDisplayConfiguration_graphicsDevice_relationship;
        macGraphicsDisplayConfiguration_graphicsDevice_relationship.inverseRelationship = macGraphicsDeviceConfiguration_displays_relationship;
        
        macGraphicsDeviceConfigurationEntity.properties = [macGraphicsDeviceConfigurationEntity.properties arrayByAddingObject:macGraphicsDeviceConfiguration_displays_relationship];
        macGraphicsDisplayConfigurationEntity.properties = [macGraphicsDisplayConfigurationEntity.properties arrayByAddingObject:macGraphicsDisplayConfiguration_graphicsDevice_relationship];
        
        [macGraphicsDeviceConfiguration_displays_relationship release];
        [macGraphicsDisplayConfiguration_graphicsDevice_relationship release];
    }
    
    {
        NSRelationshipDescription *virtioGraphicsDeviceConfiguration_scanouts_relationship = [NSRelationshipDescription new];
        virtioGraphicsDeviceConfiguration_scanouts_relationship.name = @"scanouts";
        virtioGraphicsDeviceConfiguration_scanouts_relationship.optional = YES;
        virtioGraphicsDeviceConfiguration_scanouts_relationship.minCount = 0;
        virtioGraphicsDeviceConfiguration_scanouts_relationship.maxCount = 0;
        assert(virtioGraphicsDeviceConfiguration_scanouts_relationship.toMany);
        virtioGraphicsDeviceConfiguration_scanouts_relationship.ordered = YES;
        virtioGraphicsDeviceConfiguration_scanouts_relationship.destinationEntity = virtioGraphicsScanoutConfigurationEntity;
        virtioGraphicsDeviceConfiguration_scanouts_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *virtioGraphicsScanoutConfiguration_graphicsDevice_relationship = [NSRelationshipDescription new];
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.name = @"graphicsDevice";
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.optional = YES;
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.minCount = 0;
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.maxCount = 1;
        assert(!virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.toMany);
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.destinationEntity = virtioGraphicsDeviceConfigurationEntity;
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtioGraphicsDeviceConfiguration_scanouts_relationship.inverseRelationship = virtioGraphicsScanoutConfiguration_graphicsDevice_relationship;
        virtioGraphicsScanoutConfiguration_graphicsDevice_relationship.inverseRelationship = virtioGraphicsDeviceConfiguration_scanouts_relationship;
        
        virtioGraphicsDeviceConfigurationEntity.properties = [virtioGraphicsDeviceConfigurationEntity.properties arrayByAddingObject:virtioGraphicsDeviceConfiguration_scanouts_relationship];
        virtioGraphicsScanoutConfigurationEntity.properties = [virtioGraphicsScanoutConfigurationEntity.properties arrayByAddingObject:virtioGraphicsScanoutConfiguration_graphicsDevice_relationship];
        
        [virtioGraphicsDeviceConfiguration_scanouts_relationship release];
        [virtioGraphicsScanoutConfiguration_graphicsDevice_relationship release];
    }
    
    {
        NSRelationshipDescription *storageDeviceConfiguration_attachment_relationship = [NSRelationshipDescription new];
        storageDeviceConfiguration_attachment_relationship.name = @"attachment";
        storageDeviceConfiguration_attachment_relationship.optional = YES;
        storageDeviceConfiguration_attachment_relationship.minCount = 0;
        storageDeviceConfiguration_attachment_relationship.maxCount = 1;
        assert(!storageDeviceConfiguration_attachment_relationship.toMany);
        storageDeviceConfiguration_attachment_relationship.destinationEntity = storageDeviceAttachmentEntity;
        storageDeviceConfiguration_attachment_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *storageDeviceAttachment_storageDevice_relationship = [NSRelationshipDescription new];
        storageDeviceAttachment_storageDevice_relationship.name = @"storageDevice";
        storageDeviceAttachment_storageDevice_relationship.optional = YES;
        storageDeviceAttachment_storageDevice_relationship.minCount = 0;
        storageDeviceAttachment_storageDevice_relationship.maxCount = 1;
        assert(!storageDeviceAttachment_storageDevice_relationship.toMany);
        storageDeviceAttachment_storageDevice_relationship.destinationEntity = storageDeviceConfigurationEntity;
        storageDeviceAttachment_storageDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        storageDeviceConfiguration_attachment_relationship.inverseRelationship = storageDeviceAttachment_storageDevice_relationship;
        storageDeviceAttachment_storageDevice_relationship.inverseRelationship = storageDeviceConfiguration_attachment_relationship;
        
        storageDeviceConfigurationEntity.properties = [storageDeviceConfigurationEntity.properties arrayByAddingObject:storageDeviceConfiguration_attachment_relationship];
        storageDeviceAttachmentEntity.properties = [storageDeviceAttachmentEntity.properties arrayByAddingObject:storageDeviceAttachment_storageDevice_relationship];
        
        [storageDeviceConfiguration_attachment_relationship release];
        [storageDeviceAttachment_storageDevice_relationship release];
    }
    
    //
    
    managedObjectModel.entities = @[
        virtualMachineConfigurationEntity,
        macGraphicsDeviceConfigurationEntity,
        virtioGraphicsDeviceConfigurationEntity,
        graphicsDeviceConfigurationEntity,
        macGraphicsDisplayConfigurationEntity,
        virtioGraphicsScanoutConfigurationEntity,
        graphicsDisplayConfigurationEntity,
        virtioBlockDeviceConfigurationEntity,
        storageDeviceConfigurationEntity,
        diskImageStorageDeviceAttachmentEntity,
        storageDeviceAttachmentEntity
    ];
    
    [virtualMachineConfigurationEntity release];
    [macGraphicsDeviceConfigurationEntity release];
    [virtioGraphicsDeviceConfigurationEntity release];
    [graphicsDeviceConfigurationEntity release];
    [macGraphicsDisplayConfigurationEntity release];
    [virtioGraphicsScanoutConfigurationEntity release];
    [graphicsDisplayConfigurationEntity release];
    [virtioBlockDeviceConfigurationEntity release];
    [storageDeviceConfigurationEntity release];
    [diskImageStorageDeviceAttachmentEntity release];
    [storageDeviceAttachmentEntity release];
    
    return [managedObjectModel autorelease];
}

@end
