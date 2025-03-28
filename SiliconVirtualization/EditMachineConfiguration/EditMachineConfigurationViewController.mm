//
//  EditMachineConfigurationViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineConfigurationViewController.h"
#import "EditMachineSidebarViewController.h"
#import "EditMachineCPUViewController.h"
#import "EditMachineMemoryViewController.h"
#import "EditMachineKeyboardsViewController.h"
#import "EditMachineGraphicsViewController.h"
#import "EditMachineStoragesViewController.h"
#import "EditMachineBootLoaderViewController.h"
#import "EditMachinePlatformViewController.h"
#import "EditMachinePointingDevicesViewController.h"
#import "EditMachineNetworksViewController.h"
#import "EditMachineAudioDevicesViewController.h"
#import "EditMachineConfigurationUSBControllersViewController.h"
#import "EditMachineConfigurationDirectorySharingViewController.h"
#import "EditMachinePowerSourceDevicesViewController.h"
#import "EditMachineBiometricDevicesViewController.h"
#import "EditMachineCoprocessorsViewController.h"
#import "EditMachineMacAcceleratorDevicesViewController.h"
#import "EditMachineConfigurationMemoryBalloonDevicesViewController.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineConfigurationViewController () <EditMachineSidebarViewControllerDelegate, EditMachineBootLoaderViewControllerDelegate, EditMachineCPUViewControllerDelegate, EditMachineMemoryViewControllerDelegate, EditMachineKeyboardsViewControllerDelegate, EditMachineNetworksViewControllerDelegate, EditMachinePointingDevicesViewControllerDelegate, EditMachineGraphicsViewControllerDelegate, EditMachineStoragesViewControllerDelegate, EditMachinePlatformViewControllerDelegate, EditMachineAudioDevicesViewControllerDelegate, EditMachineConfigurationUSBControllersViewControllerDelegate, EditMachineConfigurationDirectorySharingViewControllerDelegate, EditMachinePowerSourceDevicesViewControllerDelegate, EditMachineBiometricDevicesViewControllerDelegate, EditMachineCoprocessorsViewControllerDelegate, EditMachineMacAcceleratorDevicesViewControllerDelegate, EditMachineConfigurationMemoryBalloonDevicesViewControllerDelegate>
@property (copy, nonatomic, setter=_setConfiguration:) VZVirtualMachineConfiguration *configuration;

@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_bootLoaderViewController) EditMachineBootLoaderViewController *bootLoaderViewController;
@property (retain, nonatomic, readonly, getter=_bootLoaderSplitViewItem) NSSplitViewItem *bootLoaderSplitViewItem;

@property (retain, nonatomic, readonly, getter=_sidebarViewController) EditMachineSidebarViewController *sidebarViewController;
@property (retain, nonatomic, readonly, getter=_sidebarSplitViewItem) NSSplitViewItem *sidebarSplitViewItem;

@property (retain, nonatomic, readonly, getter=_CPUViewController) EditMachineCPUViewController *CPUViewController;
@property (retain, nonatomic, readonly, getter=_CPUSplitViewItem) NSSplitViewItem *CPUSplitViewItem;

@property (retain, nonatomic, readonly, getter=_memoryViewController) EditMachineMemoryViewController *memoryViewController;
@property (retain, nonatomic, readonly, getter=_memorySplitViewItem) NSSplitViewItem *memorySplitViewItem;

@property (retain, nonatomic, readonly, getter=_audioDevicesViewController) EditMachineAudioDevicesViewController *audioDevicesViewController;
@property (retain, nonatomic, readonly, getter=_audioDevicesSplitViewItem) NSSplitViewItem *audioDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_keyboardsViewController) EditMachineKeyboardsViewController *keyboardsViewController;
@property (retain, nonatomic, readonly, getter=_keyboardsSplitViewItem) NSSplitViewItem *keyboardsSplitViewItem;

@property (retain, nonatomic, readonly, getter=_networksViewController) EditMachineNetworksViewController *networksViewController;
@property (retain, nonatomic, readonly, getter=_networksSplitViewItem) NSSplitViewItem *networksSplitViewItem;

@property (retain, nonatomic, readonly, getter=_pointingDevicesViewController) EditMachinePointingDevicesViewController *pointingDevicesViewController;
@property (retain, nonatomic, readonly, getter=_pointingDevicesSplitViewItem) NSSplitViewItem *pointingDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_graphicsViewController) EditMachineGraphicsViewController *graphicsViewController;
@property (retain, nonatomic, readonly, getter=_graphicsSplitViewItem) NSSplitViewItem *graphicsSplitViewItem;

