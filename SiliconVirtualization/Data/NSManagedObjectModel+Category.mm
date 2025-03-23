//
//  NSManagedObjectModel+Category.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import "NSManagedObjectModel+Category.h"
#import "Model.h"

@implementation NSManagedObjectModel (Category)

+ (NSManagedObjectModel *)sv_makeManagedObjectModel {
    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel new];
    
    NSEntityDescription *virtualMachineEntity;
    {
        virtualMachineEntity = [NSEntityDescription new];
        virtualMachineEntity.name = @"VirtualMachine";
        virtualMachineEntity.managedObjectClassName = NSStringFromClass([SVVirtualMachine class]);
        
        NSAttributeDescription *timestampAttribute = [NSAttributeDescription new];
        timestampAttribute.name = @"timestamp";
        timestampAttribute.optional = YES;
        timestampAttribute.attributeType = NSDateAttributeType;
        
        virtualMachineEntity.properties = @[
            timestampAttribute
        ];
        
        [timestampAttribute release];
    }
    
    NSEntityDescription *macOSVirtualMachineStartOptionsEntity;
    {
        macOSVirtualMachineStartOptionsEntity = [NSEntityDescription new];
        macOSVirtualMachineStartOptionsEntity.name = @"MacOSVirtualMachineStartOptions";
        macOSVirtualMachineStartOptionsEntity.managedObjectClassName = NSStringFromClass([SVMacOSVirtualMachineStartOptions class]);
        
        NSAttributeDescription *startUpFromMacOSRecoveryAttribute = [NSAttributeDescription new];
        startUpFromMacOSRecoveryAttribute.name = @"startUpFromMacOSRecovery";
        startUpFromMacOSRecoveryAttribute.optional = YES;
        startUpFromMacOSRecoveryAttribute.attributeType = NSBooleanAttributeType;
        
        macOSVirtualMachineStartOptionsEntity.properties = @[
            startUpFromMacOSRecoveryAttribute
        ];
        
        [startUpFromMacOSRecoveryAttribute release];
    }
    
    NSEntityDescription *virtualMachineStartOptionsEntity;
    {
        virtualMachineStartOptionsEntity = [NSEntityDescription new];
        virtualMachineStartOptionsEntity.name = @"VirtualMachineStartOptions";
        virtualMachineStartOptionsEntity.managedObjectClassName = NSStringFromClass([SVVirtualMachineStartOptions class]);
        
        virtualMachineStartOptionsEntity.abstract = YES;
        virtualMachineStartOptionsEntity.subentities = @[
            macOSVirtualMachineStartOptionsEntity
        ];
    }
    
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
        
        virtualMachineConfigurationEntity.properties = @[
            CPUCountAttribute,
            memorySizeAttribute
        ];
        
        [CPUCountAttribute release];
        [memorySizeAttribute release];
    }
    
    //
    
    NSEntityDescription *macOSBootLoaderEntity;
    {
        macOSBootLoaderEntity = [NSEntityDescription new];
        macOSBootLoaderEntity.name = @"MacOSBootLoader";
        macOSBootLoaderEntity.managedObjectClassName = NSStringFromClass([SVMacOSBootLoader class]);
    }
    
    NSEntityDescription *bootLoaderEntity;
    {
        bootLoaderEntity = [NSEntityDescription new];
        bootLoaderEntity.name = @"BootLoader";
        bootLoaderEntity.managedObjectClassName = NSStringFromClass([SVBootLoader class]);
        bootLoaderEntity.abstract = YES;
        bootLoaderEntity.subentities = @[macOSBootLoaderEntity];
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
    
    NSEntityDescription *USBMassStorageDeviceConfigurationEntity;
    {
        USBMassStorageDeviceConfigurationEntity = [NSEntityDescription new];
        USBMassStorageDeviceConfigurationEntity.name = @"USBMassStorageDeviceConfiguration";
        USBMassStorageDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVUSBMassStorageDeviceConfiguration class]);
    }
    
    NSEntityDescription *storageDeviceConfigurationEntity;
    {
        storageDeviceConfigurationEntity = [NSEntityDescription new];
        storageDeviceConfigurationEntity.name = @"StorageDeviceConfiguration";
        storageDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVStorageDeviceConfiguration class]);
        storageDeviceConfigurationEntity.abstract = YES;
        storageDeviceConfigurationEntity.subentities = @[
            virtioBlockDeviceConfigurationEntity,
            USBMassStorageDeviceConfigurationEntity
        ];
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
    
    NSEntityDescription *diskBlockDeviceStorageDeviceAttachmentEntity;
    {
        diskBlockDeviceStorageDeviceAttachmentEntity = [NSEntityDescription new];
        diskBlockDeviceStorageDeviceAttachmentEntity.name = @"DiskBlockDeviceStorageDeviceAttachment";
        diskBlockDeviceStorageDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVDiskBlockDeviceStorageDeviceAttachment class]);
        
        NSAttributeDescription *fileDescriptorAttribute = [NSAttributeDescription new];
        fileDescriptorAttribute.name = @"fileDescriptor";
        fileDescriptorAttribute.optional = YES;
        fileDescriptorAttribute.attributeType = NSInteger32AttributeType;
        
        NSAttributeDescription *readOnlyAttribute = [NSAttributeDescription new];
        readOnlyAttribute.name = @"readOnly";
        readOnlyAttribute.optional = YES;
        readOnlyAttribute.attributeType = NSBooleanAttributeType;
        
        NSAttributeDescription *synchronizationModeAttribute = [NSAttributeDescription new];
        synchronizationModeAttribute.name = @"synchronizationMode";
        synchronizationModeAttribute.optional = YES;
        synchronizationModeAttribute.attributeType = NSInteger64AttributeType;
        
        diskBlockDeviceStorageDeviceAttachmentEntity.properties = @[
            fileDescriptorAttribute,
            readOnlyAttribute,
            synchronizationModeAttribute
        ];
        
        [fileDescriptorAttribute release];
        [readOnlyAttribute release];
        [synchronizationModeAttribute release];
    }
    
    NSEntityDescription *storageDeviceAttachmentEntity;
    {
        storageDeviceAttachmentEntity = [NSEntityDescription new];
        storageDeviceAttachmentEntity.name = @"StorageDeviceAttachment";
        storageDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVStorageDeviceAttachment class]);
        
        storageDeviceAttachmentEntity.abstract = YES;
        storageDeviceAttachmentEntity.subentities = @[
            diskImageStorageDeviceAttachmentEntity,
            diskBlockDeviceStorageDeviceAttachmentEntity
        ];
    }
    
    NSEntityDescription *macAuxiliaryStorageEntity;
    {
        macAuxiliaryStorageEntity = [NSEntityDescription new];
        macAuxiliaryStorageEntity.name = @"MacAuxiliaryStorage";
        macAuxiliaryStorageEntity.managedObjectClassName = NSStringFromClass([SVMacAuxiliaryStorage class]);
        
        NSAttributeDescription *bookmarkDataAttribute = [NSAttributeDescription new];
        bookmarkDataAttribute.name = @"bookmarkData";
        bookmarkDataAttribute.optional = YES;
        bookmarkDataAttribute.attributeType = NSBinaryDataAttributeType;
        
        macAuxiliaryStorageEntity.properties = @[bookmarkDataAttribute];
        [bookmarkDataAttribute release];
    }
    
    NSEntityDescription *macHardwareModelEntity;
    {
        macHardwareModelEntity = [NSEntityDescription new];
        macHardwareModelEntity.name = @"MacHardwareModel";
        macHardwareModelEntity.managedObjectClassName = NSStringFromClass([SVMacHardwareModel class]);
        
        NSAttributeDescription *dataRepresentationAttribute = [NSAttributeDescription new];
        dataRepresentationAttribute.name = @"dataRepresentation";
        dataRepresentationAttribute.optional = YES;
        dataRepresentationAttribute.attributeType = NSBinaryDataAttributeType;
        
        macHardwareModelEntity.properties = @[dataRepresentationAttribute];
        [dataRepresentationAttribute release];
    }
    
    NSEntityDescription *macMachineIdentifierEntity;
    {
        macMachineIdentifierEntity = [NSEntityDescription new];
        macMachineIdentifierEntity.name = @"MacMachineIdentifier";
        macMachineIdentifierEntity.managedObjectClassName = NSStringFromClass([SVMacMachineIdentifier class]);
        
        NSAttributeDescription *dataRepresentationAttribute = [NSAttributeDescription new];
        dataRepresentationAttribute.name = @"dataRepresentation";
        dataRepresentationAttribute.optional = YES;
        dataRepresentationAttribute.attributeType = NSBinaryDataAttributeType;
        
        macMachineIdentifierEntity.properties = @[dataRepresentationAttribute];
        [dataRepresentationAttribute release];
    }
    
    NSEntityDescription *macPlatformConfigurationEntity;
    {
        macPlatformConfigurationEntity = [NSEntityDescription new];
        macPlatformConfigurationEntity.name = @"MacPlatformConfiguration";
        macPlatformConfigurationEntity.managedObjectClassName = NSStringFromClass([SVMacPlatformConfiguration class]);
    }
    
    NSEntityDescription *genericPlatformConfigurationEntity;
    {
        genericPlatformConfigurationEntity = [NSEntityDescription new];
        genericPlatformConfigurationEntity.name = @"GenericPlatformConfiguration";
        genericPlatformConfigurationEntity.managedObjectClassName = NSStringFromClass([SVGenericPlatformConfiguration class]);
        
        NSAttributeDescription *nestedVirtualizationEnabledAttribute = [NSAttributeDescription new];
        nestedVirtualizationEnabledAttribute.name = @"nestedVirtualizationEnabled";
        nestedVirtualizationEnabledAttribute.optional = YES;
        nestedVirtualizationEnabledAttribute.attributeType = NSBooleanAttributeType;
        
        genericPlatformConfigurationEntity.properties = @[nestedVirtualizationEnabledAttribute];
        [nestedVirtualizationEnabledAttribute release];
    }
    
    NSEntityDescription *platformConfigurationEntity;
    {
        platformConfigurationEntity = [NSEntityDescription new];
        platformConfigurationEntity.name = @"PlatformConfiguration";
        platformConfigurationEntity.managedObjectClassName = NSStringFromClass([SVPlatformConfiguration class]);
        platformConfigurationEntity.abstract = YES;
        platformConfigurationEntity.subentities = @[macPlatformConfigurationEntity, genericPlatformConfigurationEntity];
    }
    
    NSEntityDescription *genericMachineIdentifierEntity;
    {
        genericMachineIdentifierEntity = [NSEntityDescription new];
        genericMachineIdentifierEntity.name = @"GenericMachineIdentifier";
        genericMachineIdentifierEntity.managedObjectClassName = NSStringFromClass([SVGenericMachineIdentifier class]);
        
        NSAttributeDescription *dataRepresentationAttribute = [NSAttributeDescription new];
        dataRepresentationAttribute.name = @"dataRepresentation";
        dataRepresentationAttribute.optional = YES;
        dataRepresentationAttribute.attributeType = NSBinaryDataAttributeType;
        
        genericMachineIdentifierEntity.properties = @[dataRepresentationAttribute];
        [dataRepresentationAttribute release];
    }
    
    NSEntityDescription *usbKeyboardConfigurationEntity;
    {
        usbKeyboardConfigurationEntity = [NSEntityDescription new];
        usbKeyboardConfigurationEntity.name = @"USBKeyboardConfiguration";
        usbKeyboardConfigurationEntity.managedObjectClassName = NSStringFromClass([SVUSBKeyboardConfiguration class]);
    }
    
    NSEntityDescription *macKeyboardConfigurationEntity;
    {
        macKeyboardConfigurationEntity = [NSEntityDescription new];
        macKeyboardConfigurationEntity.name = @"MacKeyboardConfiguration";
        macKeyboardConfigurationEntity.managedObjectClassName = NSStringFromClass([SVMacKeyboardConfiguration class]);
    }
    
    NSEntityDescription *keyboardConfigurationEntity;
    {
        keyboardConfigurationEntity = [NSEntityDescription new];
        keyboardConfigurationEntity.name = @"KeyboardConfiguration";
        keyboardConfigurationEntity.managedObjectClassName = NSStringFromClass([SVKeyboardConfiguration class]);
        keyboardConfigurationEntity.abstract = YES;
        keyboardConfigurationEntity.subentities = @[usbKeyboardConfigurationEntity ,macKeyboardConfigurationEntity];
    }
    
    NSEntityDescription *USBScreenCoordinatePointingDeviceConfigurationEntity;
    {
        USBScreenCoordinatePointingDeviceConfigurationEntity = [NSEntityDescription new];
        USBScreenCoordinatePointingDeviceConfigurationEntity.name = @"USBScreenCoordinatePointingDeviceConfiguration";
        USBScreenCoordinatePointingDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVUSBScreenCoordinatePointingDeviceConfiguration class]);
    }
    
    NSEntityDescription *macTrackpadConfigurationEntity;
    {
        macTrackpadConfigurationEntity = [NSEntityDescription new];
        macTrackpadConfigurationEntity.name = @"MacTrackpadConfiguration";
        macTrackpadConfigurationEntity.managedObjectClassName = NSStringFromClass([SVMacTrackpadConfiguration class]);
    }
    
    NSEntityDescription *pointingDeviceConfigurationEntity;
    {
        pointingDeviceConfigurationEntity = [NSEntityDescription new];
        pointingDeviceConfigurationEntity.name = @"PointingDeviceConfiguration";
        pointingDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVPointingDeviceConfiguration class]);
        pointingDeviceConfigurationEntity.abstract = YES;
        pointingDeviceConfigurationEntity.subentities = @[USBScreenCoordinatePointingDeviceConfigurationEntity, macTrackpadConfigurationEntity];
    }
    
    NSEntityDescription *virtioNetworkDeviceConfigurationEntity;
    {
        virtioNetworkDeviceConfigurationEntity = [NSEntityDescription new];
        virtioNetworkDeviceConfigurationEntity.name = @"VirtioNetworkDeviceConfiguration";
        virtioNetworkDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioNetworkDeviceConfiguration class]);
    }
    
    NSEntityDescription *networkDeviceConfigurationEntity;
    {
        networkDeviceConfigurationEntity = [NSEntityDescription new];
        networkDeviceConfigurationEntity.name = @"NetworkDeviceConfiguration";
        networkDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVNetworkDeviceConfiguration class]);
        
        networkDeviceConfigurationEntity.abstract = YES;
        networkDeviceConfigurationEntity.subentities = @[virtioNetworkDeviceConfigurationEntity];
    }
    
    NSEntityDescription *NATNetworkDeviceAttachmentEntity;
    {
        NATNetworkDeviceAttachmentEntity = [NSEntityDescription new];
        NATNetworkDeviceAttachmentEntity.name = @"NATNetworkDeviceAttachment";
        NATNetworkDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVNATNetworkDeviceAttachment class]);
    }
    
    NSEntityDescription *networkDeviceAttachmentEntity;
    {
        networkDeviceAttachmentEntity = [NSEntityDescription new];
        networkDeviceAttachmentEntity.name = @"NetworkDeviceAttachment";
        networkDeviceAttachmentEntity.managedObjectClassName = NSStringFromClass([SVNetworkDeviceAttachment class]);
        
        networkDeviceAttachmentEntity.abstract = YES;
        networkDeviceAttachmentEntity.subentities = @[NATNetworkDeviceAttachmentEntity];
    }
    
    NSEntityDescription *MACAddressEntity;
    {
        MACAddressEntity = [NSEntityDescription new];
        MACAddressEntity.name = @"MACAddress";
        MACAddressEntity.managedObjectClassName = NSStringFromClass([SVMACAddress class]);
        
        NSAttributeDescription *ethernetAddressAttribute = [NSAttributeDescription new];
        ethernetAddressAttribute.name = @"ethernetAddress";
        ethernetAddressAttribute.optional = YES;
        ethernetAddressAttribute.attributeType = NSBinaryDataAttributeType;
        
        MACAddressEntity.properties = @[ethernetAddressAttribute];
        [ethernetAddressAttribute release];
    }
    
    NSEntityDescription *virtioSoundDeviceConfigurationEntity;
    {
        virtioSoundDeviceConfigurationEntity = [NSEntityDescription new];
        virtioSoundDeviceConfigurationEntity.name = @"VirtioSoundDeviceConfiguration";
        virtioSoundDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioSoundDeviceConfiguration class]);
    }
    
    NSEntityDescription *audioDeviceConfigurationEntity;
    {
        audioDeviceConfigurationEntity = [NSEntityDescription new];
        audioDeviceConfigurationEntity.name = @"AudioDeviceConfiguration";
        audioDeviceConfigurationEntity.managedObjectClassName = NSStringFromClass([SVAudioDeviceConfiguration class]);
        
        audioDeviceConfigurationEntity.abstract = YES;
        audioDeviceConfigurationEntity.subentities = @[virtioSoundDeviceConfigurationEntity];
    }
    
    NSEntityDescription *virtioSoundDeviceOutputStreamConfigurationEntity;
    {
        virtioSoundDeviceOutputStreamConfigurationEntity = [NSEntityDescription new];
        virtioSoundDeviceOutputStreamConfigurationEntity.name = @"VirtioSoundDeviceOutputStreamConfiguration";
        virtioSoundDeviceOutputStreamConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioSoundDeviceOutputStreamConfiguration class]);
    }
    
    NSEntityDescription *virtioSoundDeviceInputStreamConfigurationEntity;
    {
        virtioSoundDeviceInputStreamConfigurationEntity = [NSEntityDescription new];
        virtioSoundDeviceInputStreamConfigurationEntity.name = @"VirtioSoundDeviceInputStreamConfiguration";
        virtioSoundDeviceInputStreamConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioSoundDeviceInputStreamConfiguration class]);
    }
    
    NSEntityDescription *virtioSoundDeviceStreamConfigurationEntity;
    {
        virtioSoundDeviceStreamConfigurationEntity = [NSEntityDescription new];
        virtioSoundDeviceStreamConfigurationEntity.name = @"VirtioSoundDeviceStreamConfiguration";
        virtioSoundDeviceStreamConfigurationEntity.managedObjectClassName = NSStringFromClass([SVVirtioSoundDeviceStreamConfiguration class]);
        
        virtioSoundDeviceStreamConfigurationEntity.abstract = YES;
        virtioSoundDeviceStreamConfigurationEntity.subentities = @[
            virtioSoundDeviceOutputStreamConfigurationEntity,
            virtioSoundDeviceInputStreamConfigurationEntity
        ];
    }
    
    NSEntityDescription *hostAudioInputStreamSourceEntity;
    {
        hostAudioInputStreamSourceEntity = [NSEntityDescription new];
        hostAudioInputStreamSourceEntity.name = @"HostAudioInputStreamSource";
        hostAudioInputStreamSourceEntity.managedObjectClassName = NSStringFromClass([SVHostAudioInputStreamSource class]);
    }
    
    NSEntityDescription *audioInputStreamSourceEntity;
    {
        audioInputStreamSourceEntity = [NSEntityDescription new];
        audioInputStreamSourceEntity.name = @"AudioInputStreamSource";
        audioInputStreamSourceEntity.managedObjectClassName = NSStringFromClass([SVAudioInputStreamSource class]);
        
        audioInputStreamSourceEntity.abstract = YES;
        audioInputStreamSourceEntity.subentities = @[hostAudioInputStreamSourceEntity];
    }
    
    NSEntityDescription *hostAudioOutputStreamSinkEntity;
    {
        hostAudioOutputStreamSinkEntity = [NSEntityDescription new];
        hostAudioOutputStreamSinkEntity.name = @"HostAudioOutputStreamSink";
        hostAudioOutputStreamSinkEntity.managedObjectClassName = NSStringFromClass([SVHostAudioOutputStreamSink class]);
    }
    
    NSEntityDescription *audioOutputStreamSinkEntity;
    {
        audioOutputStreamSinkEntity = [NSEntityDescription new];
        audioOutputStreamSinkEntity.name = @"AudioOutputStreamSink";
        audioOutputStreamSinkEntity.managedObjectClassName = NSStringFromClass([SVAudioOutputStreamSink class]);
        
        audioOutputStreamSinkEntity.abstract = YES;
        audioOutputStreamSinkEntity.subentities = @[hostAudioOutputStreamSinkEntity];
    }
    
    NSEntityDescription *XHCIControllerConfigurationEntity;
    {
        XHCIControllerConfigurationEntity = [NSEntityDescription new];
        XHCIControllerConfigurationEntity.name = @"XHCIControllerConfiguration";
        XHCIControllerConfigurationEntity.managedObjectClassName = NSStringFromClass([SVXHCIControllerConfiguration class]);
    }
    
    NSEntityDescription *USBControllerConfigurationEntity;
    {
        USBControllerConfigurationEntity = [NSEntityDescription new];
        USBControllerConfigurationEntity.name = @"USBControllerConfiguration";
        USBControllerConfigurationEntity.managedObjectClassName = NSStringFromClass([SVUSBControllerConfiguration class]);
        
        USBControllerConfigurationEntity.abstract = YES;
        USBControllerConfigurationEntity.subentities = @[XHCIControllerConfigurationEntity];
    }
    
    //
    
    {
        NSRelationshipDescription *virtualMachine_configuration_relationship = [NSRelationshipDescription new];
        virtualMachine_configuration_relationship.name = @"configuration";
        virtualMachine_configuration_relationship.optional = YES;
        virtualMachine_configuration_relationship.minCount = 0;
        virtualMachine_configuration_relationship.maxCount = 1;
        assert(!virtualMachine_configuration_relationship.toMany);
        virtualMachine_configuration_relationship.destinationEntity = virtualMachineConfigurationEntity;
        virtualMachine_configuration_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *virtualMachineConfiguration_machine_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_machine_relationship.name = @"machine";
        virtualMachineConfiguration_machine_relationship.optional = YES;
        virtualMachineConfiguration_machine_relationship.minCount = 0;
        virtualMachineConfiguration_machine_relationship.maxCount = 1;
        assert(!virtualMachineConfiguration_machine_relationship.toMany);
        virtualMachineConfiguration_machine_relationship.destinationEntity = virtualMachineEntity;
        virtualMachineConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachine_configuration_relationship.inverseRelationship = virtualMachineConfiguration_machine_relationship;
        virtualMachineConfiguration_machine_relationship.inverseRelationship = virtualMachine_configuration_relationship;
        
        virtualMachineEntity.properties = [virtualMachineEntity.properties arrayByAddingObject:virtualMachine_configuration_relationship];
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_machine_relationship];
        
        [virtualMachine_configuration_relationship release];
        [virtualMachineConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachine_startOptions_relationship = [NSRelationshipDescription new];
        virtualMachine_startOptions_relationship.name = @"startOptions";
        virtualMachine_startOptions_relationship.optional = YES;
        virtualMachine_startOptions_relationship.minCount = 0;
        virtualMachine_startOptions_relationship.maxCount = 1;
        assert(!virtualMachine_startOptions_relationship.toMany);
        virtualMachine_startOptions_relationship.destinationEntity = virtualMachineStartOptionsEntity;
        virtualMachine_startOptions_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *virtualMachineStartOptions_machine_relationship = [NSRelationshipDescription new];
        virtualMachineStartOptions_machine_relationship.name = @"machine";
        virtualMachineStartOptions_machine_relationship.optional = YES;
        virtualMachineStartOptions_machine_relationship.minCount = 0;
        virtualMachineStartOptions_machine_relationship.maxCount = 1;
        assert(!virtualMachineStartOptions_machine_relationship.toMany);
        virtualMachineStartOptions_machine_relationship.destinationEntity = virtualMachineEntity;
        virtualMachineStartOptions_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachine_startOptions_relationship.inverseRelationship = virtualMachineStartOptions_machine_relationship;
        virtualMachineStartOptions_machine_relationship.inverseRelationship = virtualMachine_startOptions_relationship;
        
        virtualMachineEntity.properties = [virtualMachineEntity.properties arrayByAddingObject:virtualMachine_startOptions_relationship];
        virtualMachineStartOptionsEntity.properties = [virtualMachineStartOptionsEntity.properties arrayByAddingObject:virtualMachineStartOptions_machine_relationship];
        
        [virtualMachine_startOptions_relationship release];
        [virtualMachineStartOptions_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_bootLoader_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_bootLoader_relationship.name = @"bootLoader";
        virtualMachineConfiguration_bootLoader_relationship.optional = YES;
        virtualMachineConfiguration_bootLoader_relationship.minCount = 0;
        virtualMachineConfiguration_bootLoader_relationship.maxCount = 1;
        assert(!virtualMachineConfiguration_bootLoader_relationship.toMany);
        virtualMachineConfiguration_bootLoader_relationship.destinationEntity = bootLoaderEntity;
        virtualMachineConfiguration_bootLoader_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *bootLoader_machine_relationship = [NSRelationshipDescription new];
        bootLoader_machine_relationship.name = @"machine";
        bootLoader_machine_relationship.optional = YES;
        bootLoader_machine_relationship.minCount = 0;
        bootLoader_machine_relationship.maxCount = 1;
        assert(!bootLoader_machine_relationship.toMany);
        bootLoader_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        bootLoader_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_bootLoader_relationship.inverseRelationship = bootLoader_machine_relationship;
        bootLoader_machine_relationship.inverseRelationship = virtualMachineConfiguration_bootLoader_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_bootLoader_relationship];
        bootLoaderEntity.properties = [bootLoaderEntity.properties arrayByAddingObject:bootLoader_machine_relationship];
        
        [virtualMachineConfiguration_bootLoader_relationship release];
        [bootLoader_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_platform_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_platform_relationship.name = @"platform";
        virtualMachineConfiguration_platform_relationship.optional = YES;
        virtualMachineConfiguration_platform_relationship.minCount = 0;
        virtualMachineConfiguration_platform_relationship.maxCount = 1;
        assert(!virtualMachineConfiguration_platform_relationship.toMany);
        virtualMachineConfiguration_platform_relationship.destinationEntity = platformConfigurationEntity;
        virtualMachineConfiguration_platform_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *platform_machine_relationship = [NSRelationshipDescription new];
        platform_machine_relationship.name = @"machine";
        platform_machine_relationship.optional = YES;
        platform_machine_relationship.minCount = 0;
        platform_machine_relationship.maxCount = 1;
        assert(!platform_machine_relationship.toMany);
        platform_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        platform_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_platform_relationship.inverseRelationship = platform_machine_relationship;
        platform_machine_relationship.inverseRelationship = virtualMachineConfiguration_platform_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_platform_relationship];
        platformConfigurationEntity.properties = [platformConfigurationEntity.properties arrayByAddingObject:platform_machine_relationship];
        
        [virtualMachineConfiguration_platform_relationship release];
        [platform_machine_relationship release];
    }
    
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
    
    {
        NSRelationshipDescription *macPlatformConfiguration_machineIdentifier_relationship = [NSRelationshipDescription new];
        macPlatformConfiguration_machineIdentifier_relationship.name = @"machineIdentifier";
        macPlatformConfiguration_machineIdentifier_relationship.optional = YES;
        macPlatformConfiguration_machineIdentifier_relationship.minCount = 0;
        macPlatformConfiguration_machineIdentifier_relationship.maxCount = 1;
        assert(!macPlatformConfiguration_machineIdentifier_relationship.toMany);
        macPlatformConfiguration_machineIdentifier_relationship.destinationEntity = macMachineIdentifierEntity;
        macPlatformConfiguration_machineIdentifier_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *macMachineIdentifier_platform_relationship = [NSRelationshipDescription new];
        macMachineIdentifier_platform_relationship.name = @"platform";
        macMachineIdentifier_platform_relationship.optional = YES;
        macMachineIdentifier_platform_relationship.minCount = 0;
        macMachineIdentifier_platform_relationship.maxCount = 1;
        assert(!macMachineIdentifier_platform_relationship.toMany);
        macMachineIdentifier_platform_relationship.destinationEntity = macPlatformConfigurationEntity;
        macMachineIdentifier_platform_relationship.deleteRule = NSNullifyDeleteRule;
        
        macPlatformConfiguration_machineIdentifier_relationship.inverseRelationship = macMachineIdentifier_platform_relationship;
        macMachineIdentifier_platform_relationship.inverseRelationship = macPlatformConfiguration_machineIdentifier_relationship;
        
        macPlatformConfigurationEntity.properties = [macPlatformConfigurationEntity.properties arrayByAddingObject:macPlatformConfiguration_machineIdentifier_relationship];
        macMachineIdentifierEntity.properties = [macMachineIdentifierEntity.properties arrayByAddingObject:macMachineIdentifier_platform_relationship];
        
        [macPlatformConfiguration_machineIdentifier_relationship release];
        [macMachineIdentifier_platform_relationship release];
    }
    
    {
        NSRelationshipDescription *macPlatformConfiguration_hardwareModel_relationship = [NSRelationshipDescription new];
        macPlatformConfiguration_hardwareModel_relationship.name = @"hardwareModel";
        macPlatformConfiguration_hardwareModel_relationship.optional = YES;
        macPlatformConfiguration_hardwareModel_relationship.minCount = 0;
        macPlatformConfiguration_hardwareModel_relationship.maxCount = 1;
        assert(!macPlatformConfiguration_hardwareModel_relationship.toMany);
        macPlatformConfiguration_hardwareModel_relationship.destinationEntity = macHardwareModelEntity;
        macPlatformConfiguration_hardwareModel_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *macHardwareModel_platform_relationship = [NSRelationshipDescription new];
        macHardwareModel_platform_relationship.name = @"platform";
        macHardwareModel_platform_relationship.optional = YES;
        macHardwareModel_platform_relationship.minCount = 0;
        macHardwareModel_platform_relationship.maxCount = 1;
        assert(!macHardwareModel_platform_relationship.toMany);
        macHardwareModel_platform_relationship.destinationEntity = macPlatformConfigurationEntity;
        macHardwareModel_platform_relationship.deleteRule = NSNullifyDeleteRule;
        
        macPlatformConfiguration_hardwareModel_relationship.inverseRelationship = macHardwareModel_platform_relationship;
        macHardwareModel_platform_relationship.inverseRelationship = macPlatformConfiguration_hardwareModel_relationship;
        
        macPlatformConfigurationEntity.properties = [macPlatformConfigurationEntity.properties arrayByAddingObject:macPlatformConfiguration_hardwareModel_relationship];
        macHardwareModelEntity.properties = [macHardwareModelEntity.properties arrayByAddingObject:macHardwareModel_platform_relationship];
        
        [macPlatformConfiguration_hardwareModel_relationship release];
        [macHardwareModel_platform_relationship release];
    }
    
    {
        NSRelationshipDescription *macPlatformConfiguration_auxiliaryStorage_relationship = [NSRelationshipDescription new];
        macPlatformConfiguration_auxiliaryStorage_relationship.name = @"auxiliaryStorage";
        macPlatformConfiguration_auxiliaryStorage_relationship.optional = YES;
        macPlatformConfiguration_auxiliaryStorage_relationship.minCount = 0;
        macPlatformConfiguration_auxiliaryStorage_relationship.maxCount = 1;
        assert(!macPlatformConfiguration_auxiliaryStorage_relationship.toMany);
        macPlatformConfiguration_auxiliaryStorage_relationship.destinationEntity = macAuxiliaryStorageEntity;
        macPlatformConfiguration_auxiliaryStorage_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *macAuxiliaryStorage_platform_relationship = [NSRelationshipDescription new];
        macAuxiliaryStorage_platform_relationship.name = @"platform";
        macAuxiliaryStorage_platform_relationship.optional = YES;
        macAuxiliaryStorage_platform_relationship.minCount = 0;
        macAuxiliaryStorage_platform_relationship.maxCount = 1;
        assert(!macAuxiliaryStorage_platform_relationship.toMany);
        macAuxiliaryStorage_platform_relationship.destinationEntity = macPlatformConfigurationEntity;
        macAuxiliaryStorage_platform_relationship.deleteRule = NSNullifyDeleteRule;
        
        macPlatformConfiguration_auxiliaryStorage_relationship.inverseRelationship = macAuxiliaryStorage_platform_relationship;
        macAuxiliaryStorage_platform_relationship.inverseRelationship = macPlatformConfiguration_auxiliaryStorage_relationship;
        
        macPlatformConfigurationEntity.properties = [macPlatformConfigurationEntity.properties arrayByAddingObject:macPlatformConfiguration_auxiliaryStorage_relationship];
        macAuxiliaryStorageEntity.properties = [macAuxiliaryStorageEntity.properties arrayByAddingObject:macAuxiliaryStorage_platform_relationship];
        
        [macPlatformConfiguration_auxiliaryStorage_relationship release];
        [macAuxiliaryStorage_platform_relationship release];
    }
    
    {
        NSRelationshipDescription *genericPlatformConfiguration_machineIdentifier_relationship = [NSRelationshipDescription new];
        genericPlatformConfiguration_machineIdentifier_relationship.name = @"machineIdentifier";
        genericPlatformConfiguration_machineIdentifier_relationship.optional = YES;
        genericPlatformConfiguration_machineIdentifier_relationship.minCount = 0;
        genericPlatformConfiguration_machineIdentifier_relationship.maxCount = 1;
        assert(!genericPlatformConfiguration_machineIdentifier_relationship.toMany);
        genericPlatformConfiguration_machineIdentifier_relationship.destinationEntity = genericMachineIdentifierEntity;
        genericPlatformConfiguration_machineIdentifier_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *genericMachineIdentifier_platform_relationship = [NSRelationshipDescription new];
        genericMachineIdentifier_platform_relationship.name = @"platform";
        genericMachineIdentifier_platform_relationship.optional = YES;
        genericMachineIdentifier_platform_relationship.minCount = 0;
        genericMachineIdentifier_platform_relationship.maxCount = 1;
        assert(!genericMachineIdentifier_platform_relationship.toMany);
        genericMachineIdentifier_platform_relationship.destinationEntity = genericPlatformConfigurationEntity;
        genericMachineIdentifier_platform_relationship.deleteRule = NSNullifyDeleteRule;
        
        genericPlatformConfiguration_machineIdentifier_relationship.inverseRelationship = genericMachineIdentifier_platform_relationship;
        genericMachineIdentifier_platform_relationship.inverseRelationship = genericPlatformConfiguration_machineIdentifier_relationship;
        
        genericPlatformConfigurationEntity.properties = [genericPlatformConfigurationEntity.properties arrayByAddingObject:genericPlatformConfiguration_machineIdentifier_relationship];
        genericMachineIdentifierEntity.properties = [genericMachineIdentifierEntity.properties arrayByAddingObject:genericMachineIdentifier_platform_relationship];
        
        [genericPlatformConfiguration_machineIdentifier_relationship release];
        [genericMachineIdentifier_platform_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_keyboards_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_keyboards_relationship.name = @"keyboards";
        virtualMachineConfiguration_keyboards_relationship.optional = YES;
        virtualMachineConfiguration_keyboards_relationship.minCount = 0;
        virtualMachineConfiguration_keyboards_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_keyboards_relationship.toMany);
        virtualMachineConfiguration_keyboards_relationship.ordered = YES;
        virtualMachineConfiguration_keyboards_relationship.destinationEntity = keyboardConfigurationEntity;
        virtualMachineConfiguration_keyboards_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *keyboardConfiguration_machine_relationship = [NSRelationshipDescription new];
        keyboardConfiguration_machine_relationship.name = @"machine";
        keyboardConfiguration_machine_relationship.optional = YES;
        keyboardConfiguration_machine_relationship.minCount = 0;
        keyboardConfiguration_machine_relationship.maxCount = 1;
        assert(!keyboardConfiguration_machine_relationship.toMany);
        keyboardConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        keyboardConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_keyboards_relationship.inverseRelationship = keyboardConfiguration_machine_relationship;
        keyboardConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_keyboards_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_keyboards_relationship];
        keyboardConfigurationEntity.properties = [keyboardConfigurationEntity.properties arrayByAddingObject:keyboardConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_keyboards_relationship release];
        [keyboardConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_pointingDevices_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_pointingDevices_relationship.name = @"pointingDevices";
        virtualMachineConfiguration_pointingDevices_relationship.optional = YES;
        virtualMachineConfiguration_pointingDevices_relationship.minCount = 0;
        virtualMachineConfiguration_pointingDevices_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_pointingDevices_relationship.toMany);
        virtualMachineConfiguration_pointingDevices_relationship.ordered = YES;
        virtualMachineConfiguration_pointingDevices_relationship.destinationEntity = pointingDeviceConfigurationEntity;
        virtualMachineConfiguration_pointingDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *pointingDeviceConfiguration_machine_relationship = [NSRelationshipDescription new];
        pointingDeviceConfiguration_machine_relationship.name = @"machine";
        pointingDeviceConfiguration_machine_relationship.optional = YES;
        pointingDeviceConfiguration_machine_relationship.minCount = 0;
        pointingDeviceConfiguration_machine_relationship.maxCount = 1;
        assert(!pointingDeviceConfiguration_machine_relationship.toMany);
        pointingDeviceConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        pointingDeviceConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_pointingDevices_relationship.inverseRelationship = pointingDeviceConfiguration_machine_relationship;
        pointingDeviceConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_pointingDevices_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_pointingDevices_relationship];
        pointingDeviceConfigurationEntity.properties = [pointingDeviceConfigurationEntity.properties arrayByAddingObject:pointingDeviceConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_pointingDevices_relationship release];
        [pointingDeviceConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_networkDevices_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_networkDevices_relationship.name = @"networkDevices";
        virtualMachineConfiguration_networkDevices_relationship.optional = YES;
        virtualMachineConfiguration_networkDevices_relationship.minCount = 0;
        virtualMachineConfiguration_networkDevices_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_networkDevices_relationship.toMany);
        virtualMachineConfiguration_networkDevices_relationship.ordered = YES;
        virtualMachineConfiguration_networkDevices_relationship.destinationEntity = networkDeviceConfigurationEntity;
        virtualMachineConfiguration_networkDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *networkDeviceConfiguration_machine_relationship = [NSRelationshipDescription new];
        networkDeviceConfiguration_machine_relationship.name = @"machine";
        networkDeviceConfiguration_machine_relationship.optional = YES;
        networkDeviceConfiguration_machine_relationship.minCount = 0;
        networkDeviceConfiguration_machine_relationship.maxCount = 1;
        assert(!networkDeviceConfiguration_machine_relationship.toMany);
        networkDeviceConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        networkDeviceConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_networkDevices_relationship.inverseRelationship = networkDeviceConfiguration_machine_relationship;
        networkDeviceConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_networkDevices_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_networkDevices_relationship];
        networkDeviceConfigurationEntity.properties = [networkDeviceConfigurationEntity.properties arrayByAddingObject:networkDeviceConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_networkDevices_relationship release];
        [networkDeviceConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *networkDeviceConfiguration_attachment_relationship = [NSRelationshipDescription new];
        networkDeviceConfiguration_attachment_relationship.name = @"attachment";
        networkDeviceConfiguration_attachment_relationship.optional = YES;
        networkDeviceConfiguration_attachment_relationship.minCount = 0;
        networkDeviceConfiguration_attachment_relationship.maxCount = 1;
        assert(!networkDeviceConfiguration_attachment_relationship.toMany);
        networkDeviceConfiguration_attachment_relationship.destinationEntity = networkDeviceAttachmentEntity;
        networkDeviceConfiguration_attachment_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *networkDeviceAttachment_networkDevice_relationship = [NSRelationshipDescription new];
        networkDeviceAttachment_networkDevice_relationship.name = @"networkDevice";
        networkDeviceAttachment_networkDevice_relationship.optional = YES;
        networkDeviceAttachment_networkDevice_relationship.minCount = 0;
        networkDeviceAttachment_networkDevice_relationship.maxCount = 1;
        assert(!networkDeviceAttachment_networkDevice_relationship.toMany);
        networkDeviceAttachment_networkDevice_relationship.destinationEntity = networkDeviceConfigurationEntity;
        networkDeviceAttachment_networkDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        networkDeviceConfiguration_attachment_relationship.inverseRelationship = networkDeviceAttachment_networkDevice_relationship;
        networkDeviceAttachment_networkDevice_relationship.inverseRelationship = networkDeviceConfiguration_attachment_relationship;
        
        networkDeviceConfigurationEntity.properties = [networkDeviceConfigurationEntity.properties arrayByAddingObject:networkDeviceConfiguration_attachment_relationship];
        networkDeviceAttachmentEntity.properties = [networkDeviceAttachmentEntity.properties arrayByAddingObject:networkDeviceAttachment_networkDevice_relationship];
        
        [networkDeviceConfiguration_attachment_relationship release];
        [networkDeviceAttachment_networkDevice_relationship release];
    }
    
    {
        NSRelationshipDescription *networkDeviceConfiguration_macAddress_relationship = [NSRelationshipDescription new];
        networkDeviceConfiguration_macAddress_relationship.name = @"macAddress";
        networkDeviceConfiguration_macAddress_relationship.optional = YES;
        networkDeviceConfiguration_macAddress_relationship.minCount = 0;
        networkDeviceConfiguration_macAddress_relationship.maxCount = 1;
        assert(!networkDeviceConfiguration_macAddress_relationship.toMany);
        networkDeviceConfiguration_macAddress_relationship.destinationEntity = MACAddressEntity;
        networkDeviceConfiguration_macAddress_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *MACAddress_networkDevice_relationship = [NSRelationshipDescription new];
        MACAddress_networkDevice_relationship.name = @"networkDevice";
        MACAddress_networkDevice_relationship.optional = YES;
        MACAddress_networkDevice_relationship.minCount = 0;
        MACAddress_networkDevice_relationship.maxCount = 1;
        assert(!MACAddress_networkDevice_relationship.toMany);
        MACAddress_networkDevice_relationship.destinationEntity = networkDeviceConfigurationEntity;
        MACAddress_networkDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        networkDeviceConfiguration_macAddress_relationship.inverseRelationship = MACAddress_networkDevice_relationship;
        MACAddress_networkDevice_relationship.inverseRelationship = networkDeviceConfiguration_macAddress_relationship;
        
        networkDeviceConfigurationEntity.properties = [networkDeviceConfigurationEntity.properties arrayByAddingObject:networkDeviceConfiguration_macAddress_relationship];
        MACAddressEntity.properties = [MACAddressEntity.properties arrayByAddingObject:MACAddress_networkDevice_relationship];
        
        [networkDeviceConfiguration_macAddress_relationship release];
        [MACAddress_networkDevice_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_audioDevices_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_audioDevices_relationship.name = @"audioDevices";
        virtualMachineConfiguration_audioDevices_relationship.optional = YES;
        virtualMachineConfiguration_audioDevices_relationship.minCount = 0;
        virtualMachineConfiguration_audioDevices_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_audioDevices_relationship.toMany);
        virtualMachineConfiguration_audioDevices_relationship.ordered = YES;
        virtualMachineConfiguration_audioDevices_relationship.destinationEntity = audioDeviceConfigurationEntity;
        virtualMachineConfiguration_audioDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *audioDeviceConfiguration_machine_relationship = [NSRelationshipDescription new];
        audioDeviceConfiguration_machine_relationship.name = @"machine";
        audioDeviceConfiguration_machine_relationship.optional = YES;
        audioDeviceConfiguration_machine_relationship.minCount = 0;
        audioDeviceConfiguration_machine_relationship.maxCount = 1;
        assert(!audioDeviceConfiguration_machine_relationship.toMany);
        audioDeviceConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        audioDeviceConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_audioDevices_relationship.inverseRelationship = audioDeviceConfiguration_machine_relationship;
        audioDeviceConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_audioDevices_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_audioDevices_relationship];
        audioDeviceConfigurationEntity.properties = [audioDeviceConfigurationEntity.properties arrayByAddingObject:audioDeviceConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_audioDevices_relationship release];
        [audioDeviceConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *virtioSoundDeviceConfiguration_streams_relationship = [NSRelationshipDescription new];
        virtioSoundDeviceConfiguration_streams_relationship.name = @"streams";
        virtioSoundDeviceConfiguration_streams_relationship.optional = YES;
        virtioSoundDeviceConfiguration_streams_relationship.minCount = 0;
        virtioSoundDeviceConfiguration_streams_relationship.maxCount = 0;
        assert(virtioSoundDeviceConfiguration_streams_relationship.toMany);
        virtioSoundDeviceConfiguration_streams_relationship.ordered = YES;
        virtioSoundDeviceConfiguration_streams_relationship.destinationEntity = virtioSoundDeviceStreamConfigurationEntity;
        virtioSoundDeviceConfiguration_streams_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *virtioSoundDeviceStreamConfiguration_soundDevice_relationship = [NSRelationshipDescription new];
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.name = @"soundDevice";
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.optional = YES;
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.minCount = 0;
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.maxCount = 1;
        assert(!virtioSoundDeviceStreamConfiguration_soundDevice_relationship.toMany);
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.destinationEntity = virtioSoundDeviceConfigurationEntity;
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtioSoundDeviceConfiguration_streams_relationship.inverseRelationship = virtioSoundDeviceStreamConfiguration_soundDevice_relationship;
        virtioSoundDeviceStreamConfiguration_soundDevice_relationship.inverseRelationship = virtioSoundDeviceConfiguration_streams_relationship;
        
        virtioSoundDeviceConfigurationEntity.properties = [virtioSoundDeviceConfigurationEntity.properties arrayByAddingObject:virtioSoundDeviceConfiguration_streams_relationship];
        virtioSoundDeviceStreamConfigurationEntity.properties = [virtioSoundDeviceStreamConfigurationEntity.properties arrayByAddingObject:virtioSoundDeviceStreamConfiguration_soundDevice_relationship];
        
        [virtioSoundDeviceConfiguration_streams_relationship release];
        [virtioSoundDeviceStreamConfiguration_soundDevice_relationship release];
    }
    
    {
        NSRelationshipDescription *virtioSoundDeviceOutputStreamConfiguration_sink_relationship = [NSRelationshipDescription new];
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.name = @"sink";
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.optional = YES;
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.minCount = 0;
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.maxCount = 1;
        assert(!virtioSoundDeviceOutputStreamConfiguration_sink_relationship.toMany);
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.destinationEntity = audioOutputStreamSinkEntity;
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *audioOutputStreamSink_outputStream_relationship = [NSRelationshipDescription new];
        audioOutputStreamSink_outputStream_relationship.name = @"outputStream";
        audioOutputStreamSink_outputStream_relationship.optional = YES;
        audioOutputStreamSink_outputStream_relationship.minCount = 0;
        audioOutputStreamSink_outputStream_relationship.maxCount = 1;
        assert(!audioOutputStreamSink_outputStream_relationship.toMany);
        audioOutputStreamSink_outputStream_relationship.destinationEntity = virtioSoundDeviceOutputStreamConfigurationEntity;
        audioOutputStreamSink_outputStream_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtioSoundDeviceOutputStreamConfiguration_sink_relationship.inverseRelationship = audioOutputStreamSink_outputStream_relationship;
        audioOutputStreamSink_outputStream_relationship.inverseRelationship = audioOutputStreamSink_outputStream_relationship;
        
        virtioSoundDeviceOutputStreamConfigurationEntity.properties = [virtioSoundDeviceOutputStreamConfigurationEntity.properties arrayByAddingObject:virtioSoundDeviceOutputStreamConfiguration_sink_relationship];
        audioOutputStreamSinkEntity.properties = [audioOutputStreamSinkEntity.properties arrayByAddingObject:audioOutputStreamSink_outputStream_relationship];
        
        [virtioSoundDeviceOutputStreamConfiguration_sink_relationship release];
        [audioOutputStreamSink_outputStream_relationship release];
    }
    
    {
        NSRelationshipDescription *virtioSoundDeviceInputStreamConfiguration_source_relationship = [NSRelationshipDescription new];
        virtioSoundDeviceInputStreamConfiguration_source_relationship.name = @"source";
        virtioSoundDeviceInputStreamConfiguration_source_relationship.optional = YES;
        virtioSoundDeviceInputStreamConfiguration_source_relationship.minCount = 0;
        virtioSoundDeviceInputStreamConfiguration_source_relationship.maxCount = 1;
        assert(!virtioSoundDeviceInputStreamConfiguration_source_relationship.toMany);
        virtioSoundDeviceInputStreamConfiguration_source_relationship.destinationEntity = audioInputStreamSourceEntity;
        virtioSoundDeviceInputStreamConfiguration_source_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *audioInputStreamSource_inputStream_relationship = [NSRelationshipDescription new];
        audioInputStreamSource_inputStream_relationship.name = @"inputStream";
        audioInputStreamSource_inputStream_relationship.optional = YES;
        audioInputStreamSource_inputStream_relationship.minCount = 0;
        audioInputStreamSource_inputStream_relationship.maxCount = 1;
        assert(!audioInputStreamSource_inputStream_relationship.toMany);
        audioInputStreamSource_inputStream_relationship.destinationEntity = virtioSoundDeviceInputStreamConfigurationEntity;
        audioInputStreamSource_inputStream_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtioSoundDeviceInputStreamConfiguration_source_relationship.inverseRelationship = audioInputStreamSource_inputStream_relationship;
        audioInputStreamSource_inputStream_relationship.inverseRelationship = virtioSoundDeviceInputStreamConfiguration_source_relationship;
        
        virtioSoundDeviceInputStreamConfigurationEntity.properties = [virtioSoundDeviceInputStreamConfigurationEntity.properties arrayByAddingObject:virtioSoundDeviceInputStreamConfiguration_source_relationship];
        audioInputStreamSourceEntity.properties = [audioInputStreamSourceEntity.properties arrayByAddingObject:audioInputStreamSource_inputStream_relationship];
        
        [virtioSoundDeviceInputStreamConfiguration_source_relationship release];
        [audioInputStreamSource_inputStream_relationship release];
    }
    
    {
        NSRelationshipDescription *virtualMachineConfiguration_usbControllers_relationship = [NSRelationshipDescription new];
        virtualMachineConfiguration_usbControllers_relationship.name = @"usbControllers";
        virtualMachineConfiguration_usbControllers_relationship.optional = YES;
        virtualMachineConfiguration_usbControllers_relationship.minCount = 0;
        virtualMachineConfiguration_usbControllers_relationship.maxCount = 0;
        assert(virtualMachineConfiguration_usbControllers_relationship.toMany);
        virtualMachineConfiguration_usbControllers_relationship.ordered = YES;
        virtualMachineConfiguration_usbControllers_relationship.destinationEntity = USBControllerConfigurationEntity;
        virtualMachineConfiguration_usbControllers_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *USBControllerConfiguration_machine_relationship = [NSRelationshipDescription new];
        USBControllerConfiguration_machine_relationship.name = @"machine";
        USBControllerConfiguration_machine_relationship.optional = YES;
        USBControllerConfiguration_machine_relationship.minCount = 0;
        USBControllerConfiguration_machine_relationship.maxCount = 1;
        assert(!USBControllerConfiguration_machine_relationship.toMany);
        USBControllerConfiguration_machine_relationship.destinationEntity = virtualMachineConfigurationEntity;
        USBControllerConfiguration_machine_relationship.deleteRule = NSNullifyDeleteRule;
        
        virtualMachineConfiguration_usbControllers_relationship.inverseRelationship = USBControllerConfiguration_machine_relationship;
        USBControllerConfiguration_machine_relationship.inverseRelationship = virtualMachineConfiguration_usbControllers_relationship;
        
        virtualMachineConfigurationEntity.properties = [virtualMachineConfigurationEntity.properties arrayByAddingObject:virtualMachineConfiguration_usbControllers_relationship];
        USBControllerConfigurationEntity.properties = [USBControllerConfigurationEntity.properties arrayByAddingObject:USBControllerConfiguration_machine_relationship];
        
        [virtualMachineConfiguration_usbControllers_relationship release];
        [USBControllerConfiguration_machine_relationship release];
    }
    
    {
        NSRelationshipDescription *USBControllerConfiguration_usbMassStorageDevices_relationship = [NSRelationshipDescription new];
        USBControllerConfiguration_usbMassStorageDevices_relationship.name = @"usbMassStorageDevices";
        USBControllerConfiguration_usbMassStorageDevices_relationship.optional = YES;
        USBControllerConfiguration_usbMassStorageDevices_relationship.minCount = 0;
        USBControllerConfiguration_usbMassStorageDevices_relationship.maxCount = 0;
        assert(USBControllerConfiguration_usbMassStorageDevices_relationship.toMany);
        USBControllerConfiguration_usbMassStorageDevices_relationship.ordered = YES;
        USBControllerConfiguration_usbMassStorageDevices_relationship.destinationEntity = USBMassStorageDeviceConfigurationEntity;
        USBControllerConfiguration_usbMassStorageDevices_relationship.deleteRule = NSCascadeDeleteRule;
        
        NSRelationshipDescription *USBMassStorageDeviceConfiguration_usbController_relationship = [NSRelationshipDescription new];
        USBMassStorageDeviceConfiguration_usbController_relationship.name = @"usbController";
        USBMassStorageDeviceConfiguration_usbController_relationship.optional = YES;
        USBMassStorageDeviceConfiguration_usbController_relationship.minCount = 0;
        USBMassStorageDeviceConfiguration_usbController_relationship.maxCount = 1;
        assert(!USBMassStorageDeviceConfiguration_usbController_relationship.toMany);
        USBMassStorageDeviceConfiguration_usbController_relationship.destinationEntity = USBControllerConfigurationEntity;
        USBMassStorageDeviceConfiguration_usbController_relationship.deleteRule = NSNullifyDeleteRule;
        
        USBControllerConfiguration_usbMassStorageDevices_relationship.inverseRelationship = USBMassStorageDeviceConfiguration_usbController_relationship;
        USBMassStorageDeviceConfiguration_usbController_relationship.inverseRelationship = USBControllerConfiguration_usbMassStorageDevices_relationship;
        
        USBControllerConfigurationEntity.properties = [USBControllerConfigurationEntity.properties arrayByAddingObject:USBControllerConfiguration_usbMassStorageDevices_relationship];
        USBMassStorageDeviceConfigurationEntity.properties = [USBMassStorageDeviceConfigurationEntity.properties arrayByAddingObject:USBMassStorageDeviceConfiguration_usbController_relationship];
        
        [USBControllerConfiguration_usbMassStorageDevices_relationship release];
    }
    
    //
    
    managedObjectModel.entities = @[
        virtualMachineEntity,
        macOSVirtualMachineStartOptionsEntity,
        virtualMachineStartOptionsEntity,
        macOSBootLoaderEntity,
        bootLoaderEntity,
        virtualMachineConfigurationEntity,
        macGraphicsDeviceConfigurationEntity,
        virtioGraphicsDeviceConfigurationEntity,
        graphicsDeviceConfigurationEntity,
        macGraphicsDisplayConfigurationEntity,
        virtioGraphicsScanoutConfigurationEntity,
        graphicsDisplayConfigurationEntity,
        virtioBlockDeviceConfigurationEntity,
        USBMassStorageDeviceConfigurationEntity,
        storageDeviceConfigurationEntity,
        diskImageStorageDeviceAttachmentEntity,
        diskBlockDeviceStorageDeviceAttachmentEntity,
        storageDeviceAttachmentEntity,
        macAuxiliaryStorageEntity,
        macHardwareModelEntity,
        macMachineIdentifierEntity,
        macPlatformConfigurationEntity,
        genericPlatformConfigurationEntity,
        platformConfigurationEntity,
        genericMachineIdentifierEntity,
        usbKeyboardConfigurationEntity,
        macKeyboardConfigurationEntity,
        keyboardConfigurationEntity,
        USBScreenCoordinatePointingDeviceConfigurationEntity,
        macTrackpadConfigurationEntity,
        pointingDeviceConfigurationEntity,
        virtioNetworkDeviceConfigurationEntity,
        networkDeviceConfigurationEntity,
        NATNetworkDeviceAttachmentEntity,
        networkDeviceAttachmentEntity,
        MACAddressEntity,
        virtioSoundDeviceConfigurationEntity,
        audioDeviceConfigurationEntity,
        virtioSoundDeviceOutputStreamConfigurationEntity,
        virtioSoundDeviceInputStreamConfigurationEntity,
        virtioSoundDeviceStreamConfigurationEntity,
        hostAudioInputStreamSourceEntity,
        audioInputStreamSourceEntity,
        hostAudioOutputStreamSinkEntity,
        audioOutputStreamSinkEntity,
        XHCIControllerConfigurationEntity,
        USBControllerConfigurationEntity
    ];
    
    [virtualMachineEntity release];
    [macOSVirtualMachineStartOptionsEntity release];
    [virtualMachineStartOptionsEntity release];
    [macOSBootLoaderEntity release];
    [bootLoaderEntity release];
    [virtualMachineConfigurationEntity release];
    [macGraphicsDeviceConfigurationEntity release];
    [virtioGraphicsDeviceConfigurationEntity release];
    [graphicsDeviceConfigurationEntity release];
    [macGraphicsDisplayConfigurationEntity release];
    [virtioGraphicsScanoutConfigurationEntity release];
    [graphicsDisplayConfigurationEntity release];
    [virtioBlockDeviceConfigurationEntity release];
    [USBMassStorageDeviceConfigurationEntity release];
    [storageDeviceConfigurationEntity release];
    [diskImageStorageDeviceAttachmentEntity release];
    [diskBlockDeviceStorageDeviceAttachmentEntity release];
    [storageDeviceAttachmentEntity release];
    [macAuxiliaryStorageEntity release];
    [macHardwareModelEntity release];
    [macMachineIdentifierEntity release];
    [macPlatformConfigurationEntity release];
    [genericPlatformConfigurationEntity release];
    [platformConfigurationEntity release];
    [genericMachineIdentifierEntity release];
    [usbKeyboardConfigurationEntity release];
    [macKeyboardConfigurationEntity release];
    [keyboardConfigurationEntity release];
    [USBScreenCoordinatePointingDeviceConfigurationEntity release];
    [macTrackpadConfigurationEntity release];
    [pointingDeviceConfigurationEntity release];
    [virtioNetworkDeviceConfigurationEntity release];
    [networkDeviceConfigurationEntity release];
    [NATNetworkDeviceAttachmentEntity release];
    [networkDeviceAttachmentEntity release];
    [MACAddressEntity release];
    [virtioSoundDeviceConfigurationEntity release];
    [audioDeviceConfigurationEntity release];
    [virtioSoundDeviceOutputStreamConfigurationEntity release];
    [virtioSoundDeviceInputStreamConfigurationEntity release];
    [virtioSoundDeviceStreamConfigurationEntity release];
    [hostAudioInputStreamSourceEntity release];
    [audioInputStreamSourceEntity release];
    [hostAudioOutputStreamSinkEntity release];
    [audioOutputStreamSinkEntity release];
    [XHCIControllerConfigurationEntity release];
    [USBControllerConfigurationEntity release];
    
    return [managedObjectModel autorelease];
}

@end
