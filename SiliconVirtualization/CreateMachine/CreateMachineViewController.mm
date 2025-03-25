//
//  CreateMachineViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "CreateMachineViewController.h"
#import <Virtualization/Virtualization.h>
#import "EditMachineConfigurationViewController.h"
#import "SVCoreDataStack+VirtualizationSupport.h"
#import <objc/message.h>
#import <objc/runtime.h>

OBJC_EXPORT id objc_msgSendSuper2(void); /* objc_super superInfo = { self, [self class] }; */

@interface CreateMachineViewController () <EditMachineViewControllerDelegate, NSToolbarDelegate>
@property (copy, nonatomic, getter=_machineConfiguration, setter=_setMachineConfiguration:) VZVirtualMachineConfiguration *machineConfiguration;
@property (retain, nonatomic, readonly, getter=_toolbar) NSToolbar *toolbar;
@property (retain, nonatomic, readonly, getter=_nextToolbarItem) NSToolbarItem *nextToolbarItem;
@end

@implementation CreateMachineViewController
@synthesize toolbar = _toolbar;
@synthesize nextToolbarItem = _nextToolbarItem;

+ (VZVirtualMachineConfiguration *)_makeDefaultVirtualMachineConfiguration {
    VZVirtualMachineConfiguration *virtualMachineConfiguration = [VZVirtualMachineConfiguration new];
    
    virtualMachineConfiguration.CPUCount = 10;
    virtualMachineConfiguration.memorySize = 16 * 1024ull * 1024ull * 1024ull;
    
    {
        VZMacOSBootLoader *bootLoader = [[VZMacOSBootLoader alloc] init];
        virtualMachineConfiguration.bootLoader = bootLoader;
        [bootLoader release];
    }
    
    {
        VZMacPlatformConfiguration *platform = [[VZMacPlatformConfiguration alloc] init];
        
        NSDictionary *dic = @{
            @"DataRepresentationVersion": @2,
            @"MinimumSupportedOS": @[@13, @0, @0],
            @"PlatformVersion": @2
        };
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:dic format:NSPropertyListBinaryFormat_v1_0 options:0 error:nil];
        VZMacHardwareModel *hardwareModel = [[VZMacHardwareModel alloc] initWithDataRepresentation:data];
        platform.hardwareModel = hardwareModel;
        [hardwareModel release];
        
        virtualMachineConfiguration.platform = platform;
        [platform release];
    }
    
    {
        VZVirtioSoundDeviceConfiguration *virtioSoundDeviceConfiguration = [[VZVirtioSoundDeviceConfiguration alloc] init];
        
        {
            VZVirtioSoundDeviceOutputStreamConfiguration *outputConfiguration = [[VZVirtioSoundDeviceOutputStreamConfiguration alloc] init];
            VZHostAudioOutputStreamSink *sink = [[VZHostAudioOutputStreamSink alloc] init];
            outputConfiguration.sink = sink;
            [sink release];
            
            virtioSoundDeviceConfiguration.streams = [virtioSoundDeviceConfiguration.streams arrayByAddingObject:outputConfiguration];
            [outputConfiguration release];
        }
        
        {
            VZVirtioSoundDeviceInputStreamConfiguration *inputConfiguration = [[VZVirtioSoundDeviceInputStreamConfiguration alloc] init];
            VZHostAudioInputStreamSource *source = [[VZHostAudioInputStreamSource alloc] init];
            inputConfiguration.source = source;
            [source release];
            
            virtioSoundDeviceConfiguration.streams = [virtioSoundDeviceConfiguration.streams arrayByAddingObject:inputConfiguration];
            [inputConfiguration release];
        }
        
        virtualMachineConfiguration.audioDevices = [virtualMachineConfiguration.audioDevices arrayByAddingObject:virtioSoundDeviceConfiguration];
        [virtioSoundDeviceConfiguration release];
    }
    
    {
        VZMacKeyboardConfiguration *macKeyboardConfiguration = [[VZMacKeyboardConfiguration alloc] init];
        virtualMachineConfiguration.keyboards = [virtualMachineConfiguration.keyboards arrayByAddingObject:macKeyboardConfiguration];
        [macKeyboardConfiguration release];
    }
    
    {
        VZVirtioNetworkDeviceConfiguration *virtioNetworkDeviceConfiguration = [[VZVirtioNetworkDeviceConfiguration alloc] init];
        VZNATNetworkDeviceAttachment *attachment = [[VZNATNetworkDeviceAttachment alloc] init];
        virtioNetworkDeviceConfiguration.attachment = attachment;
        [attachment release];
        
        virtualMachineConfiguration.networkDevices = [virtualMachineConfiguration.networkDevices arrayByAddingObject:virtioNetworkDeviceConfiguration];
        [virtioNetworkDeviceConfiguration release];
    }
    
    {
        VZMacGraphicsDeviceConfiguration *deviceConfiguration = [[VZMacGraphicsDeviceConfiguration alloc] init];
        
        VZMacGraphicsDisplayConfiguration *displayConfiguration = [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:1920 heightInPixels:1080 pixelsPerInch:80];
        deviceConfiguration.displays = @[displayConfiguration];
        [displayConfiguration release];
        
        virtualMachineConfiguration.graphicsDevices = [virtualMachineConfiguration.graphicsDevices arrayByAddingObject:deviceConfiguration];
        [deviceConfiguration release];
    }
    
    {
        VZMacTrackpadConfiguration *macTrackpadConfiguration = [[VZMacTrackpadConfiguration alloc] init];
        virtualMachineConfiguration.pointingDevices = [virtualMachineConfiguration.pointingDevices arrayByAddingObject:macTrackpadConfiguration];
        [macTrackpadConfiguration release];
    }
    
    return [virtualMachineConfiguration autorelease];
}

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _machineConfiguration = [[CreateMachineViewController _makeDefaultVirtualMachineConfiguration] retain];
    }
    
    return self;
}