@property (retain, nonatomic, readonly, getter=_storagesViewController) EditMachineStoragesViewController *storagesViewController;
@property (retain, nonatomic, readonly, getter=_storagesSplitViewItem) NSSplitViewItem *storagesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_platformViewController) EditMachinePlatformViewController *platformViewController;
@property (retain, nonatomic, readonly, getter=_platformSplitViewItem) NSSplitViewItem *platformSplitViewItem;

@property (retain, nonatomic, readonly, getter=_usbViewController) EditMachineConfigurationUSBControllersViewController *usbViewController;
@property (retain, nonatomic, readonly, getter=_usbSplitViewItem) NSSplitViewItem *usbSplitViewItem;

@property (retain, nonatomic, readonly, getter=_powerSourceDevicesViewController) EditMachinePowerSourceDevicesViewController *powerSourceDevicesViewController;
@property (retain, nonatomic, readonly, getter=_powerSourceDevicesSplitViewItem) NSSplitViewItem *powerSourceDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_directorySharingViewController) EditMachineConfigurationDirectorySharingViewController *directorySharingViewController;
@property (retain, nonatomic, readonly, getter=_directorySharingSplitViewItem) NSSplitViewItem *directorySharingSplitViewItem;

@property (retain, nonatomic, readonly, getter=_biometricDevicesViewController) EditMachineBiometricDevicesViewController *biometricDevicesViewController;
@property (retain, nonatomic, readonly, getter=_biometricDevicesSplitViewItem) NSSplitViewItem *biometricDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_coprocessorsViewController) EditMachineCoprocessorsViewController *coprocessorsViewController;
@property (retain, nonatomic, readonly, getter=_coprocessorsSplitViewItem) NSSplitViewItem *coprocessorsSplitViewItem;

@property (retain, nonatomic, readonly, getter=_macAcceleratorDevicesViewController) EditMachineMacAcceleratorDevicesViewController *macAcceleratorDevicesViewController;
@property (retain, nonatomic, readonly, getter=_macAcceleratorDevicesSplitViewItem) NSSplitViewItem *macAcceleratorDevicesSplitViewItem;

@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesViewController) EditMachineConfigurationMemoryBalloonDevicesViewController *memoryBalloonDevicesViewController;
@property (retain, nonatomic, readonly, getter=_memoryBalloonDevicesSplitViewItem) NSSplitViewItem *memoryBalloonDevicesSplitViewItem;
@end

@implementation EditMachineConfigurationViewController
@synthesize bootLoaderViewController = _bootLoaderViewController;
@synthesize bootLoaderSplitViewItem = _bootLoaderSplitViewItem;
@synthesize splitViewController = _splitViewController;
@synthesize sidebarViewController = _sidebarViewController;
@synthesize sidebarSplitViewItem = _sidebarSplitViewItem;
@synthesize CPUViewController = _CPUViewController;
@synthesize CPUSplitViewItem = _CPUSplitViewItem;
@synthesize memoryViewController = _memoryViewController;
@synthesize memorySplitViewItem = _memorySplitViewItem;
@synthesize audioDevicesViewController = _audioDevicesViewController;
@synthesize audioDevicesSplitViewItem = _audioDevicesSplitViewItem;
@synthesize keyboardsViewController = _keyboardsViewController;
@synthesize keyboardsSplitViewItem = _keyboardsSplitViewItem;
@synthesize networksViewController = _networksViewController;
@synthesize networksSplitViewItem = _networksSplitViewItem;
@synthesize pointingDevicesViewController = _pointingDevicesViewController;
@synthesize pointingDevicesSplitViewItem = _pointingDevicesSplitViewItem;
@synthesize graphicsViewController = _graphicsViewController;
@synthesize graphicsSplitViewItem = _graphicsSplitViewItem;
@synthesize storagesViewController = _storagesViewController;
@synthesize storagesSplitViewItem = _storagesSplitViewItem;
@synthesize platformViewController = _platformViewController;
@synthesize platformSplitViewItem = _platformSplitViewItem;
@synthesize usbViewController = _usbViewController;
@synthesize usbSplitViewItem = _usbSplitViewItem;
@synthesize powerSourceDevicesViewController = _powerSourceDevicesViewController;
@synthesize powerSourceDevicesSplitViewItem = _powerSourceDevicesSplitViewItem;
@synthesize directorySharingViewController = _directorySharingViewController;
@synthesize directorySharingSplitViewItem = _directorySharingSplitViewItem;
@synthesize biometricDevicesViewController = _biometricDevicesViewController;
@synthesize biometricDevicesSplitViewItem = _biometricDevicesSplitViewItem;
@synthesize coprocessorsViewController = _coprocessorsViewController;
@synthesize coprocessorsSplitViewItem = _coprocessorsSplitViewItem;
@synthesize macAcceleratorDevicesViewController = _macAcceleratorDevicesViewController;
@synthesize macAcceleratorDevicesSplitViewItem = _macAcceleratorDevicesSplitViewItem;
@synthesize memoryBalloonDevicesViewController = _memoryBalloonDevicesViewController;
@synthesize memoryBalloonDevicesSplitViewItem = _memoryBalloonDevicesSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
    }
    
    return self;
}

