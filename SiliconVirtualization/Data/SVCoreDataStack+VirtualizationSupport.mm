//
//  SVCoreDataStack+VirtualizationSupport.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVCoreDataStack+VirtualizationSupport.h"

@implementation SVCoreDataStack (VirtualizationSupport)

- (SVVirtualMachineConfiguration *)isolated_makeManagedObjectFromVirtualMachineConfiguration:(VZVirtualMachineConfiguration *)virtualMachineConfiguration {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    
    SVVirtualMachineConfiguration *virtualMachineConfigurationObject = [[SVVirtualMachineConfiguration alloc] initWithContext:managedObjectContext];
    
    virtualMachineConfigurationObject.bootLoader = [self _isolated_makeManagedObjectFromBootLoader:virtualMachineConfiguration.bootLoader];
    virtualMachineConfigurationObject.platform = [self _isolated_makeManagedObjectFromPlatform:virtualMachineConfiguration.platform];
    
    virtualMachineConfigurationObject.cpuCount = @(virtualMachineConfiguration.CPUCount);
    virtualMachineConfigurationObject.memorySize = @(virtualMachineConfiguration.memorySize);
    
    virtualMachineConfigurationObject.graphicsDevices = [self _isolated_makeManagedObjectsFromGraphicsDevices:virtualMachineConfiguration.graphicsDevices];
    virtualMachineConfigurationObject.storageDevices = [self _isolated_makeManagedObjectsFromStorageDevices:virtualMachineConfiguration.storageDevices];
    
    //
    
    return [virtualMachineConfigurationObject autorelease];
}

