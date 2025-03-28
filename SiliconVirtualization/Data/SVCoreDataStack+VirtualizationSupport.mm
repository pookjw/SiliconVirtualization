//
//  SVCoreDataStack+VirtualizationSupport.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVCoreDataStack+VirtualizationSupport.h"
#include <ranges>
#import <objc/message.h>
#import <objc/runtime.h>

@implementation SVCoreDataStack (VirtualizationSupport)

- (SVVirtualMachineConfiguration *)isolated_makeManagedObjectFromVirtualMachineConfiguration:(VZVirtualMachineConfiguration *)virtualMachineConfiguration {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    
    SVVirtualMachineConfiguration *virtualMachineConfigurationObject = [[SVVirtualMachineConfiguration alloc] initWithContext:managedObjectContext];
    
    virtualMachineConfigurationObject.bootLoader = [self _isolated_makeManagedObjectFromBootLoader:virtualMachineConfiguration.bootLoader];
    virtualMachineConfigurationObject.platform = [self _isolated_makeManagedObjectFromPlatform:virtualMachineConfiguration.platform];
    
    virtualMachineConfigurationObject.cpuCount = @(virtualMachineConfiguration.CPUCount);
    virtualMachineConfigurationObject.memorySize = @(virtualMachineConfiguration.memorySize);
    
    NSArray *acceleratorDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_acceleratorDevices"));
    virtualMachineConfigurationObject.acceleratorDevices = [self _isolated_makeManagedObjectsFromAcceleratorDevices:acceleratorDevices];
    
    NSArray *coprocessors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_coprocessors"));
    virtualMachineConfigurationObject.coprocessors = [self _isolated_makeManagedObjectsFromCoprocessors:coprocessors];
    
    virtualMachineConfigurationObject.keyboards = [self _isolated_makeManagedObjectsFromKeyboards:virtualMachineConfiguration.keyboards];
    virtualMachineConfigurationObject.audioDevices = [self _isolated_makeManagedObjectsFromAudioDevices:virtualMachineConfiguration.audioDevices];
    
    NSArray *biometricDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_biometricDevices"));
    virtualMachineConfigurationObject.biometricDevices = [self _isolated_makeManagedObjectsFromBiometricDevices:biometricDevices];
    
    virtualMachineConfigurationObject.directorySharingDevices = [self _isolated_makeManagedObjectsFromDirectorySharingDevices:virtualMachineConfiguration.directorySharingDevices];
    virtualMachineConfigurationObject.networkDevices = [self _isolated_makeManagedObjectsFromNetworkDevices:virtualMachineConfiguration.networkDevices];
    virtualMachineConfigurationObject.pointingDevices = [self _isolated_makeManagedObjectsFromPointingDevices:virtualMachineConfiguration.pointingDevices];
    virtualMachineConfigurationObject.graphicsDevices = [self _isolated_makeManagedObjectsFromGraphicsDevices:virtualMachineConfiguration.graphicsDevices];
    
    NSArray *powerSourceDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_powerSourceDevices"));
    virtualMachineConfigurationObject.powerSourceDevices = [self _isolated_makeManagedObjectsFromPowerSourceDevices:powerSourceDevices];
    
    virtualMachineConfigurationObject.storageDevices = [self _isolated_makeManagedObjectsFromStorageDevices:virtualMachineConfiguration.storageDevices];
    virtualMachineConfigurationObject.usbControllers = [self _isolated_makeManagedObjectsFromUSBControllers:virtualMachineConfiguration.usbControllers];
    virtualMachineConfigurationObject.memoryBalloonDevices = [self _isolated_makeManagedObjectsFromMemoryBalloonDevices:virtualMachineConfiguration.memoryBalloonDevices];
    
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
    
    NSMutableArray<__kindof VZAudioDeviceConfiguration *> *audioDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.audioDevices.count];
    
    for (__kindof SVAudioDeviceConfiguration *audioDeviceObject in virtualMachineConfigurationObject.audioDevices) {
        if ([audioDeviceObject isKindOfClass:[SVVirtioSoundDeviceConfiguration class]]) {
            auto virtioSoundDeviceConfigurationObject = static_cast<SVVirtioSoundDeviceConfiguration *>(audioDeviceObject);
            
            VZVirtioSoundDeviceConfiguration *virtioSoundDeviceConfiguration = [[VZVirtioSoundDeviceConfiguration alloc] init];
            
            NSMutableArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams = [[NSMutableArray alloc] initWithCapacity:virtioSoundDeviceConfigurationObject.streams.count];
            
            for (__kindof SVVirtioSoundDeviceStreamConfiguration *streamObject in virtioSoundDeviceConfigurationObject.streams) {
                if ([streamObject isKindOfClass:[SVVirtioSoundDeviceOutputStreamConfiguration class]]) {
                    auto virtioSoundDeviceOutputStreamConfigurationObject = static_cast<SVVirtioSoundDeviceOutputStreamConfiguration *>(streamObject);
                    
                    VZVirtioSoundDeviceOutputStreamConfiguration *virtioSoundDeviceOutputStreamConfiguration = [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
                    
                    __kindof SVAudioOutputStreamSink * _Nullable sinkObject = virtioSoundDeviceOutputStreamConfigurationObject.sink;
                    __kindof VZAudioOutputStreamSink * _Nullable sink;
                    if (sinkObject == nil) {
                        sink = nil;
                    } else if ([sinkObject isKindOfClass:[SVHostAudioOutputStreamSink class]]) {
                        sink = [[VZHostAudioOutputStreamSink alloc] init];
                    } else {
                        abort();
                    }
                    virtioSoundDeviceOutputStreamConfiguration.sink = sink;
                    [sink release];
                    
                    [streams addObject:virtioSoundDeviceOutputStreamConfiguration];
                    [virtioSoundDeviceOutputStreamConfiguration release];
                } else if ([streamObject isKindOfClass:[SVVirtioSoundDeviceInputStreamConfiguration class]]) {
                    auto virtioSoundDeviceInputStreamConfigurationObject = static_cast<SVVirtioSoundDeviceInputStreamConfiguration *>(streamObject);
                    
                    VZVirtioSoundDeviceInputStreamConfiguration *virtioSoundDeviceInputStreamConfiguration = [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
                    
                    __kindof SVAudioInputStreamSource * _Nullable sourceObject = virtioSoundDeviceInputStreamConfigurationObject.source;
                    __kindof VZAudioInputStreamSource * _Nullable source;
                    if (sourceObject == nil) {
                        source = nil;
                    } else if ([sourceObject isKindOfClass:[SVHostAudioInputStreamSource class]]) {
                        source = [[VZHostAudioInputStreamSource alloc] init];
                    } else {
                        abort();
                    }
                    
                    virtioSoundDeviceInputStreamConfiguration.source = source;
                    [source release];
                    
                    [streams addObject:virtioSoundDeviceInputStreamConfiguration];
                    [virtioSoundDeviceInputStreamConfiguration release];
                } else {
                    abort();
                }
            }
            
            virtioSoundDeviceConfiguration.streams = streams;
            [streams release];
            [audioDevices addObject:virtioSoundDeviceConfiguration];
            [virtioSoundDeviceConfiguration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.audioDevices = audioDevices;
    [audioDevices release];
    
    //
    
    NSMutableArray *acceleratorDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.acceleratorDevices.count];
    
    for (__kindof SVAcceleratorDeviceConfiguration *acceleratorDeviceConfigurationObject in virtualMachineConfigurationObject.acceleratorDevices) {
        if ([acceleratorDeviceConfigurationObject isKindOfClass:[SVMacNeuralEngineDeviceConfiguration class]]) {
            id configuration = [objc_lookUpClass("_VZMacNeuralEngineDeviceConfiguration") new];
            [acceleratorDevices addObject:configuration];
            [configuration release];
        } else {
            abort();
        }
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_setAcceleratorDevices:"), acceleratorDevices);
    [acceleratorDevices release];
    
    //
    
    NSMutableArray *coprocessors = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.coprocessors.count];
    
    for (__kindof SVCoprocessorConfiguration *coprocessorObject in virtualMachineConfigurationObject.coprocessors) {
        if ([coprocessorObject isKindOfClass:[SVSEPCoprocessorConfiguration class]]) {
            auto casted = static_cast<SVSEPCoprocessorConfiguration *>(coprocessorObject);
            SVSEPStorage *storageObject = casted.storage;
            NSData *bookmarkData = storageObject.bookmarkData;
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
            
            id storage = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPStorage") alloc], sel_registerName("initWithURL:"), URL);
            [URL release];
            
            id coprocessor = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPCoprocessorConfiguration") alloc], sel_registerName("initWithStorage:"), storage);
            [storage release];
            
            {
                if (NSData *romBinaryBookmarkData = casted.romBinaryBookmarkData) {
                    NSError * _Nullable error = nil;
                    
                    BOOL stale;
                    NSURL *romBinaryURL = [[NSURL alloc] initByResolvingBookmarkData:romBinaryBookmarkData
                                                                    options:NSURLBookmarkResolutionWithoutMounting | NSURLBookmarkResolutionWithSecurityScope
                                                              relativeToURL:nil
                                                        bookmarkDataIsStale:&stale
                                                                      error:&error];
                    assert(error == nil);
                    
                    if (stale) {
                        romBinaryURL = [self _refreshStaleURL:romBinaryURL];
                    }
                    
                    assert([romBinaryURL startAccessingSecurityScopedResource]);
                    
                    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(coprocessor, sel_registerName("setRomBinaryURL:"), romBinaryURL);
                    [romBinaryURL release];
                }
            }
            
            [coprocessors addObject:coprocessor];
            [coprocessor release];
        } else {
            abort();
        }
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_setCoprocessors:"), coprocessors);
    [coprocessors release];
    
    //
    
    NSMutableArray *biometricDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.biometricDevices.count];
    
    for (__kindof SVBiometricDeviceConfiguration *biometricDeviceConfiguration in virtualMachineConfigurationObject.biometricDevices) {
        if ([biometricDeviceConfiguration isKindOfClass:[SVMacTouchIDDeviceConfiguration class]]) {
            id configuration = [objc_lookUpClass("_VZMacTouchIDDeviceConfiguration") new];
            [biometricDevices addObject:configuration];
            [configuration release];
        } else {
            abort();
        }
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_setBiometricDevices:"), biometricDevices);
    [biometricDevices release];
    
    //
    
    NSMutableArray<__kindof VZDirectorySharingDeviceConfiguration *> *directorySharingDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.directorySharingDevices.count];
    
    for (__kindof SVDirectorySharingDeviceConfiguration *directorySharingDeviceObject in virtualMachineConfigurationObject.directorySharingDevices) {
        if ([directorySharingDeviceObject isKindOfClass:[SVVirtioFileSystemDeviceConfiguration class]]) {
            auto virtioFileSystemDeviceConfigurationObject = static_cast<SVVirtioFileSystemDeviceConfiguration *>(directorySharingDeviceObject);
            
            __kindof SVDirectoryShare * _Nullable shareObject = virtioFileSystemDeviceConfigurationObject.share;
            __kindof VZDirectoryShare * _Nullable share;
            if (shareObject == nil) {
                share = nil;
            } else if ([shareObject isKindOfClass:[SVMultipleDirectoryShare class]]) {
                auto multipleDirectoryShareObject = static_cast<SVMultipleDirectoryShare *>(shareObject);
                
                NSArray<NSString *> *directoryNames = multipleDirectoryShareObject.directoryNames;
                NSOrderedSet<SVSharedDirectory *> *directoryObjects = multipleDirectoryShareObject.directories;
                assert(directoryNames.count == directoryObjects.count);
                NSMutableDictionary<NSString *, VZSharedDirectory *> *directories = [[NSMutableDictionary alloc] initWithCapacity:directoryNames.count];
                
                for (NSInteger index : std::views::iota(0, static_cast<NSInteger>(directoryNames.count))) {
                    NSString *name = directoryNames[index];
                    
                    SVSharedDirectory *directoryObject = directoryObjects[index];
                    assert(directoryObject != nil);
                    
                    NSError * _Nullable error = nil;
                    
                    NSData *bookmarkData = directoryObject.bookmarkData;
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
                    
                    VZSharedDirectory *directory = [[VZSharedDirectory alloc] initWithURL:URL readOnly:directoryObject.readOnly];
                    [URL release];
                    
                    directories[name] = directory;
                    [directory release];
                }
                
                VZMultipleDirectoryShare *multipleDirectoryShare = [[VZMultipleDirectoryShare alloc] initWithDirectories:directories];
                [directories release];
                
                share = multipleDirectoryShare;
            } else if ([shareObject isKindOfClass:[SVSingleDirectoryShare class]]) {
                auto singleDirectoryShareObject = static_cast<SVSingleDirectoryShare *>(shareObject);
                
                SVSharedDirectory *directoryObject = singleDirectoryShareObject.directory;
                assert(directoryObject != nil);
                
                NSError * _Nullable error = nil;
                
                NSData *bookmarkData = directoryObject.bookmarkData;
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
                
                VZSharedDirectory *directory = [[VZSharedDirectory alloc] initWithURL:URL readOnly:directoryObject.readOnly];
                [URL release];
                VZSingleDirectoryShare *singleDirectoryShare = [[VZSingleDirectoryShare alloc] initWithDirectory:directory];
                [directory release];
                
                share = singleDirectoryShare;
            } else {
                abort();
            }
            
            VZVirtioFileSystemDeviceConfiguration *virtioFileSystemDeviceConfiguration = [[VZVirtioFileSystemDeviceConfiguration alloc] initWithTag:virtioFileSystemDeviceConfigurationObject.tag];
            virtioFileSystemDeviceConfiguration.share = share;
            [share release];
            
            [directorySharingDevices addObject:virtioFileSystemDeviceConfiguration];
            [virtioFileSystemDeviceConfiguration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.directorySharingDevices = directorySharingDevices;
    [directorySharingDevices release];
    
    //
    
    NSMutableArray<__kindof VZPointingDeviceConfiguration *> *pointingDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.pointingDevices.count];
    
    for (__kindof SVPointingDeviceConfiguration *pointingDeviceConfiguration in virtualMachineConfigurationObject.pointingDevices) {
        if ([pointingDeviceConfiguration isKindOfClass:[SVUSBScreenCoordinatePointingDeviceConfiguration class]]) {
            VZUSBScreenCoordinatePointingDeviceConfiguration *configuration = [[VZUSBScreenCoordinatePointingDeviceConfiguration alloc] init];
            [pointingDevices addObject:configuration];
            [configuration release];
        } else if ([pointingDeviceConfiguration isKindOfClass:[SVMacTrackpadConfiguration class]]) {
            VZMacTrackpadConfiguration *configuration = [[VZMacTrackpadConfiguration alloc] init];
            [pointingDevices addObject:configuration];
            [configuration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.pointingDevices = pointingDevices;
    [pointingDevices release];
    
    //
    
    NSMutableArray<__kindof VZKeyboardConfiguration *> *keyboards = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.keyboards.count];
    
    for (__kindof SVKeyboardConfiguration *keyboardConfigurationObject in virtualMachineConfigurationObject.keyboards) {
        if ([keyboardConfigurationObject isKindOfClass:[SVMacKeyboardConfiguration class]]) {
            VZMacKeyboardConfiguration *macKeyboardConfiguration = [[VZMacKeyboardConfiguration alloc] init];
            [keyboards addObject:macKeyboardConfiguration];
            [macKeyboardConfiguration release];
        } else if ([keyboardConfigurationObject isKindOfClass:[SVUSBKeyboardConfiguration class]]) {
            VZUSBKeyboardConfiguration *usbKeyboardConfiguration = [[VZUSBKeyboardConfiguration alloc] init];
            [keyboards addObject:usbKeyboardConfiguration];
            [usbKeyboardConfiguration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.keyboards = keyboards;
    [keyboards release];
    
    //
    
    NSMutableArray<__kindof VZNetworkDeviceConfiguration *> *networkDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.networkDevices.count];
    
    for (__kindof SVNetworkDeviceConfiguration *networkDeviceObject in virtualMachineConfigurationObject.networkDevices) {
        if ([networkDeviceObject isKindOfClass:[SVVirtioNetworkDeviceConfiguration class]]) {
            auto virtioNetworkDeviceConfigurationObject = static_cast<SVVirtioNetworkDeviceConfiguration *>(networkDeviceObject);
            
            VZVirtioNetworkDeviceConfiguration *networkDevice = [[VZVirtioNetworkDeviceConfiguration alloc] init];
            
            {
                NSData *ethernetAddressData = virtioNetworkDeviceConfigurationObject.macAddress.ethernetAddress;
                assert(ethernetAddressData != nil);
                ether_addr_t ethernetAddress;
                [ethernetAddressData getBytes:&ethernetAddress length:sizeof(ether_addr_t)];
                
                VZMACAddress *MACAddress = [[VZMACAddress alloc] initWithEthernetAddress:ethernetAddress];
                networkDevice.MACAddress = MACAddress;
                [MACAddress release];
            }
            
            __kindof SVNetworkDeviceAttachment *attachmentObject = virtioNetworkDeviceConfigurationObject.attachment;
            __kindof VZNATNetworkDeviceAttachment * _Nullable attachment;
            if (attachmentObject == nil) {
                attachment = nil;
            } else if ([attachmentObject isKindOfClass:[SVNATNetworkDeviceAttachment class]]) {
                attachment = [[VZNATNetworkDeviceAttachment alloc] init];
            } else {
                abort();
            }
            
            networkDevice.attachment = attachment;
            [attachment release];
            
            [networkDevices addObject:networkDevice];
            [networkDevice release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.networkDevices = networkDevices;
    [networkDevices release];
    
    //
    
    NSMutableArray<__kindof VZGraphicsDeviceConfiguration *> *graphicsDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.graphicsDevices.count];
    
    for (__kindof SVGraphicsDeviceConfiguration *graphicsDeviceConfigurationObject in virtualMachineConfigurationObject.graphicsDevices) {
        if ([graphicsDeviceConfigurationObject isKindOfClass:[SVMacGraphicsDeviceConfiguration class]]) {
            auto macGraphicsDeviceConfigurationObject = static_cast<SVMacGraphicsDeviceConfiguration *>(graphicsDeviceConfigurationObject);
            VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration = [[VZMacGraphicsDeviceConfiguration alloc] init];
            
            reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(macGraphicsDeviceConfiguration, sel_registerName("_setPrefersLowPower:"), macGraphicsDeviceConfigurationObject.prefersLowPower);
            
            NSOrderedSet<SVMacGraphicsDisplayConfiguration *> *displayObjects = macGraphicsDeviceConfigurationObject.displays;
            NSMutableArray<VZMacGraphicsDisplayConfiguration *> *displays = [[NSMutableArray alloc] initWithCapacity:displayObjects.count];
            
            for (SVMacGraphicsDisplayConfiguration *displayObject in displayObjects) {
                VZMacGraphicsDisplayConfiguration *macGraphicsDisplayConfiguration = [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:displayObject.widthInPixels heightInPixels:displayObject.heightInPixels pixelsPerInch:displayObject.pixelsPerInch];
                reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(macGraphicsDisplayConfiguration, sel_registerName("_setDisplayMode:"), displayObject.displayMode);
                
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
                [scanout release];
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
    
    NSMutableArray *powerSourceDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.powerSourceDevices.count];
    
    for (__kindof SVPowerSourceDeviceConfiguration *powerSourceDeviceObject in virtualMachineConfigurationObject.powerSourceDevices) {
        if ([powerSourceDeviceObject isKindOfClass:[SVMacBatteryPowerSourceDeviceConfiguration class]]) {
            auto casted = static_cast<SVMacBatteryPowerSourceDeviceConfiguration *>(powerSourceDeviceObject);
            id macBatteryPowerSourceDeviceConfiguration = [objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration") new];
            
            __kindof SVMacBatterySource * _Nullable sourceObject = casted.source;
            id _Nullable source;
            if (sourceObject == nil) {
                source = nil;
            } else if ([sourceObject isKindOfClass:[SVMacHostBatterySource class]]) {
                source = [objc_lookUpClass("_VZMacHostBatterySource") new];
            } else if ([sourceObject isKindOfClass:[SVMacSyntheticBatterySource class]]) {
                source = [objc_lookUpClass("_VZMacSyntheticBatterySource") new];
                
                auto casted = static_cast<SVMacSyntheticBatterySource *>(sourceObject);
                reinterpret_cast<void (*)(id, SEL, double)>(objc_msgSend)(source, sel_registerName("setCharge:"), casted.charge);
                reinterpret_cast<void (*)(id, SEL, NSInteger)>(objc_msgSend)(source, sel_registerName("setConnectivity:"), casted.connectivity);
            } else {
                abort();
            }
            
            reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(macBatteryPowerSourceDeviceConfiguration, sel_registerName("setSource:"), source);
            [source release];
            
            [powerSourceDevices addObject:macBatteryPowerSourceDeviceConfiguration];
            [macBatteryPowerSourceDeviceConfiguration release];
        } else if ([powerSourceDeviceObject isKindOfClass:[SVMacWallPowerSourceDeviceConfiguration class]]) {
            id macWallPowerSourceDeviceConfiguration = [objc_lookUpClass("_VZMacWallPowerSourceDeviceConfiguration") new];
            [powerSourceDevices addObject:macWallPowerSourceDeviceConfiguration];
            [macWallPowerSourceDeviceConfiguration release];
        }
    }
    
    reinterpret_cast<void (*)(id, SEL, id)>(objc_msgSend)(virtualMachineConfiguration, sel_registerName("_setPowerSourceDevices:"), powerSourceDevices);
    [powerSourceDevices release];
    
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
        } else if ([attachmentObject isKindOfClass:[SVDiskBlockDeviceStorageDeviceAttachment class]]) {
            auto diskBlockDeviceStorageDeviceAttachmentObject = static_cast<SVDiskBlockDeviceStorageDeviceAttachment *>(attachmentObject);
            
            NSFileHandle *fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:diskBlockDeviceStorageDeviceAttachmentObject.fileDescriptor closeOnDealloc:NO];
            
            NSError * _Nullable error = nil;
            attachment = [[VZDiskBlockDeviceStorageDeviceAttachment alloc] initWithFileHandle:fileHandle readOnly:diskBlockDeviceStorageDeviceAttachmentObject.readOnly synchronizationMode:static_cast<VZDiskSynchronizationMode>(diskBlockDeviceStorageDeviceAttachmentObject.synchronizationMode) error:&error];
            assert(error == nil);
            [fileHandle release];
        } else {
            abort();
        }
        
        if ([storageDeviceConfigurationObject isKindOfClass:[SVVirtioBlockDeviceConfiguration class]]) {
            VZVirtioBlockDeviceConfiguration *virtioBlockDeviceConfiguration = [[VZVirtioBlockDeviceConfiguration alloc] initWithAttachment:attachment];
            [storageDevices addObject:virtioBlockDeviceConfiguration];
            [virtioBlockDeviceConfiguration release];
        } else if ([storageDeviceConfigurationObject isKindOfClass:[SVNVMExpressControllerDeviceConfiguration class]]) {
            VZNVMExpressControllerDeviceConfiguration *NVMExpressControllerDeviceConfiguration = [[VZNVMExpressControllerDeviceConfiguration alloc] initWithAttachment:attachment];
            [storageDevices addObject:NVMExpressControllerDeviceConfiguration];
            [NVMExpressControllerDeviceConfiguration release];
        } else {
            abort();
        }
        
        [attachment release];
    }
    
    virtualMachineConfiguration.storageDevices = storageDevices;
    [storageDevices release];
    
    //
    
    NSMutableArray<__kindof VZUSBControllerConfiguration *> *usbControllers = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.usbControllers.count];
    
    for (__kindof SVUSBControllerConfiguration *USBControllerObject in virtualMachineConfigurationObject.usbControllers) {
        if ([USBControllerObject isKindOfClass:[SVXHCIControllerConfiguration class]]) {
            auto XHCIControllerConfigurationObject = static_cast<SVXHCIControllerConfiguration *>(USBControllerObject);
            VZXHCIControllerConfiguration *XHCIControllerConfiguration = [[VZXHCIControllerConfiguration alloc] init];
            
            NSMutableArray<VZUSBMassStorageDeviceConfiguration *> *usbDevices = [NSMutableArray new];
            
            for (SVUSBMassStorageDeviceConfiguration *USBMassStorageDeviceConfigurationObject in XHCIControllerConfigurationObject.usbMassStorageDevices) {
                __kindof SVStorageDeviceAttachment *attachmentObject = USBMassStorageDeviceConfigurationObject.attachment;
                assert([attachmentObject isKindOfClass:[SVDiskBlockDeviceStorageDeviceAttachment class]]);
                auto diskBlockDeviceStorageDeviceAttachmentObject = static_cast<SVDiskBlockDeviceStorageDeviceAttachment *>(attachmentObject);
                
                NSFileHandle *fileHandle = [[NSFileHandle alloc] initWithFileDescriptor:diskBlockDeviceStorageDeviceAttachmentObject.fileDescriptor closeOnDealloc:NO];
                
                NSError * _Nullable error = nil;
                
                VZDiskBlockDeviceStorageDeviceAttachment *attachment = [[VZDiskBlockDeviceStorageDeviceAttachment alloc] initWithFileHandle:fileHandle
                                                                                                                                   readOnly:diskBlockDeviceStorageDeviceAttachmentObject.readOnly
                                                                                                                        synchronizationMode:static_cast<VZDiskSynchronizationMode>(diskBlockDeviceStorageDeviceAttachmentObject.synchronizationMode)
                                                                                                                                      error:&error];
                assert(error == nil);
                [fileHandle release];
                
                VZUSBMassStorageDeviceConfiguration *USBMassStorageDeviceConfiguration = [[VZUSBMassStorageDeviceConfiguration alloc] initWithAttachment:attachment];
                [attachment release];
                
                [usbDevices addObject:USBMassStorageDeviceConfiguration];
                [USBMassStorageDeviceConfiguration release];
            }
            
            XHCIControllerConfiguration.usbDevices = usbDevices;
            [usbDevices release];
            
            [usbControllers addObject:XHCIControllerConfiguration];
            [XHCIControllerConfiguration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.usbControllers = usbControllers;
    [usbControllers release];
    
    //
    
    NSMutableArray<__kindof VZMemoryBalloonDeviceConfiguration *> *memoryBalloonDevices = [[NSMutableArray alloc] initWithCapacity:virtualMachineConfigurationObject.memoryBalloonDevices.count];
    
    for (__kindof SVMemoryBalloonDeviceConfiguration *memoryBalloonDeviceObject in virtualMachineConfigurationObject.memoryBalloonDevices) {
        if ([memoryBalloonDeviceObject isKindOfClass:[SVVirtioTraditionalMemoryBalloonDeviceConfiguration class]]) {
            VZVirtioTraditionalMemoryBalloonDeviceConfiguration *configuration = [[VZVirtioTraditionalMemoryBalloonDeviceConfiguration alloc] init];
            [memoryBalloonDevices addObject:configuration];
            [configuration release];
        } else {
            abort();
        }
    }
    
    virtualMachineConfiguration.memoryBalloonDevices = memoryBalloonDevices;
    [memoryBalloonDevices release];
    
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
    
    virtualMachineConfiguration.keyboards = [self _isolated_makeManagedObjectsFromKeyboards:machineConfiguration.keyboards];
    virtualMachineConfiguration.audioDevices = [self _isolated_makeManagedObjectsFromAudioDevices:machineConfiguration.audioDevices];
    
    NSArray *acceleratorDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(machineConfiguration, sel_registerName("_acceleratorDevices"));
    virtualMachineConfiguration.acceleratorDevices = [self _isolated_makeManagedObjectsFromAcceleratorDevices:acceleratorDevices];
    
    NSArray *coprocessors = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(machineConfiguration, sel_registerName("_coprocessors"));
    virtualMachineConfiguration.coprocessors = [self _isolated_makeManagedObjectsFromCoprocessors:coprocessors];
    
    NSArray *biometricDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(machineConfiguration, sel_registerName("_biometricDevices"));
    virtualMachineConfiguration.biometricDevices = [self _isolated_makeManagedObjectsFromBiometricDevices:biometricDevices];
    
    virtualMachineConfiguration.directorySharingDevices = [self _isolated_makeManagedObjectsFromDirectorySharingDevices:machineConfiguration.directorySharingDevices];
    virtualMachineConfiguration.networkDevices = [self _isolated_makeManagedObjectsFromNetworkDevices:machineConfiguration.networkDevices];
    virtualMachineConfiguration.pointingDevices = [self _isolated_makeManagedObjectsFromPointingDevices:machineConfiguration.pointingDevices];
    virtualMachineConfiguration.graphicsDevices = [self _isolated_makeManagedObjectsFromGraphicsDevices:machineConfiguration.graphicsDevices];
    
    NSArray *powerSourceDevices = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(machineConfiguration, sel_registerName("_powerSourceDevices"));
    virtualMachineConfiguration.powerSourceDevices = [self _isolated_makeManagedObjectsFromPowerSourceDevices:powerSourceDevices];
    
    virtualMachineConfiguration.storageDevices = [self _isolated_makeManagedObjectsFromStorageDevices:machineConfiguration.storageDevices];
    virtualMachineConfiguration.usbControllers = [self _isolated_makeManagedObjectsFromUSBControllers:machineConfiguration.usbControllers];
    virtualMachineConfiguration.memoryBalloonDevices = [self _isolated_makeManagedObjectsFromMemoryBalloonDevices:machineConfiguration.memoryBalloonDevices];
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

- (NSOrderedSet<__kindof SVBiometricDeviceConfiguration *> *)_isolated_makeManagedObjectsFromBiometricDevices:(NSArray *)biometricDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVBiometricDeviceConfiguration *> *biometricDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:biometricDevices.count];
    
    for (id biometricDevice in biometricDevices) {
        if ([biometricDevice isKindOfClass:objc_lookUpClass("_VZMacTouchIDDeviceConfiguration")]) {
            SVMacTouchIDDeviceConfiguration *object = [[SVMacTouchIDDeviceConfiguration alloc] initWithContext:managedObjectContext];
            [biometricDeviceObjects addObject:object];
            [object release];
        } else {
            abort();
        }
    }
    
    return [biometricDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVKeyboardConfiguration *> *)_isolated_makeManagedObjectsFromKeyboards:(NSArray<__kindof VZKeyboardConfiguration *> *)keyboards {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVKeyboardConfiguration *> *keyboardObjects = [[NSMutableOrderedSet alloc] initWithCapacity:keyboards.count];
    
    for (__kindof VZKeyboardConfiguration *keyboard in keyboards) {
        if ([keyboard isKindOfClass:[VZMacKeyboardConfiguration class]]) {
            SVMacKeyboardConfiguration *macKeyboardConfiguration = [[SVMacKeyboardConfiguration alloc] initWithContext:managedObjectContext];
            [keyboardObjects addObject:macKeyboardConfiguration];
            [macKeyboardConfiguration release];
        } else if ([keyboard isKindOfClass:[VZUSBKeyboardConfiguration class]]) {
            SVUSBKeyboardConfiguration *usbKeyboardConfiguration = [[SVUSBKeyboardConfiguration alloc] initWithContext:managedObjectContext];
            [keyboardObjects addObject:usbKeyboardConfiguration];
            [usbKeyboardConfiguration release];
        } else {
            abort();
        }
    }
    
    return [keyboardObjects autorelease];
}

- (NSOrderedSet<__kindof SVAudioDeviceConfiguration *> *)_isolated_makeManagedObjectsFromAudioDevices:(NSArray<__kindof VZAudioDeviceConfiguration *> *)audioDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVAudioDeviceConfiguration *> *audioDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:audioDevices.count];
    
    for (__kindof VZAudioDeviceConfiguration *audioDevice in audioDevices) {
        if ([audioDevice isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]) {
            auto virtioSoundDeviceConfiguration = static_cast<VZVirtioSoundDeviceConfiguration *>(audioDevice);
            
            SVVirtioSoundDeviceConfiguration *virtioSoundDeviceConfigurationObject = [[SVVirtioSoundDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            NSMutableOrderedSet<__kindof SVVirtioSoundDeviceStreamConfiguration *> *streamsObject = [[NSMutableOrderedSet alloc] initWithCapacity:virtioSoundDeviceConfiguration.streams.count];
            
            for (__kindof VZVirtioSoundDeviceStreamConfiguration *stream in virtioSoundDeviceConfiguration.streams) {
                if ([stream isKindOfClass:[VZVirtioSoundDeviceOutputStreamConfiguration class]]) {
                    auto virtioSoundDeviceOutputStreamConfiguration = static_cast<VZVirtioSoundDeviceOutputStreamConfiguration *>(stream);
                    
                    SVVirtioSoundDeviceOutputStreamConfiguration *virtioSoundDeviceOutputStreamConfigurationObject = [[SVVirtioSoundDeviceOutputStreamConfiguration alloc] initWithContext:managedObjectContext];
                    
                    __kindof VZAudioOutputStreamSink * _Nullable sink = virtioSoundDeviceOutputStreamConfiguration.sink;
                    __kindof SVAudioOutputStreamSink * _Nullable sinkObject;
                    if (sink == nil) {
                        sinkObject = nil;
                    } else if ([sink isKindOfClass:[VZHostAudioOutputStreamSink class]]) {
                        sinkObject = [[SVHostAudioOutputStreamSink alloc] initWithContext:managedObjectContext];
                    } else {
                        abort();
                    }
                    virtioSoundDeviceOutputStreamConfigurationObject.sink = sinkObject;
                    [sinkObject release];
                    
                    [streamsObject addObject:virtioSoundDeviceOutputStreamConfigurationObject];
                    [virtioSoundDeviceOutputStreamConfigurationObject release];
                } else if ([stream isKindOfClass:[VZVirtioSoundDeviceInputStreamConfiguration class]]) {
                    auto virtioSoundDeviceInputStreamConfiguration = static_cast<VZVirtioSoundDeviceInputStreamConfiguration *>(stream);
                    
                    SVVirtioSoundDeviceInputStreamConfiguration *virtioSoundDeviceInputStreamConfigurationObject = [[SVVirtioSoundDeviceInputStreamConfiguration alloc] initWithContext:managedObjectContext];
                    
                    __kindof VZAudioInputStreamSource * _Nullable source = virtioSoundDeviceInputStreamConfiguration.source;
                    __kindof SVAudioInputStreamSource * _Nullable sourceObject;
                    if (source == nil) {
                        sourceObject = nil;
                    } else if ([source isKindOfClass:[VZHostAudioInputStreamSource class]]) {
                        sourceObject = [[SVHostAudioInputStreamSource alloc] initWithContext:managedObjectContext];
                    } else {
                        abort();
                    }
                    
                    virtioSoundDeviceInputStreamConfigurationObject.source = sourceObject;
                    [sourceObject release];
                    
                    [streamsObject addObject:virtioSoundDeviceInputStreamConfigurationObject];
                    [virtioSoundDeviceInputStreamConfigurationObject release];
                } else {
                    abort();
                }
            }
            
            virtioSoundDeviceConfigurationObject.streams = streamsObject;
            [streamsObject release];
            [audioDeviceObjects addObject:virtioSoundDeviceConfigurationObject];
            [virtioSoundDeviceConfigurationObject release];
        } else {
            abort();
        }
    }
    
    return [audioDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVDirectorySharingDeviceConfiguration *> *)_isolated_makeManagedObjectsFromDirectorySharingDevices:(NSArray<__kindof VZDirectorySharingDeviceConfiguration *> *)directorySharingDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVDirectorySharingDeviceConfiguration *> *directorySharingDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:directorySharingDevices.count];
    
    for (__kindof VZDirectorySharingDeviceConfiguration *directorySharingDevice in directorySharingDevices) {
        if ([directorySharingDevice isKindOfClass:[VZVirtioFileSystemDeviceConfiguration class]]) {
            auto virtioFileSystemDeviceConfiguration = static_cast<VZVirtioFileSystemDeviceConfiguration *>(directorySharingDevice);
            
            SVVirtioFileSystemDeviceConfiguration *virtioFileSystemDeviceConfigurationObject = [[SVVirtioFileSystemDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            __kindof VZDirectoryShare * _Nullable share = virtioFileSystemDeviceConfiguration.share;
            __kindof SVDirectoryShare * _Nullable shareObject;
            if (share == nil) {
                shareObject = nil;
            } else if ([share isKindOfClass:[VZMultipleDirectoryShare class]]) {
                auto multipleDirectoryShare = static_cast<VZMultipleDirectoryShare *>(share);
                
                SVMultipleDirectoryShare *multipleDirectoryShareObject = [[SVMultipleDirectoryShare alloc] initWithContext:managedObjectContext];
                
                NSMutableArray<NSString *> *directoryNames = [[NSMutableArray alloc] initWithCapacity:multipleDirectoryShare.directories.count];
                NSMutableOrderedSet<SVSharedDirectory *> *directoryObjects = [[NSMutableOrderedSet alloc] initWithCapacity:multipleDirectoryShare.directories.count];
                
                [multipleDirectoryShare.directories enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull name, VZSharedDirectory * _Nonnull sharedDirectory, BOOL * _Nonnull stop) {
                    SVSharedDirectory *directoryObject = [[SVSharedDirectory alloc] initWithContext:managedObjectContext];
                    
                    NSURL *URL = sharedDirectory.URL;
                    assert([URL startAccessingSecurityScopedResource]);
                    NSError * _Nullable error = nil;
                    directoryObject.bookmarkData = [URL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                    assert(error == nil);
                    [URL stopAccessingSecurityScopedResource];
                    
                    directoryObject.readOnly = sharedDirectory.readOnly;
                    
                    [directoryNames addObject:name];
                    [directoryObjects addObject:directoryObject];
                    
                    [directoryObject release];
                }];
                
                assert(directoryNames.count == directoryObjects.count);
                
                multipleDirectoryShareObject.directoryNames = directoryNames;
                [directoryNames release];
                multipleDirectoryShareObject.directories = directoryObjects;
                [directoryObjects release];
                
                shareObject = multipleDirectoryShareObject;
            } else if ([share isKindOfClass:[VZSingleDirectoryShare class]]) {
                auto singleDirectoryShare = static_cast<VZSingleDirectoryShare *>(share);
                SVSingleDirectoryShare *singleDirectoryShareObject = [[SVSingleDirectoryShare alloc] initWithContext:managedObjectContext];
                
                SVSharedDirectory *directoryObject = [[SVSharedDirectory alloc] initWithContext:managedObjectContext];
                
                NSURL *URL = singleDirectoryShare.directory.URL;
                assert([URL startAccessingSecurityScopedResource]);
                NSError * _Nullable error = nil;
                directoryObject.bookmarkData = [URL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                assert(error == nil);
                [URL stopAccessingSecurityScopedResource];
                
                directoryObject.readOnly = singleDirectoryShare.directory.readOnly;
                
                singleDirectoryShareObject.directory = directoryObject;
                [directoryObject release];
                
                shareObject = singleDirectoryShareObject;
            } else {
                abort();
            }
            
            virtioFileSystemDeviceConfigurationObject.share = shareObject;
            [shareObject release];
            
            virtioFileSystemDeviceConfigurationObject.tag = virtioFileSystemDeviceConfiguration.tag;
            
            [directorySharingDeviceObjects addObject:virtioFileSystemDeviceConfigurationObject];
            [virtioFileSystemDeviceConfigurationObject release];
        } else {
            abort();
        }
    }
    
    return [directorySharingDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVAcceleratorDeviceConfiguration *> *)_isolated_makeManagedObjectsFromAcceleratorDevices:(NSArray *)acceleratorDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVAcceleratorDeviceConfiguration *> *acceleratorDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:acceleratorDevices.count];
    
    for (id acceleratorDevice in acceleratorDevices) {
        if ([acceleratorDevice isKindOfClass:objc_lookUpClass("_VZMacNeuralEngineDeviceConfiguration")]) {
            SVMacNeuralEngineDeviceConfiguration *object = [[SVMacNeuralEngineDeviceConfiguration alloc] initWithContext:managedObjectContext];
            [acceleratorDeviceObjects addObject:object];
            [object release];
        } else {
            abort();
        }
    }
    
    return [acceleratorDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVCoprocessorConfiguration *> *)_isolated_makeManagedObjectsFromCoprocessors:(NSArray *)coprocessors {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVCoprocessorConfiguration *> *coprocessorObjects = [[NSMutableOrderedSet alloc] initWithCapacity:coprocessors.count];
    
    for (id coprocessor in coprocessors) {
        if ([coprocessor isKindOfClass:objc_lookUpClass("_VZSEPCoprocessorConfiguration")]) {
            SVSEPCoprocessorConfiguration *SEPCoprocessorConfigurationObject = [[SVSEPCoprocessorConfiguration alloc] initWithContext:managedObjectContext];
            
            {
                id storage = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(coprocessor, sel_registerName("storage"));
                NSURL *URL = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(storage, sel_registerName("URL"));
                assert(URL != nil);
                
                SVSEPStorage *storageObject = [[SVSEPStorage alloc] initWithContext:managedObjectContext];
                
                assert([URL startAccessingSecurityScopedResource]);
                NSError * _Nullable error = nil;
                storageObject.bookmarkData = [URL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                assert(error == nil);
                [URL stopAccessingSecurityScopedResource];
                
                SEPCoprocessorConfigurationObject.storage = storageObject;
                [storageObject release];
            }
            
            {
                NSURL * _Nullable romBinaryURL = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(coprocessor, sel_registerName("romBinaryURL"));
                if (romBinaryURL != nil) {
                    assert([romBinaryURL startAccessingSecurityScopedResource]);
                    NSError * _Nullable error = nil;
                    SEPCoprocessorConfigurationObject.romBinaryBookmarkData = [romBinaryURL bookmarkDataWithOptions:NSURLBookmarkCreationWithSecurityScope includingResourceValuesForKeys:nil relativeToURL:nil error:&error];
                    assert(error == nil);
                    [romBinaryURL stopAccessingSecurityScopedResource];
                }
            }
            
            [coprocessorObjects addObject:SEPCoprocessorConfigurationObject];
            [SEPCoprocessorConfigurationObject release];
        } else {
            abort();
        }
    }
    
    return [coprocessorObjects autorelease];
}

- (NSOrderedSet<__kindof SVNetworkDeviceConfiguration *> *)_isolated_makeManagedObjectsFromNetworkDevices:(NSArray<__kindof VZNetworkDeviceConfiguration *> *)networkDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVNetworkDeviceConfiguration *> *networkDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:networkDevices.count];
    
    for (__kindof VZNetworkDeviceConfiguration *networkDevice in networkDevices) {
        if ([networkDevice isKindOfClass:[VZVirtioNetworkDeviceConfiguration class]]) {
            auto virtioNetworkDeviceConfiguration = static_cast<VZVirtioNetworkDeviceConfiguration *>(networkDevice);
            
            SVVirtioNetworkDeviceConfiguration *networkDeviceObject = [[SVVirtioNetworkDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            __kindof VZNetworkDeviceAttachment *attachment = virtioNetworkDeviceConfiguration.attachment;
            __kindof SVNetworkDeviceAttachment * _Nullable attachmentObject;
            if (attachment == nil) {
                attachmentObject = nil;
            } else if ([attachment isKindOfClass:[VZNATNetworkDeviceAttachment class]]) {
                attachmentObject = [[SVNATNetworkDeviceAttachment alloc] initWithContext:managedObjectContext];
            } else {
                abort();
            }
            networkDeviceObject.attachment = attachmentObject;
            [attachmentObject release];
            
            SVMACAddress *MACAddressObject = [[SVMACAddress alloc] initWithContext:managedObjectContext];
            ether_addr_t ethernetAddress = virtioNetworkDeviceConfiguration.MACAddress.ethernetAddress;
            MACAddressObject.ethernetAddress = [NSData dataWithBytes:&ethernetAddress length:sizeof(ether_addr_t)];
            networkDeviceObject.macAddress = MACAddressObject;
            [MACAddressObject release];
            
            [networkDeviceObjects addObject:networkDeviceObject];
            [networkDeviceObject release];
        } else {
            abort();
        }
    }
    
    return [networkDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVPointingDeviceConfiguration *> *)_isolated_makeManagedObjectsFromPointingDevices:(NSArray<__kindof VZPointingDeviceConfiguration *> *)pointingDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVPointingDeviceConfiguration *> *pointingDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:pointingDevices.count];
    
    for (__kindof VZPointingDeviceConfiguration *pointingDevice in pointingDevices) {
        if ([pointingDevice isKindOfClass:[VZUSBScreenCoordinatePointingDeviceConfiguration class]]) {
            SVUSBScreenCoordinatePointingDeviceConfiguration *object = [[SVUSBScreenCoordinatePointingDeviceConfiguration alloc] initWithContext:managedObjectContext];
            [pointingDeviceObjects addObject:object];
            [object release];
        } else if ([pointingDevice isKindOfClass:[VZMacTrackpadConfiguration class]]) {
            SVMacTrackpadConfiguration *object = [[SVMacTrackpadConfiguration alloc] initWithContext:managedObjectContext];
            [pointingDeviceObjects addObject:object];
            [object release];
        } else {
            abort();
        }
    }
    
    return [pointingDeviceObjects autorelease];
}

- (NSOrderedSet<__kindof SVGraphicsDeviceConfiguration *> *)_isolated_makeManagedObjectsFromGraphicsDevices:(NSArray<__kindof VZGraphicsDeviceConfiguration *> *)graphicsDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVGraphicsDeviceConfiguration *> *graphicsDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:graphicsDevices.count];
    
    for (__kindof VZGraphicsDeviceConfiguration *graphicsDeviceConfiguration in graphicsDevices) {
        if ([graphicsDeviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]) {
            auto macGraphicsDeviceConfiguration = static_cast<VZMacGraphicsDeviceConfiguration *>(graphicsDeviceConfiguration);
            
            SVMacGraphicsDeviceConfiguration *macGraphicsDeviceConfigurationObject = [[SVMacGraphicsDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            BOOL _prefersLowPower = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(graphicsDeviceConfiguration, sel_registerName("_prefersLowPower"));
            macGraphicsDeviceConfigurationObject.prefersLowPower = _prefersLowPower;
            
            for (VZMacGraphicsDisplayConfiguration *macGraphicsDisplayConfiguration in macGraphicsDeviceConfiguration.displays) {
                SVMacGraphicsDisplayConfiguration *macGraphicsDisplayConfigurationObject = [[SVMacGraphicsDisplayConfiguration alloc] initWithContext:managedObjectContext];
                
                NSInteger _displayMode = reinterpret_cast<NSInteger (*)(id, SEL)>(objc_msgSend)(macGraphicsDisplayConfiguration, sel_registerName("_displayMode"));
                
                macGraphicsDisplayConfigurationObject.displayMode = _displayMode;
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

- (NSOrderedSet<__kindof SVPowerSourceDeviceConfiguration *> *)_isolated_makeManagedObjectsFromPowerSourceDevices:(NSArray *)powerSourceDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVPowerSourceDeviceConfiguration *> *powerSourceDevicesObjects = [[NSMutableOrderedSet alloc] initWithCapacity:powerSourceDevices.count];
    
    for (id powerSourceDevice in powerSourceDevices) {
        if ([powerSourceDevice isKindOfClass:objc_lookUpClass("_VZMacBatteryPowerSourceDeviceConfiguration")]) {
            SVMacBatteryPowerSourceDeviceConfiguration *object = [[SVMacBatteryPowerSourceDeviceConfiguration alloc] initWithContext:managedObjectContext];
            
            id _Nullable source = reinterpret_cast<id (*)(id, SEL)>(objc_msgSend)(powerSourceDevice, sel_registerName("source"));
            __kindof SVMacBatterySource * _Nullable sourceObject;
            if (source == nil) {
                sourceObject = nil;
            } else if ([source isKindOfClass:objc_lookUpClass("_VZMacHostBatterySource")]) {
                sourceObject = [[SVMacHostBatterySource alloc] initWithContext:managedObjectContext];
            } else if ([source isKindOfClass:objc_lookUpClass("_VZMacSyntheticBatterySource")]) {
                SVMacSyntheticBatterySource *macSyntheticBatterySource = [[SVMacSyntheticBatterySource alloc] initWithContext:managedObjectContext];
                macSyntheticBatterySource.charge = reinterpret_cast<double (*)(id, SEL)>(objc_msgSend)(source, sel_registerName("charge"));
                macSyntheticBatterySource.connectivity = reinterpret_cast<int64_t (*)(id, SEL)>(objc_msgSend)(source, sel_registerName("connectivity"));
                
                sourceObject = macSyntheticBatterySource;
            } else {
                abort();
            }
            
            object.source = sourceObject;
            [sourceObject release];
            
            [powerSourceDevicesObjects addObject:object];
            [object release];
        } else if ([powerSourceDevice isKindOfClass:objc_lookUpClass("_VZMacWallPowerSourceDeviceConfiguration")]) {
            SVMacWallPowerSourceDeviceConfiguration *object = [[SVMacWallPowerSourceDeviceConfiguration alloc] initWithContext:managedObjectContext];
            [powerSourceDevicesObjects addObject:object];
            [object release];
        } else {
            abort();
        }
    }
    
    return [powerSourceDevicesObjects autorelease];
}

- (NSOrderedSet<__kindof SVStorageDeviceConfiguration *> *)_isolated_makeManagedObjectsFromStorageDevices:(NSArray<VZStorageDeviceConfiguration *> *)storageDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVStorageDeviceConfiguration *> *storageDeviceObjects = [[NSMutableOrderedSet alloc] initWithCapacity:storageDevices.count];
    
    for (__kindof VZStorageDeviceConfiguration *storageDeviceConfiguration in storageDevices) {
        __kindof SVStorageDeviceConfiguration *storageDeviceConfigurationObject;
        
        if ([storageDeviceConfiguration isKindOfClass:[VZVirtioBlockDeviceConfiguration class]]) {
            storageDeviceConfigurationObject = [[SVVirtioBlockDeviceConfiguration alloc] initWithContext:managedObjectContext];
        } else if ([storageDeviceConfiguration isKindOfClass:[VZNVMExpressControllerDeviceConfiguration class]]) {
            storageDeviceConfigurationObject = [[SVNVMExpressControllerDeviceConfiguration alloc] initWithContext:managedObjectContext];
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
        } else if ([storageDeviceAttachment isKindOfClass:[VZDiskBlockDeviceStorageDeviceAttachment class]]) {
            auto diskBlockDeviceStorageDeviceAttachment = static_cast<VZDiskBlockDeviceStorageDeviceAttachment *>(storageDeviceAttachment);
            
            SVDiskBlockDeviceStorageDeviceAttachment *diskBlockDeviceStorageDeviceAttachmentObject = [[SVDiskBlockDeviceStorageDeviceAttachment alloc] initWithContext:managedObjectContext];
            storageDeviceAttachmentObject = diskBlockDeviceStorageDeviceAttachmentObject;
            
            diskBlockDeviceStorageDeviceAttachmentObject.fileDescriptor = diskBlockDeviceStorageDeviceAttachment.fileHandle.fileDescriptor;
            diskBlockDeviceStorageDeviceAttachmentObject.readOnly = diskBlockDeviceStorageDeviceAttachment.readOnly;
            diskBlockDeviceStorageDeviceAttachmentObject.synchronizationMode = diskBlockDeviceStorageDeviceAttachment.synchronizationMode;
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

- (NSOrderedSet<__kindof SVUSBControllerConfiguration *> *)_isolated_makeManagedObjectsFromUSBControllers:(NSArray<__kindof VZUSBControllerConfiguration *> *)USBControllers {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVUSBControllerConfiguration *> *USBControllerObjects = [[NSMutableOrderedSet alloc] initWithCapacity:USBControllers.count];
    
    for (__kindof VZUSBControllerConfiguration *USBController in USBControllers) {
        if ([USBController isKindOfClass:[VZXHCIControllerConfiguration class]]) {
            auto XHCIControllerConfiguration = static_cast<VZXHCIControllerConfiguration *>(USBController);
            SVXHCIControllerConfiguration *XHCIControllerConfigurationObject = [[SVXHCIControllerConfiguration alloc] initWithContext:managedObjectContext];
            
            NSMutableOrderedSet<SVUSBMassStorageDeviceConfiguration *> *usbMassStorageDevicesObjects = [NSMutableOrderedSet new];
            
            for (id<VZUSBDeviceConfiguration> usbDevice in XHCIControllerConfiguration.usbDevices) {
                if ([usbDevice isKindOfClass:[VZUSBMassStorageDeviceConfiguration class]]) {
                    auto USBMassStorageDeviceConfiguration = static_cast<VZUSBMassStorageDeviceConfiguration *>(usbDevice);
                    
                    SVUSBMassStorageDeviceConfiguration *USBMassStorageDeviceConfigurationObject = [[SVUSBMassStorageDeviceConfiguration alloc] initWithContext:managedObjectContext];
                    
                    __kindof VZStorageDeviceAttachment *attachment = USBMassStorageDeviceConfiguration.attachment;
                    assert([attachment isKindOfClass:[VZDiskBlockDeviceStorageDeviceAttachment class]]);
                    
                    auto diskBlockDeviceStorageDeviceAttachment = static_cast<VZDiskBlockDeviceStorageDeviceAttachment *>(attachment);
                    SVDiskBlockDeviceStorageDeviceAttachment *diskBlockDeviceStorageDeviceAttachmentObject = [[SVDiskBlockDeviceStorageDeviceAttachment alloc] initWithContext:managedObjectContext];
                    diskBlockDeviceStorageDeviceAttachmentObject.fileDescriptor = diskBlockDeviceStorageDeviceAttachment.fileHandle.fileDescriptor;
                    diskBlockDeviceStorageDeviceAttachmentObject.readOnly = diskBlockDeviceStorageDeviceAttachment.readOnly;
                    diskBlockDeviceStorageDeviceAttachmentObject.synchronizationMode = diskBlockDeviceStorageDeviceAttachment.synchronizationMode;
                    
                    USBMassStorageDeviceConfigurationObject.attachment = diskBlockDeviceStorageDeviceAttachmentObject;
                    [diskBlockDeviceStorageDeviceAttachmentObject release];
                    
                    [usbMassStorageDevicesObjects addObject:USBMassStorageDeviceConfigurationObject];
                    [USBMassStorageDeviceConfigurationObject release];
                } else {
                    abort();
                }
            }
            
            XHCIControllerConfigurationObject.usbMassStorageDevices = usbMassStorageDevicesObjects;
            [usbMassStorageDevicesObjects release];
            
            [USBControllerObjects addObject:XHCIControllerConfigurationObject];
            [XHCIControllerConfigurationObject release];
        } else {
            abort();
        }
    }
    
    return [USBControllerObjects autorelease];
}

- (NSOrderedSet<__kindof SVMemoryBalloonDeviceConfiguration *> *)_isolated_makeManagedObjectsFromMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices {
    NSManagedObjectContext *managedObjectContext = self.backgroundContext;
    NSMutableOrderedSet<__kindof SVMemoryBalloonDeviceConfiguration *> *memoryBalloonDeviceConfigurationObjects = [[NSMutableOrderedSet alloc] initWithCapacity:memoryBalloonDevices.count];
    
    for (VZMemoryBalloonDeviceConfiguration *memoryBalloonDevice in memoryBalloonDevices) {
        if ([memoryBalloonDevice isKindOfClass:[VZVirtioTraditionalMemoryBalloonDeviceConfiguration class]]) {
            SVVirtioTraditionalMemoryBalloonDeviceConfiguration *object = [[SVVirtioTraditionalMemoryBalloonDeviceConfiguration alloc] initWithContext:managedObjectContext];
            [memoryBalloonDeviceConfigurationObjects addObject:object];
            [object release];
        } else {
            abort();
        }
    }
    
    return [memoryBalloonDeviceConfigurationObjects autorelease];
}

- (NSURL *)_refreshStaleURL:(NSURL *)URL NS_RETURNS_RETAINED {
    __block NSURL *newURL;
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSOpenPanel *openPanel = [NSOpenPanel new];
        
        openPanel.canChooseFiles = YES;
        openPanel.canChooseDirectories = YES;
        openPanel.directoryURL = URL;
        
        [openPanel runModal];
        
        newURL = [openPanel.URL copy];
        assert(newURL != nil);
        [openPanel release];
    });
    
    return newURL;
}

@end