- (void)dealloc {
    [_bootLoaderViewController release];
    [_bootLoaderSplitViewItem release];
    [_configuration release];
    [_splitViewController release];
    [_sidebarViewController release];
    [_sidebarSplitViewItem release];
    [_CPUViewController release];
    [_CPUSplitViewItem release];
    [_memoryViewController release];
    [_memorySplitViewItem release];
    [_audioDevicesViewController release];
    [_audioDevicesSplitViewItem release];
    [_keyboardsViewController release];
    [_keyboardsSplitViewItem release];
    [_networksViewController release];
    [_networksSplitViewItem release];
    [_pointingDevicesViewController release];
    [_pointingDevicesSplitViewItem release];
    [_graphicsViewController release];
    [_graphicsSplitViewItem release];
    [_storagesViewController release];
    [_storagesSplitViewItem release];
    [_platformViewController release];
    [_platformSplitViewItem release];
    [_usbViewController release];
    [_usbSplitViewItem release];
    [_powerSourceDevicesViewController release];
    [_powerSourceDevicesSplitViewItem release];
    [_directorySharingViewController release];
    [_directorySharingSplitViewItem release];
    [_biometricDevicesViewController release];
    [_biometricDevicesSplitViewItem release];
    [_coprocessorsViewController release];
    [_coprocessorsSplitViewItem release];
    [_macAcceleratorDevicesViewController release];
    [_macAcceleratorDevicesSplitViewItem release];
    [_memoryBalloonDevicesViewController release];
    [_memoryBalloonDevicesSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    [self addChildViewController:splitViewController];
    
    EditMachineSidebarItemModel *itemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeDirectorySharing];
    [self.sidebarViewController selectItemModel:itemModel notifyingDelegate:YES];
    [itemModel release];
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    
    [splitViewController addSplitViewItem:self.sidebarSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineSidebarViewController *)_sidebarViewController {
    if (auto sidebarViewController = _sidebarViewController) return sidebarViewController;
    
    EditMachineSidebarViewController *sidebarViewController = [EditMachineSidebarViewController new];
    sidebarViewController.delegate = self;
    
    EditMachineSidebarItemModel *bootLoaderItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeBootLoader];
    EditMachineSidebarItemModel *platformItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypePlatform];
    EditMachineSidebarItemModel *CPUItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeCPU];
    EditMachineSidebarItemModel *memoryItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeMemory];
    EditMachineSidebarItemModel *keyboardsItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeKeyboards];
    EditMachineSidebarItemModel *networksItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeNetworks];
    EditMachineSidebarItemModel *graphicsItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeGraphics];
    EditMachineSidebarItemModel *powerSourceDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypePowerSourceDevices];
    EditMachineSidebarItemModel *pointingDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypePointingDevices];
    EditMachineSidebarItemModel *storagesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeStorages];
    EditMachineSidebarItemModel *audioItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeAudio];
    EditMachineSidebarItemModel *usbItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeUSB];
    EditMachineSidebarItemModel *directorySharingItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeDirectorySharing];
    EditMachineSidebarItemModel *biometicDeviceItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeBiometicDevice];
    EditMachineSidebarItemModel *coprocessorsItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeCoprocessors];
    EditMachineSidebarItemModel *acceleratorDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeAcceleratorDevices];
    EditMachineSidebarItemModel *memoryBalloonDevicesItemModel = [[EditMachineSidebarItemModel alloc] initWithType:EditMachineSidebarItemModelTypeMemoryBalloonDevices];
    
    sidebarViewController.itemModels = @[
        bootLoaderItemModel,
        platformItemModel,
        CPUItemModel,
        memoryItemModel,
        memoryBalloonDevicesItemModel,
        audioItemModel,
        keyboardsItemModel,
        networksItemModel,
        graphicsItemModel,
        powerSourceDevicesItemModel,
        pointingDevicesItemModel,
        storagesItemModel,
        usbItemModel,
        directorySharingItemModel,
        biometicDeviceItemModel,
        coprocessorsItemModel,
        acceleratorDevicesItemModel
    ];
    
    [bootLoaderItemModel release];
    [platformItemModel release];
    [CPUItemModel release];
    [memoryItemModel release];
    [memoryBalloonDevicesItemModel release];
    [keyboardsItemModel release];
    [networksItemModel release];
    [graphicsItemModel release];
    [powerSourceDevicesItemModel release];
    [pointingDevicesItemModel release];
    [storagesItemModel release];
    [audioItemModel release];
    [usbItemModel release];
    [directorySharingItemModel release];
    [biometicDeviceItemModel release];
    [coprocessorsItemModel release];
    [acceleratorDevicesItemModel release];
    
    _sidebarViewController = sidebarViewController;
    return sidebarViewController;
}