- (VZVirtualMachineConfiguration *)isolated_makeVirtualMachineConfigurationFromManagedObject:(SVVirtualMachineConfiguration *)virtualMachineConfigurationObject {
    VZVirtualMachineConfiguration *virtualMachineConfiguration = [VZVirtualMachineConfiguration new];
    
    virtualMachineConfiguration.CPUCount = virtualMachineConfigurationObject.cpuCount.unsignedLongLongValue;
    virtualMachineConfiguration.memorySize = virtualMachineConfigurationObject.memorySize.unsignedLongLongValue;
    
    //
    
    __kindof SVBootLoader * _Nullable bootLoaderObject = virtualMachineConfigurationObject.bootLoader;
    __kindof VZBootLoader * _Nullable bootLoader = nil;
    
    if (bootLoaderObject == nil) {
        bootLoader = nil;
    } else if ([bootLoaderObject isKindOfClass:[SVMacOSBootLoader class]]) {
        bootLoader = [[VZMacOSBootLoader alloc] init];
    } else {
        abort();
    }
    
    virtualMachineConfiguration.bootLoader = bootLoader;
    [bootLoader release];
    
    //
    
    __kindof SVPlatformConfiguration * _Nullable platformConfigurationObject = virtualMachineConfigurationObject.platform;
    __kindof VZPlatformConfiguration * _Nullable platformConfiguration = nil;
    
    if (platformConfigurationObject == nil) {
        platformConfiguration = nil;
    } else if ([platformConfigurationObject isKindOfClass:[SVMacPlatformConfiguration class]]) {
        auto macPlatformConfigurationObject = static_cast<SVMacPlatformConfiguration *>(platformConfigurationObject);
        VZMacPlatformConfiguration *macPlatformConfiguration = [[VZMacPlatformConfiguration alloc] init];
        
        {
            SVMacAuxiliaryStorage * _Nullable macAuxiliaryStorageObject = macPlatformConfigurationObject.auxiliaryStorage;
            
            if (macAuxiliaryStorageObject != nil) {
                NSData *bookmarkData = macAuxiliaryStorageObject.bookmarkData;
                assert(bookmarkData != nil);
                
                NSError * _Nullable error = nil;
                BOOL stale;
                NSURL *URL = [[NSURL alloc] initByResolvingBookmarkData:bookmarkData
                                                                options:NSURLBookmarkResolutionWithoutMounting | NSURLBookmarkResolutionWithSecurityScope
                                                          relativeToURL:nil
                                                    bookmarkDataIsStale:&stale
                                                                  error:&error];
                assert(error == nil);
                
                if (stale) {
                    URL = [self _refreshStaleURL:URL];
                }
                
                assert([URL startAccessingSecurityScopedResource]);
                VZMacAuxiliaryStorage *macAuxiliaryStorage = [[VZMacAuxiliaryStorage alloc] initWithURL:URL];
                [URL stopAccessingSecurityScopedResource];
                [URL release];
                
                macPlatformConfiguration.auxiliaryStorage = macAuxiliaryStorage;
                [macAuxiliaryStorage release];
            } else {
                macPlatformConfiguration.auxiliaryStorage = nil;
            }
        }
        
        {
            SVMacHardwareModel *macHardwareModelObject = macPlatformConfigurationObject.hardwareModel;
            assert(macPlatformConfigurationObject != nil);
            
            NSData *dataRepresentation = macHardwareModelObject.dataRepresentation;
            assert(dataRepresentation != nil);
            
            VZMacHardwareModel *hardwareModel = [[VZMacHardwareModel alloc] initWithDataRepresentation:dataRepresentation];
            macPlatformConfiguration.hardwareModel = hardwareModel;
            [hardwareModel release];
        }
        
        {
            SVMacMachineIdentifier *macMachineIdentifierObject = macPlatformConfigurationObject.machineIdentifier;
            assert(macMachineIdentifierObject != nil);
            
            NSData *dataRepresentation = macMachineIdentifierObject.dataRepresentation;
            assert(dataRepresentation != nil);
            
            VZMacMachineIdentifier *machineIdentifier = [[VZMacMachineIdentifier alloc] initWithDataRepresentation:dataRepresentation];
            macPlatformConfiguration.machineIdentifier = machineIdentifier;
            [machineIdentifier release];
        }
        
        platformConfiguration = macPlatformConfiguration;
    } else if ([platformConfigurationObject isKindOfClass:[SVGenericPlatformConfiguration class]]) {
        auto genericPlatformConfigurationObject = static_cast<SVGenericPlatformConfiguration *>(platformConfigurationObject);
        
        VZGenericPlatformConfiguration *genericPlatformConfiguration = [[VZGenericPlatformConfiguration alloc] init];
        
        NSData *dataRepresentation = genericPlatformConfigurationObject.machineIdentifier.dataRepresentation;
        assert(dataRepresentation != nil);
        VZGenericMachineIdentifier *genericMachineIdentifier = [[VZGenericMachineIdentifier alloc] initWithDataRepresentation:dataRepresentation];
        genericPlatformConfiguration.machineIdentifier = genericMachineIdentifier;
        [genericMachineIdentifier release];
        
        genericPlatformConfiguration.nestedVirtualizationEnabled = genericPlatformConfigurationObject.nestedVirtualizationEnabled;
        
        platformConfiguration = genericPlatformConfiguration;
    } else {
        abort();
    }
    
    virtualMachineConfiguration.platform = platformConfiguration;
    [platformConfiguration release];
    
    //
    
    NSMutableArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.graphicsDevices.count];
    
    for (__kindof SVGraphicsDeviceConfiguration *graphicsDeviceConfigurationObject in virtualMachineConfigurationObject.graphicsDevices) {
        if ([graphicsDeviceConfigurationObject isKindOfClass:[SVMacGraphicsDeviceConfiguration class]]) {
            auto macGraphicsDeviceConfigurationObject = static_cast<SVMacGraphicsDeviceConfiguration *>(graphicsDeviceConfigurationObject);
            VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration = [[VZMacGraphicsDeviceConfiguration alloc] init];
            
            NSOrderedSet<SVMacGraphicsDisplayConfiguration *> *displayObjects = macGraphicsDeviceConfigurationObject.displays;
            NSMutableArray<VZMacGraphicsDisplayConfiguration *> *displays = [[NSMutableArray alloc] initWithCapacity:displayObjects.count];
            
            for (SVMacGraphicsDisplayConfiguration *displayObject in displayObjects) {
                VZMacGraphicsDisplayConfiguration *macGraphicsDisplayConfiguration = [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:displayObject.widthInPixels heightInPixels:displayObject.heightInPixels pixelsPerInch:displayObject.pixelsPerInch];
                [displays addObject:macGraphicsDisplayConfiguration];
                [macGraphicsDisplayConfiguration release];
            }
            
            macGraphicsDeviceConfiguration.displays = displays;
            [displays release];
            
            [graphicsDevices addObject:macGraphicsDeviceConfiguration];
            [macGraphicsDeviceConfiguration release];
        } else if ([graphicsDeviceConfigurationObject isKindOfClass:[SVVirtioGraphicsDeviceConfiguration class]]) {
            auto virtioGraphicsDeviceConfigurationObject = static_cast<SVVirtioGraphicsDeviceConfiguration *>(graphicsDeviceConfigurationObject);
            VZVirtioGraphicsDeviceConfiguration *virtioGraphicsDeviceConfiguration = [[VZVirtioGraphicsDeviceConfiguration alloc] init];
            
            NSOrderedSet<SVVirtioGraphicsScanoutConfiguration *> *scanoutObjects = virtioGraphicsDeviceConfigurationObject.scanouts;
            NSMutableArray<VZVirtioGraphicsScanoutConfiguration *> *scanouts = [[NSMutableArray alloc] initWithCapacity:scanoutObjects.count];
            
            for (SVVirtioGraphicsScanoutConfiguration *scanoutObject in scanoutObjects) {
                VZVirtioGraphicsScanoutConfiguration *scanout = [[VZVirtioGraphicsScanoutConfiguration alloc] initWithWidthInPixels:scanoutObject.widthInPixels heightInPixels:scanoutObject.heightInPixels];
                [scanouts addObject:scanout];
            }
            
            virtioGraphicsDeviceConfiguration.scanouts = scanouts;
            [scanouts release];
            
            [graphicsDevices addObject:virtioGraphicsDeviceConfiguration];
            [virtioGraphicsDeviceConfiguration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.graphicsDevices = graphicsDevices;
    [graphicsDevices release];
    
    //
    
    NSMutableArray<__kindof VZStorageDeviceConfiguration *> *storageDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.storageDevices.count];
    
    for (__kindof SVStorageDeviceConfiguration *storageDeviceConfigurationObject in virtualMachineConfigurationObject.storageDevices) {
        __kindof SVStorageDeviceAttachment *attachmentObject = storageDeviceConfigurationObject.attachment;
        __kindof VZStorageDeviceAttachment *attachment;
        
        if ([attachmentObject isKindOfClass:[SVDiskImageStorageDeviceAttachment class]]) {
            auto diskImageStorageDeviceAttachmentObject = static_cast<SVDiskImageStorageDeviceAttachment *>(attachmentObject);
            
            NSError * _Nullable error = nil;
            
            NSData *bookmarkData = diskImageStorageDeviceAttachmentObject.bookmarkData;
            BOOL stale;
            NSURL *URL = [[NSURL alloc] initByResolvingBookmarkData:bookmarkData
                                                            options:NSURLBookmarkResolutionWithoutMounting | NSURLBookmarkResolutionWithSecurityScope
                                                      relativeToURL:nil
                                                bookmarkDataIsStale:&stale
                                                              error:&error];
            assert(error == nil);
           
            if (stale) {
                URL = [self _refreshStaleURL:URL];
            }
            
            assert([URL startAccessingSecurityScopedResource]);
            attachment = [[VZDiskImageStorageDeviceAttachment alloc] initWithURL:URL
                                                                        readOnly:diskImageStorageDeviceAttachmentObject.readOnly
                                                                     cachingMode:static_cast<VZDiskImageCachingMode>(diskImageStorageDeviceAttachmentObject.cachingMode)
                                                             synchronizationMode:static_cast<VZDiskImageSynchronizationMode>(diskImageStorageDeviceAttachmentObject.synchronizationMode)
                                                                           error:&error];
            assert(error == nil);
            [URL stopAccessingSecurityScopedResource];
            [URL release];
            
        } else {
            abort();
        }
        
        if ([storageDeviceConfigurationObject isKindOfClass:[SVVirtioBlockDeviceConfiguration class]]) {
            VZVirtioBlockDeviceConfiguration *virtioBlockDeviceConfiguration = [[VZVirtioBlockDeviceConfiguration alloc] initWithAttachment:attachment];
            [storageDevices addObject:virtioBlockDeviceConfiguration];
            [virtioBlockDeviceConfiguration release];
        } else {
            abort();
        }
        
        [attachment release];
    }
    
    virtualMachineConfiguration.storageDevices = storageDevices;
    [storageDevices release];
    
    //
    
    return [virtualMachineConfiguration autorelease];
}

- (void)isolated_updateManagedObject:(SVVirtualMachineConfiguration *)virtualMachineConfiguration withMachineConfiguration:(VZVirtualMachineConfiguration *)machineConfiguration {
    virtualMachineConfiguration.cpuCount = @(machineConfiguration.CPUCount);
    virtualMachineConfiguration.memorySize = @(machineConfiguration.memorySize);
    
    virtualMachineConfiguration.bootLoader = [self _isolated_makeManagedObjectFromBootLoader:machineConfiguration.bootLoader];
    virtualMachineConfiguration.platform = [self _isolated_makeManagedObjectFromPlatform:machineConfiguration.platform];
    
    [virtualMachineConfiguration removeGraphicsDevicesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, virtualMachineConfiguration.graphicsDevices.count)]];
    [virtualMachineConfiguration removeStorageDevicesAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, virtualMachineConfiguration.storageDevices.count)]];
    
    virtualMachineConfiguration.graphicsDevices = [self _isolated_makeManagedObjectsFromGraphicsDevices:machineConfiguration.graphicsDevices];
    virtualMachineConfiguration.storageDevices = [self _isolated_makeManagedObjectsFromStorageDevices:machineConfiguration.storageDevices];
}