- (void)dealloc {
    [NSNotificationCenter.defaultCenter removeObserver:self];
    [_machineConfiguration release];
    [_toolbar release];
    [_nextToolbarItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    EditMachineConfigurationViewController *editMachineViewController = [[EditMachineConfigurationViewController alloc] initWithConfiguration:self.machineConfiguration];
    editMachineViewController.delegate = self;
    editMachineViewController.view.frame = self.view.bounds;
    editMachineViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:editMachineViewController.view];
    [self addChildViewController:editMachineViewController];
    [editMachineViewController release];
    
    //
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(_didInitializeCoreDataStack:) name:SVCoreDataStackDidInitializeNotification object:SVCoreDataStack.sharedInstance];
    if (SVCoreDataStack.sharedInstance.initialized) {
        self.nextToolbarItem.enabled = YES;
    }
}

- (void)_viewDidMoveToWindow:(NSWindow * _Nullable)newWindow fromWindow:(NSWindow * _Nullable)oldWindow {
    objc_super superInfo = { self, [self class] };
    reinterpret_cast<void (*)(objc_super *, SEL, id, id)>(objc_msgSendSuper2)(&superInfo, _cmd, newWindow, oldWindow);
    
    if (oldWindow) {
        oldWindow.toolbar = nil;
    }
    
    if (newWindow) {
        newWindow.toolbar = self.toolbar;
    }
}

- (NSToolbar *)_toolbar {
    if (auto toolbar = _toolbar) return toolbar;
    
    NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"CreateMachine"];
    toolbar.delegate = self;
    
    _toolbar = toolbar;
    return toolbar;
}

- (NSToolbarItem *)_nextToolbarItem {
    if (auto nextToolbarItem = _nextToolbarItem) return nextToolbarItem;
    
    NSToolbarItem *nextToolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"Next"];
    nextToolbarItem.label = @"Next";
    nextToolbarItem.image = [NSImage imageWithSystemSymbolName:@"arrow.right" accessibilityDescription:nil];
    nextToolbarItem.target = self;
    nextToolbarItem.action = @selector(_didTriggerNextToolbarItem:);
    nextToolbarItem.enabled = NO;
    nextToolbarItem.autovalidates = NO;
    
    _nextToolbarItem = nextToolbarItem;
    return nextToolbarItem;
}

- (void)_didTriggerNextToolbarItem:(NSToolbarItem *)sender {
    VZVirtualMachineConfiguration *machineConfiguration = self.machineConfiguration;
    assert(machineConfiguration != nil);
    
    SVCoreDataStack *stack = SVCoreDataStack.sharedInstance;
    NSManagedObjectContext *context = stack.backgroundContext;
    
    [context performBlock:^{
        SVVirtualMachineConfiguration *configuration = [stack isolated_makeManagedObjectFromVirtualMachineConfiguration:machineConfiguration];
        SVVirtualMachine *virtualMachine = [[SVVirtualMachine alloc] initWithContext:context];
        virtualMachine.configuration = configuration;
        virtualMachine.timestamp = [NSDate now];
        
        NSError * _Nullable error = nil;
        // 이걸 해줘야 NSFetchedResultsController에서 이상한 Object ID가 안 날라옴
        [context obtainPermanentIDsForObjects:@[virtualMachine] error:&error];
        assert(error == nil);
        [context save:&error];
        assert(error == nil);
        
        [virtualMachine release];
    }];
}

- (void)_didInitializeCoreDataStack:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.nextToolbarItem.enabled = SVCoreDataStack.sharedInstance.initialized;
    });
}

- (void)editMachineViewController:(EditMachineConfigurationViewController *)editMachineViewController didUpdateConfiguration:(VZVirtualMachineConfiguration *)configuration {
    self.machineConfiguration = configuration;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[
        self.nextToolbarItem.itemIdentifier
    ];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return [self toolbarAllowedItemIdentifiers:toolbar];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if ([self.nextToolbarItem.itemIdentifier isEqualToString:itemIdentifier]) {
        return self.nextToolbarItem;
    } else {
        abort();
    }
}

@end