- (NSSplitViewItem *)_sidebarSplitViewItem {
    if (auto sidebarSplitViewItem = _sidebarSplitViewItem) return sidebarSplitViewItem;
    
    NSSplitViewItem *sidebarSplitViewItem = [NSSplitViewItem sidebarWithViewController:self.sidebarViewController];
    sidebarSplitViewItem.canCollapse = NO;
    reinterpret_cast<void (*)(id, SEL, CGFloat)>(objc_msgSend)(sidebarSplitViewItem, sel_registerName("setMinimumSize:"), 200.);
    
    _sidebarSplitViewItem = [sidebarSplitViewItem retain];
    return sidebarSplitViewItem;
}

- (EditMachineBootLoaderViewController *)_bootLoaderViewController {
    if (auto bootLoaderViewController = _bootLoaderViewController) return bootLoaderViewController;
    
    EditMachineBootLoaderViewController *bootLoaderViewController = [[EditMachineBootLoaderViewController alloc] initWithConfiguration:self.configuration];
    bootLoaderViewController.delegate = self;
    
    _bootLoaderViewController = bootLoaderViewController;
    return bootLoaderViewController;
}

- (NSSplitViewItem *)_bootLoaderSplitViewItem {
    if (auto bootLoaderSplitViewItem = _bootLoaderSplitViewItem) return bootLoaderSplitViewItem;
    
    NSSplitViewItem *bootLoaderSplitViewItem = [NSSplitViewItem contentListWithViewController:self.bootLoaderViewController];
    
    _bootLoaderSplitViewItem = [bootLoaderSplitViewItem retain];
    return bootLoaderSplitViewItem;
}

- (EditMachineCPUViewController *)_CPUViewController {
    if (auto CPUViewController = _CPUViewController) return CPUViewController;
    
    EditMachineCPUViewController *CPUViewController = [[EditMachineCPUViewController alloc] initWithConfiguration:self.configuration];
    CPUViewController.delegate = self;
    
    _CPUViewController = CPUViewController;
    return CPUViewController;
}

- (NSSplitViewItem *)_CPUSplitViewItem {
    if (auto CPUSplitViewItem = _CPUSplitViewItem) return CPUSplitViewItem;
    
    NSSplitViewItem *CPUSplitViewItem = [NSSplitViewItem contentListWithViewController:self.CPUViewController];
    
    _CPUSplitViewItem = [CPUSplitViewItem retain];
    return CPUSplitViewItem;
}

- (EditMachineMemoryViewController *)_memoryViewController {
    if (auto memoryViewController = _memoryViewController) return memoryViewController;
    
    EditMachineMemoryViewController *memoryViewController = [[EditMachineMemoryViewController alloc] initWithConfiguration:self.configuration];
    memoryViewController.delegate = self;
    
    _memoryViewController = memoryViewController;
    return memoryViewController;
}