- (__kindof SVBootLoader * _Nullable)_isolated_makeManagedObjectFromBootLoader:(__kindof VZBootLoader * _Nullable)bootLoader {
    NSManagedObjectContext *context = self.backgroundContext;
    
    __kindof SVBootLoader * _Nullable bootLoaderObject;
    if (bootLoader == nil) {
        bootLoaderObject = nil;
    } else if ([bootLoader isKindOfClass:[VZMacOSBootLoader class]]) {
        bootLoaderObject = [[SVMacOSBootLoader alloc] initWithContext:context];
    } else {
        abort();
    }
    
    return [bootLoaderObject autorelease];
}

- (__kindof SVPlatformConfiguration * _Nullable)_isolated_makeManagedObjectFromPlatform:(__kindof VZPlatformConfiguration * _Nullable)platformConfiguration {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    
    __kindof SVPlatformConfiguration * _Nullable platformConfigurationObject = nil;
    
    if (platformConfiguration == nil) {
        platformConfigurationObject = nil;
    } else if ([platformConfiguration isKindOfClass:[VZMacPlatformConfiguration class]]) {
        auto macPlatformConfiguration = static_cast<VZMacPlatformConfiguration *>(platformConfiguration);
        
        SVMacPlatformConfiguration *macPlatformConfigurationObject = [[SVMacPlatformConfiguration alloc] initWithContext:managedObjectContext];
        
        NSURL * _Nullable auxiliaryStorageURL = macPlatformConfiguration.auxiliaryStorage.URL;
        if (auxiliaryStorageURL != nil) {
            SVMacAuxiliaryStorage *macAuxiliaryStorageObject = [[SVMacAuxiliaryStorage alloc] initWithContext:managedObjectContext];
            assert([auxiliaryStorageURL startAccessingSecurityScopedResource]);
            NSError * _Nullable error = nil;
            macAuxiliaryStorageObject.bookmarkData = [auxiliaryStorageURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
            assert(error == nil);
            [auxiliaryStorageURL stopAccessingSecurityScopedResource];
            macPlatformConfigurationObject.auxiliaryStorage = macAuxiliaryStorageObject;
            [macAuxiliaryStorageObject release];
        } else {
            macPlatformConfigurationObject.auxiliaryStorage = nil;
        }
        
        SVMacHardwareModel *macHardwareModelObject = [[SVMacHardwareModel alloc] initWithContext:managedObjectContext];
        macHardwareModelObject.dataRepresentation = macPlatformConfiguration.hardwareModel.dataRepresentation;
        macPlatformConfigurationObject.hardwareModel = macHardwareModelObject;
        [macHardwareModelObject release];
        
        SVMacMachineIdentifier *macMachineIdentifierObject = [[SVMacMachineIdentifier alloc] initWithContext:managedObjectContext];
        macMachineIdentifierObject.dataRepresentation = macPlatformConfiguration.machineIdentifier.dataRepresentation;
        macPlatformConfigurationObject.machineIdentifier = macMachineIdentifierObject;
        [macMachineIdentifierObject release];
        
        platformConfigurationObject = macPlatformConfigurationObject;
    } else if ([platformConfiguration isKindOfClass:[VZGenericPlatformConfiguration class]]) {
        auto genericPlatformConfiguration = static_cast<VZGenericPlatformConfiguration *>(platformConfiguration);
        
        SVGenericPlatformConfiguration *genericPlatformConfigurationObject = [[SVGenericPlatformConfiguration alloc] initWithContext:managedObjectContext];
        
        SVGenericMachineIdentifier *genericMachineIdentifierObject = [[SVGenericMachineIdentifier alloc] initWithContext:managedObjectContext];
        genericMachineIdentifierObject.dataRepresentation = genericPlatformConfiguration.machineIdentifier.dataRepresentation;
        genericPlatformConfigurationObject.machineIdentifier = genericMachineIdentifierObject;
        [genericMachineIdentifierObject release];
        
        genericPlatformConfigurationObject.nestedVirtualizationEnabled = genericPlatformConfiguration.nestedVirtualizationEnabled;
        
        platformConfigurationObject = genericPlatformConfigurationObject;
    } else {
        abort();
    }
    
    return [platformConfigurationObject autorelease];
}

- (NSOrderedSet<__kindof SVGraphicsDeviceConfiguration *> *)_isolated_makeManagedObjectsFromGraphicsDevices:(NSArray<VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVGraphicsDeviceConfiguration *> *graphicsDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:graphicsDevices.count];
    
    for (__kindof VZGraphicsDeviceConfiguration *graphicsDeviceConfiguration in graphicsDevices) {
        if ([graphicsDeviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]) {
            auto macGraphicsDeviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(graphicsDeviceConfiguration);
            
            SVMacGraphicsDeviceConfiguration *macGraphicsDeviceConfigurationObject = [[SVMacGraphicsDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            for (VZMacGraphicsDisplayConfiguration *macGraphicsDisplayConfiguration in macGraphicsDeviceConfiguration.displays) {
                SVMacGraphicsDisplayConfiguration *macGraphicsDisplayConfigurationObject = [[SVMacGraphicsDisplayConfiguration alloc] initWithContext:managedObjectContext];
                
                macGraphicsDisplayConfigurationObject.heightInPixels = macGraphicsDisplayConfiguration.heightInPixels;
                macGraphicsDisplayConfigurationObject.pixelsPerInch = macGraphicsDisplayConfiguration.pixelsPerInch;
                macGraphicsDisplayConfigurationObject.widthInPixels = macGraphicsDisplayConfiguration.widthInPixels;
                
                [macGraphicsDeviceConfigurationObject addDisplaysObject:macGraphicsDisplayConfigurationObject];
                [macGraphicsDisplayConfigurationObject release];
            }
            
            [graphicsDeviceObjects addObject:macGraphicsDeviceConfigurationObject];
            [macGraphicsDeviceConfigurationObject release];
        } else if ([graphicsDeviceConfiguration isKindOfClass:[VZVirtioGraphicsDeviceConfiguration class]]) {
            auto virtioGraphicsDeviceConfiguration = static_cast<VZVirtioGraphicsDeviceConfiguration *>(graphicsDeviceConfiguration);
            
            SVVirtioGraphicsDeviceConfiguration *virtioGraphicsDeviceConfigurationObject = [[SVVirtioGraphicsDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            for (VZVirtioGraphicsScanoutConfiguration *virtioGraphicsScanoutConfiguration in virtioGraphicsDeviceConfiguration.scanouts) {
                SVVirtioGraphicsScanoutConfiguration *virtioGraphicsScanoutConfigurationObject = [[SVVirtioGraphicsScanoutConfiguration alloc] initWithContext:managedObjectContext];
                
                virtioGraphicsScanoutConfigurationObject.heightInPixels = virtioGraphicsScanoutConfiguration.heightInPixels;
                virtioGraphicsScanoutConfigurationObject.widthInPixels = virtioGraphicsScanoutConfiguration.widthInPixels;
                
                [virtioGraphicsDeviceConfigurationObject addScanoutsObject:virtioGraphicsScanoutConfigurationObject];
                [virtioGraphicsScanoutConfigurationObject release];
            }
            
            [graphicsDeviceObjects addObject:virtioGraphicsDeviceConfigurationObject];
            [virtioGraphicsDeviceConfigurationObject release];
        } else {
            abort();
        }
    }
    
    return [graphicsDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVStorageDeviceConfiguration *> *)_isolated_makeManagedObjectsFromStorageDevices:(NSArray<VZStorageDeviceConfiguration *> *)storageDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVStorageDeviceConfiguration *> *storageDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:storageDevices.count];
    
    for (__kindof VZStorageDeviceConfiguration *storageDeviceConfiguration in storageDevices) {
        __kindof SVStorageDeviceConfiguration *storageDeviceConfigurationObject;
        
        if ([storageDeviceConfiguration isKindOfClass:[VZVirtioBlockDeviceConfiguration class]]) {
            storageDeviceConfigurationObject = [[SVVirtioBlockDeviceConfiguration alloc] initWithContext:managedObjectContext];
        } else {
            abort();
        }
        
        __kindof VZStorageDeviceAttachment *storageDeviceAttachment = storageDeviceConfiguration.attachment;
        __kindof SVStorageDeviceAttachment *storageDeviceAttachmentObject;
        if ([storageDeviceAttachment isKindOfClass:[VZDiskImageStorageDeviceAttachment class]]) {
            auto diskImageStorageDeviceAttachment = static_cast<VZDiskImageStorageDeviceAttachment *>(storageDeviceAttachment);
            
            SVDiskImageStorageDeviceAttachment *diskImageStorageDeviceAttachmentObject = [[SVDiskImageStorageDeviceAttachment alloc] initWithContext:managedObjectContext];
            storageDeviceAttachmentObject = diskImageStorageDeviceAttachmentObject;
            
            diskImageStorageDeviceAttachmentObject.cachingMode = diskImageStorageDeviceAttachment.cachingMode;
            diskImageStorageDeviceAttachmentObject.readOnly = diskImageStorageDeviceAttachment.readOnly;
            diskImageStorageDeviceAttachmentObject.synchronizationMode = diskImageStorageDeviceAttachment.synchronizationMode;
            
            NSURL *URL = diskImageStorageDeviceAttachment.URL;
            assert([URL startAccessingSecurityScopedResource]);
            NSError * _Nullable error = nil;
            diskImageStorageDeviceAttachmentObject.bookmarkData = [URL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
            assert(error == nil);
            [URL stopAccessingSecurityScopedResource];
        } else {
            abort();
        }
        
        storageDeviceConfigurationObject.attachment = storageDeviceAttachmentObject;
        [storageDeviceAttachmentObject release];
        
        [storageDeviceObjects addObject:storageDeviceConfigurationObject];
        [storageDeviceConfigurationObject release];
    }
    
    return [storageDeviceObjects autorelease];
}

- (NSURL *)_refreshStaleURL:(NSURL *)URL NS_RETURNS_RETAINED {
    __block NSURL *newURL;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSOpenPanel *openPanel = [NSOpenPanel new];
        
        openPanel.canChooseFiles = YES;
        openPanel.canChooseDirectories = NO;
        openPanel.directoryURL = URL;
        
        [openPanel runModal];
        
        newURL = [openPanel.URL copy];
        assert(newURL != nil);
        [openPanel release];
    });
    
    return newURL;
}

@end
