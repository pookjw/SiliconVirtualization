//
//  Model.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVVirtualMachine.h"
#import "SVVirtualMachineStartOptions.h"
#import "SVMacOSVirtualMachineStartOptions.h"
#import "SVVirtualMachineConfiguration.h"
#import "SVGraphicsDeviceConfiguration.h"
#import "SVMacGraphicsDeviceConfiguration.h"
#import "SVVirtioGraphicsDeviceConfiguration.h"
#import "SVGraphicsDisplayConfiguration.h"
#import "SVMacGraphicsDeviceConfiguration.h"
#import "SVVirtioGraphicsScanoutConfiguration.h"
#import "SVStorageDeviceConfiguration.h"
#import "SVVirtioBlockDeviceConfiguration.h"
#import "SVDiskImageStorageDeviceAttachment.h"
#import "SVStorageDeviceAttachment.h"
#import "SVBootLoader.h"
#import "SVMacOSBootLoader.h"
#import "SVPlatformConfiguration.h"
#import "SVMacPlatformConfiguration.h"
#import "SVMacAuxiliaryStorage.h"
#import "SVMacHardwareModel.h"
#import "SVMacMachineIdentifier.h"
#import "SVGenericPlatformConfiguration.h"
#import "SVGenericMachineIdentifier.h"
#import "SVKeyboardConfiguration.h"
#import "SVMacKeyboardConfiguration.h"
#import "SVUSBKeyboardConfiguration.h"
#import "SVPointingDeviceConfiguration.h"
#import "SVUSBScreenCoordinatePointingDeviceConfiguration.h"
#import "SVMacTrackpadConfiguration.h"
#import "SVNetworkDeviceConfiguration.h"
#import "SVVirtioNetworkDeviceConfiguration.h"
#import "SVNetworkDeviceAttachment.h"
#import "SVNATNetworkDeviceAttachment.h"
#import "SVMACAddress.h"
#import "SVAudioDeviceConfiguration.h"
#import "SVVirtioSoundDeviceConfiguration.h"
#import "SVVirtioSoundDeviceStreamConfiguration.h"
#import "SVVirtioSoundDeviceInputStreamConfiguration.h"
#import "SVVirtioSoundDeviceOutputStreamConfiguration.h"
#import "SVAudioInputStreamSource.h"
#import "SVHostAudioInputStreamSource.h"
#import "SVAudioOutputStreamSink.h"
#import "SVHostAudioOutputStreamSink.h"
#import "SVUSBControllerConfiguration.h"
#import "SVXHCIControllerConfiguration.h"
#import "SVUSBMassStorageDeviceConfiguration.h"
#import "SVDiskBlockDeviceStorageDeviceAttachment.h"
#import "SVNVMExpressControllerDeviceConfiguration.h"
#import "SVDirectorySharingDeviceConfiguration.h"
#import "SVVirtioFileSystemDeviceConfiguration.h"
#import "SVDirectoryShare.h"
#import "SVMultipleDirectoryShare.h"
#import "SVSingleDirectoryShare.h"
#import "SVSharedDirectory.h"
#import "SVMacBatterySource.h"
#import "SVMacHostBatterySource.h"
#import "SVMacSyntheticBatterySource.h"