- (NSSplitViewItem *)_memorySplitViewItem {
    if (auto memorySplitViewItem = _memorySplitViewItem) return memorySplitViewItem;
    
    NSSplitViewItem *memorySplitViewItem = [NSSplitViewItem contentListWithViewController:self.memoryViewController];
    
    _memorySplitViewItem = [memorySplitViewItem retain];
    return memorySplitViewItem;
}

- (EditMachineGraphicsViewController *)_graphicsViewController {
    if (auto graphicsViewController = _graphicsViewController) return graphicsViewController;
    
    EditMachineGraphicsViewController *graphicsViewController = [[EditMachineGraphicsViewController alloc] initWithConfiguration:self.configuration];
    graphicsViewController.delegate = self;
    
    _graphicsViewController = graphicsViewController;
    return graphicsViewController;
}

- (NSSplitViewItem *)_graphicsSplitViewItem {
    if (auto graphicsSplitViewItem = _graphicsSplitViewItem) return graphicsSplitViewItem;
    
    NSSplitViewItem *graphicsSplitViewItem = [NSSplitViewItem contentListWithViewController:self.graphicsViewController];
    
    _graphicsSplitViewItem = [graphicsSplitViewItem retain];
    return graphicsSplitViewItem;
}

- (EditMachineAudioDevicesViewController *)_audioDevicesViewController {
    if (auto audioDevicesViewController = _audioDevicesViewController) return audioDevicesViewController;
    
    EditMachineAudioDevicesViewController *audioDevicesViewController = [[EditMachineAudioDevicesViewController alloc] initWithConfiguration:self.configuration];
    audioDevicesViewController.delegate = self;
    
    _audioDevicesViewController = audioDevicesViewController;
    return audioDevicesViewController;
}

- (NSSplitViewItem *)_audioDevicesSplitViewItem {
    if (auto audioDevicesSplitViewItem = _audioDevicesSplitViewItem) return audioDevicesSplitViewItem;
    
    NSSplitViewItem *audioDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.audioDevicesViewController];
    
    _audioDevicesSplitViewItem = [audioDevicesSplitViewItem retain];
    return audioDevicesSplitViewItem;
}

- (EditMachineKeyboardsViewController *)_keyboardsViewController {
    if (auto keyboardsViewController = _keyboardsViewController) return keyboardsViewController;
    
    EditMachineKeyboardsViewController *keyboardsViewController = [[EditMachineKeyboardsViewController alloc] initWithConfiguration:self.configuration];
    keyboardsViewController.delegate = self;
    
    _keyboardsViewController = keyboardsViewController;
    return keyboardsViewController;
}

- (NSSplitViewItem *)_keyboardsSplitViewItem {
    if (auto keyboardsSplitViewItem = _keyboardsSplitViewItem) return keyboardsSplitViewItem;
    
    NSSplitViewItem *keyboardsSplitViewItem = [NSSplitViewItem contentListWithViewController:self.keyboardsViewController];
    
    _keyboardsSplitViewItem = [keyboardsSplitViewItem retain];
    return keyboardsSplitViewItem;
}

- (EditMachineNetworksViewController *)_networksViewController {
    if (auto networksViewController = _networksViewController) return networksViewController;
    
    EditMachineNetworksViewController *networksViewController = [[EditMachineNetworksViewController alloc] initWithConfiguration:self.configuration];
    networksViewController.delegate = self;
    
    _networksViewController = networksViewController;
    return networksViewController;
}

- (NSSplitViewItem *)_networksSplitViewItem {
    if (auto networksSplitViewItem = _networksSplitViewItem) return networksSplitViewItem;
    
    NSSplitViewItem *networksSplitViewItem = [NSSplitViewItem contentListWithViewController:self.networksViewController];
    
    _networksSplitViewItem = [networksSplitViewItem retain];
    return networksSplitViewItem;
}

- (EditMachinePointingDevicesViewController *)_pointingDevicesViewController {
    if (auto pointingDevicesViewController = _pointingDevicesViewController) return pointingDevicesViewController;
    
    EditMachinePointingDevicesViewController *pointingDevicesViewController = [[EditMachinePointingDevicesViewController alloc] initWithConfiguration:self.configuration];
    pointingDevicesViewController.delegate = self;
    
    _pointingDevicesViewController = pointingDevicesViewController;
    return pointingDevicesViewController;
}

- (NSSplitViewItem *)_pointingDevicesSplitViewItem {
    if (auto pointingDevicesSplitViewItem = _pointingDevicesSplitViewItem) return pointingDevicesSplitViewItem;
    
    NSSplitViewItem *pointingDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.pointingDevicesViewController];
    
    _pointingDevicesSplitViewItem = [pointingDevicesSplitViewItem retain];
    return pointingDevicesSplitViewItem;
}

- (EditMachinePowerSourceDevicesViewController *)_powerSourceDevicesViewController {
    if (auto powerSourceDevicesViewController = _powerSourceDevicesViewController) return powerSourceDevicesViewController;
    
    EditMachinePowerSourceDevicesViewController *powerSourceDevicesViewController = [[EditMachinePowerSourceDevicesViewController alloc] initWithConfiguration:self.configuration];
    powerSourceDevicesViewController.delegate = self;
    
    _powerSourceDevicesViewController = powerSourceDevicesViewController;
    return powerSourceDevicesViewController;
}

- (NSSplitViewItem *)_powerSourceDevicesSplitViewItem {
    if (auto powerSourceDevicesSplitViewItem = _powerSourceDevicesSplitViewItem) return powerSourceDevicesSplitViewItem;
    
    NSSplitViewItem *powerSourceDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.powerSourceDevicesViewController];
    
    _powerSourceDevicesSplitViewItem = [powerSourceDevicesSplitViewItem retain];
    return powerSourceDevicesSplitViewItem;
}

- (EditMachineStoragesViewController *)_storagesViewController {
    if (auto storagesViewController = _storagesViewController) return storagesViewController;
    
    EditMachineStoragesViewController *storagesViewController = [[EditMachineStoragesViewController alloc] initWithConfiguration:self.configuration];
    storagesViewController.delegate = self;
    
    _storagesViewController = storagesViewController;
    return storagesViewController;
}

- (NSSplitViewItem *)_storagesSplitViewItem {
    if (auto storagesSplitViewItem = _storagesSplitViewItem) return storagesSplitViewItem;
    
    NSSplitViewItem *storagesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.storagesViewController];
    
    _storagesSplitViewItem = [storagesSplitViewItem retain];
    return storagesSplitViewItem;
}

- (EditMachinePlatformViewController *)_platformViewController {
    if (auto platformViewController = _platformViewController) return platformViewController;
    
    EditMachinePlatformViewController *platformViewController = [[EditMachinePlatformViewController alloc] initWithConfiguration:self.configuration];
    platformViewController.delegate = self;
    
    _platformViewController = platformViewController;
    return platformViewController;
}

- (NSSplitViewItem *)_platformSplitViewItem {
    if (auto platformSplitViewItem = _platformSplitViewItem) return platformSplitViewItem;
    
    NSSplitViewItem *platformSplitViewItem = [NSSplitViewItem contentListWithViewController:self.platformViewController];
    
    _platformSplitViewItem = [platformSplitViewItem retain];
    return platformSplitViewItem;
}

- (EditMachineConfigurationUSBControllersViewController *)_usbViewController {
    if (auto usbViewController = _usbViewController) return usbViewController;
    
    EditMachineConfigurationUSBControllersViewController *usbViewController = [[EditMachineConfigurationUSBControllersViewController alloc] initWithConfiguration:self.configuration];
    usbViewController.delegate = self;
    
    _usbViewController = usbViewController;
    return usbViewController;
}

- (NSSplitViewItem *)_usbSplitViewItem {
    if (auto usbSplitViewItem = _usbSplitViewItem) return usbSplitViewItem;
    
    NSSplitViewItem *usbSplitViewItem = [NSSplitViewItem contentListWithViewController:self.usbViewController];
    
    _usbSplitViewItem = [usbSplitViewItem retain];
    return usbSplitViewItem;
}

- (EditMachineConfigurationDirectorySharingViewController *)_directorySharingViewController {
    if (auto directorySharingViewController = _directorySharingViewController) return directorySharingViewController;
    
    EditMachineConfigurationDirectorySharingViewController *directorySharingViewController = [[EditMachineConfigurationDirectorySharingViewController alloc] initWithConfiguration:self.configuration];
    directorySharingViewController.delegate = self;
    
    _directorySharingViewController = directorySharingViewController;
    return directorySharingViewController;
}

- (NSSplitViewItem *)_directorySharingSplitViewItem {
    if (auto directorySharingSplitViewItem = _directorySharingSplitViewItem) return directorySharingSplitViewItem;
    
    NSSplitViewItem *directorySharingSplitViewItem = [NSSplitViewItem contentListWithViewController:self.directorySharingViewController];
    
    _directorySharingSplitViewItem = [directorySharingSplitViewItem retain];
    return directorySharingSplitViewItem;
}

- (EditMachineBiometricDevicesViewController *)_biometricDevicesViewController {
    if (auto biometricDevicesViewController = _biometricDevicesViewController) return biometricDevicesViewController;
    
    EditMachineBiometricDevicesViewController *biometricDevicesViewController = [[EditMachineBiometricDevicesViewController alloc] initWithConfiguration:self.configuration];
    biometricDevicesViewController.delegate = self;
    
    _biometricDevicesViewController = biometricDevicesViewController;
    return biometricDevicesViewController;
}

- (NSSplitViewItem *)_biometricDevicesSplitViewItem {
    if (auto biometricDevicesSplitViewItem = _biometricDevicesSplitViewItem) return biometricDevicesSplitViewItem;
    
    NSSplitViewItem *biometricDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.biometricDevicesViewController];
    
    _biometricDevicesSplitViewItem = [biometricDevicesSplitViewItem retain];
    return biometricDevicesSplitViewItem;
}

- (EditMachineCoprocessorsViewController *)_coprocessorsViewController {
    if (auto coprocessorsViewController = _coprocessorsViewController) return coprocessorsViewController;
    
    EditMachineCoprocessorsViewController *coprocessorsViewController = [[EditMachineCoprocessorsViewController alloc] initWithConfiguration:self.configuration];
    coprocessorsViewController.delegate = self;
    
    _coprocessorsViewController = coprocessorsViewController;
    return coprocessorsViewController;
}

- (NSSplitViewItem *)_coprocessorsSplitViewItem {
    if (auto coprocessorsSplitViewItem = _coprocessorsSplitViewItem) return coprocessorsSplitViewItem;
    
    NSSplitViewItem *coprocessorsSplitViewItem = [NSSplitViewItem contentListWithViewController:self.coprocessorsViewController];
    
    _coprocessorsSplitViewItem = [coprocessorsSplitViewItem retain];
    return coprocessorsSplitViewItem;
}

- (EditMachineMacAcceleratorDevicesViewController *)_macAcceleratorDevicesViewController {
    if (auto macAcceleratorDevicesViewController = _macAcceleratorDevicesViewController) return macAcceleratorDevicesViewController;
    
    EditMachineMacAcceleratorDevicesViewController *macAcceleratorDevicesViewController = [[EditMachineMacAcceleratorDevicesViewController alloc] initWithConfiguration:self.configuration];
    macAcceleratorDevicesViewController.delegate = self;
    
    _macAcceleratorDevicesViewController = macAcceleratorDevicesViewController;
    return macAcceleratorDevicesViewController;
}

- (NSSplitViewItem *)_macAcceleratorDevicesSplitViewItem {
    if (auto macAcceleratorDevicesSplitViewItem = _macAcceleratorDevicesSplitViewItem) return macAcceleratorDevicesSplitViewItem;
    
    NSSplitViewItem *macAcceleratorDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.macAcceleratorDevicesViewController];
    
    _macAcceleratorDevicesSplitViewItem = [macAcceleratorDevicesSplitViewItem retain];
    return macAcceleratorDevicesSplitViewItem;
}

- (EditMachineConfigurationMemoryBalloonDevicesViewController *)_memoryBalloonDevicesViewController {
    if (auto memoryBalloonDevicesViewController = _memoryBalloonDevicesViewController) return memoryBalloonDevicesViewController;
    
    EditMachineConfigurationMemoryBalloonDevicesViewController *memoryBalloonDevicesViewController = [EditMachineConfigurationMemoryBalloonDevicesViewController new];
    memoryBalloonDevicesViewController.delegate = self;
    
    _memoryBalloonDevicesViewController = memoryBalloonDevicesViewController;
    return memoryBalloonDevicesViewController;
}

- (NSSplitViewItem *)_memoryBalloonDevicesSplitViewItem {
    if (auto memoryBalloonDevicesSplitViewItem = _memoryBalloonDevicesSplitViewItem) return memoryBalloonDevicesSplitViewItem;
    
    NSSplitViewItem *memoryBalloonDevicesSplitViewItem = [NSSplitViewItem contentListWithViewController:self.memoryBalloonDevicesViewController];
    
    _memoryBalloonDevicesSplitViewItem = [memoryBalloonDevicesSplitViewItem retain];
    return memoryBalloonDevicesSplitViewItem;
}

- (void)_notifyDelegate {
    if (auto delegate = self.delegate) {
        [delegate editMachineViewController:self didUpdateConfiguration:self.configuration];
    }
}

- (void)editMachineSidebarViewController:(EditMachineSidebarViewController *)editMachineSidebarViewController didSelectItemModel:(EditMachineSidebarItemModel *)itemModel {
    switch (itemModel.type) {
        case EditMachineSidebarItemModelTypeBootLoader: {
            self.bootLoaderViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.bootLoaderSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypePlatform: {
            self.platformViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.platformSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeCPU: {
            self.CPUViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.CPUSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeMemory: {
            self.memoryViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.memorySplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypePointingDevices: {
            self.pointingDevicesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.pointingDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypePowerSourceDevices: {
            self.powerSourceDevicesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.powerSourceDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeAudio: {
            self.audioDevicesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.audioDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeKeyboards: {
            self.keyboardsViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.keyboardsSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeNetworks: {
            self.networksViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.networksSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeGraphics: {
            self.graphicsViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.graphicsSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeStorages: {
            self.storagesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.storagesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeUSB: {
            self.usbViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.usbSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeDirectorySharing: {
            self.directorySharingViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.directorySharingSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeBiometicDevice: {
            self.biometricDevicesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.biometricDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeCoprocessors: {
            self.coprocessorsViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.coprocessorsSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeAcceleratorDevices: {
            self.macAcceleratorDevicesViewController.configuration = self.configuration;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.macAcceleratorDevicesSplitViewItem];
            break;
        }
        case EditMachineSidebarItemModelTypeMemoryBalloonDevices: {
            self.memoryBalloonDevicesViewController.memoryBalloonDevices = self.configuration.memoryBalloonDevices;
            self.splitViewController.splitViewItems = @[self.sidebarSplitViewItem, self.memoryBalloonDevicesSplitViewItem];
            break;
        }
        default:
            abort();
    }
}

- (void)editMachineBootLoaderViewController:(EditMachineBootLoaderViewController *)editMachineBootLoaderViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachinePlatformViewController:(EditMachinePlatformViewController *)editMachinePlatformViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineCPUViewController:(EditMachineCPUViewController *)editMachineCPUViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineMemoryViewController:(EditMachineMemoryViewController *)editMachineMemoryViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineKeyboardsViewController:(EditMachineKeyboardsViewController *)editMachineKeyboardsViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineNetworksViewController:(EditMachineNetworksViewController *)editMachineNetworksViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachinePointingDevicesViewController:(EditMachinePointingDevicesViewController *)editMachinePointingDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineGraphicsViewController:(EditMachineGraphicsViewController *)editMachineGraphicsViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)EditMachineStoragesViewController:(EditMachineStoragesViewController *)EditMachineStoragesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineAudioDevicesViewController:(EditMachineAudioDevicesViewController *)editMachineAudioDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineConfigurationUSBControllersViewController:(EditMachineConfigurationUSBControllersViewController *)editMachineUSBViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineConfigurationDirectorySharingViewController:(EditMachineConfigurationDirectorySharingViewController *)editMachineDirectorySharingViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachinePowerSourceDevicesViewController:(EditMachinePowerSourceDevicesViewController *)editMachinePowerSourceDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineBiometricDevicesViewController:(EditMachineBiometricDevicesViewController *)editMachineBiometricDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineCoprocessorsViewController:(EditMachineCoprocessorsViewController *)editMachineCoprocessorsViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineMacAcceleratorDevicesViewController:(EditMachineMacAcceleratorDevicesViewController *)editMachineMacAcceleratorDevicesViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.configuration = configuration;
    [self _notifyDelegate];
}

- (void)editMachineConfigurationMemoryBalloonDevicesViewController:(EditMachineConfigurationMemoryBalloonDevicesViewController *)editMachineConfigurationMemoryBalloonDevicesViewController didUpateMemoryBalloonDevices:(NSArray<VZMemoryBalloonDeviceConfiguration *> *)memoryBalloonDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.memoryBalloonDevices = memoryBalloonDevices;
    self.configuration = configuration;
    [configuration release];
    
    [self _notifyDelegate];
}

@end
