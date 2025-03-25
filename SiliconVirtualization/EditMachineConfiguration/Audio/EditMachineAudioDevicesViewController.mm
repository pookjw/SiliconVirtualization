//
//  EditMachineAudioDevicesViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import "EditMachineAudioDevicesViewController.h"
#import "EditMachineAudioDevicesTableViewController.h"
#import "EditMachineVirtioSoundDeviceStreamsTableViewController.h"
#import "EditMachineVirtioSoundDeviceOutputStreamViewController.h"
#import "EditMachineVirtioSoundDeviceInputStreamViewController.h"

@interface EditMachineAudioDevicesViewController () <EditMachineAudioDevicesTableViewControllerDelegate, EditMachineVirtioSoundDeviceStreamsViewControllerDelegate, EditMachineVirtioSoundDeviceOutputStreamViewControllerDelegate, EditMachineVirtioSoundDeviceInputStreamViewControllerDelegate>
@property (retain, nonatomic, readonly, getter=_splitViewController) NSSplitViewController *splitViewController;

@property (retain, nonatomic, readonly, getter=_audioDevicesTableViewController) EditMachineAudioDevicesTableViewController *audioDevicesTableViewController;
@property (retain, nonatomic, readonly, getter=_audioDevicesTableSplitViewItem) NSSplitViewItem *audioDevicesTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceStreamsTableViewController) EditMachineVirtioSoundDeviceStreamsTableViewController *virtioSoundDeviceStreamsTableViewController;
@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceStreamsTableSplitViewItem) NSSplitViewItem *virtioSoundDeviceStreamsTableSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyAudioDeviceViewController) NSViewController *emptyAudioDeviceViewController;
@property (retain, nonatomic, readonly, getter=_emptyAudioDeviceSplitViewItem) NSSplitViewItem *emptyAudioDeviceSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceOutputStreamViewController) EditMachineVirtioSoundDeviceOutputStreamViewController *virtioSoundDeviceOutputStreamViewController;
@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceOutputStreamSplitViewItem) NSSplitViewItem *virtioSoundDeviceOutputStreamSplitViewItem;

@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceInputStreamViewController) EditMachineVirtioSoundDeviceInputStreamViewController *virtioSoundDeviceInputStreamViewController;
@property (retain, nonatomic, readonly, getter=_virtioSoundDeviceInputStreamSplitViewItem) NSSplitViewItem *virtioSoundDeviceInputStreamSplitViewItem;

@property (retain, nonatomic, readonly, getter=_emptyStreamViewController) NSViewController *emptyStreamViewController;
@property (retain, nonatomic, readonly, getter=_emptyStreamSplitViewItem) NSSplitViewItem *emptyStreamSplitViewItem;

@property (assign, nonatomic, getter=_selectedAudioDeviceIndex, setter=_setSelectedAudioDeviceIndex:) NSInteger selectedAudioDeviceIndex;
@property (assign, nonatomic, getter=_selectedStreamIndex, setter=_setSelectedStreamIndex:) NSInteger selectedStreamIndex;
@end

@implementation EditMachineAudioDevicesViewController
@synthesize splitViewController = _splitViewController;
@synthesize audioDevicesTableViewController = _audioDevicesTableViewController;
@synthesize audioDevicesTableSplitViewItem = _audioDevicesTableSplitViewItem;
@synthesize virtioSoundDeviceStreamsTableViewController = _virtioSoundDeviceStreamsTableViewController;
@synthesize virtioSoundDeviceStreamsTableSplitViewItem = _virtioSoundDeviceStreamsTableSplitViewItem;
@synthesize emptyAudioDeviceViewController = _emptyAudioDeviceViewController;
@synthesize emptyAudioDeviceSplitViewItem = _emptyAudioDeviceSplitViewItem;
@synthesize virtioSoundDeviceOutputStreamViewController = _virtioSoundDeviceOutputStreamViewController;
@synthesize virtioSoundDeviceOutputStreamSplitViewItem = _virtioSoundDeviceOutputStreamSplitViewItem;
@synthesize virtioSoundDeviceInputStreamViewController = _virtioSoundDeviceInputStreamViewController;
@synthesize virtioSoundDeviceInputStreamSplitViewItem = _virtioSoundDeviceInputStreamSplitViewItem;
@synthesize emptyStreamViewController = _emptyStreamViewController;
@synthesize emptyStreamSplitViewItem = _emptyStreamSplitViewItem;

- (instancetype)initWithConfiguration:(VZVirtualMachineConfiguration *)configuration {
    if (self = [super initWithNibName:nil bundle:nil]) {
        _configuration = [configuration copy];
        _selectedAudioDeviceIndex = NSNotFound;
        _selectedStreamIndex = NSNotFound;
    }
    
    return self;
}

- (void)dealloc {
    [_configuration release];
    [_splitViewController release];
    [_audioDevicesTableViewController release];
    [_audioDevicesTableSplitViewItem release];
    [_virtioSoundDeviceStreamsTableViewController release];
    [_virtioSoundDeviceStreamsTableSplitViewItem release];
    [_emptyAudioDeviceViewController release];
    [_emptyAudioDeviceSplitViewItem release];
    [_virtioSoundDeviceOutputStreamViewController release];
    [_virtioSoundDeviceOutputStreamSplitViewItem release];
    [_virtioSoundDeviceInputStreamViewController release];
    [_virtioSoundDeviceInputStreamSplitViewItem release];
    [_emptyStreamViewController release];
    [_emptyStreamSplitViewItem release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSSplitViewController *splitViewController = self.splitViewController;
    splitViewController.view.frame = self.view.bounds;
    splitViewController.view.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:splitViewController.view];
    
    [self _didChangeConfiguration];
}

- (void)setConfiguration:(VZVirtualMachineConfiguration *)configuration {
    [_configuration release];
    _configuration = [configuration copy];
    
    [self _didChangeConfiguration];
}

- (void)_didChangeConfiguration {
    self.audioDevicesTableViewController.audioDevices = self.configuration.audioDevices;
}

- (NSSplitViewController *)_splitViewController {
    if (auto splitViewController = _splitViewController) return splitViewController;
    
    NSSplitViewController *splitViewController = [NSSplitViewController new];
    splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.emptyAudioDeviceSplitViewItem, self.emptyStreamSplitViewItem];
    
    _splitViewController = splitViewController;
    return splitViewController;
}

- (EditMachineAudioDevicesTableViewController *)_audioDevicesTableViewController {
    if (auto audioDevicesTableViewController = _audioDevicesTableViewController) return audioDevicesTableViewController;
    
    EditMachineAudioDevicesTableViewController *audioDevicesTableViewController = [EditMachineAudioDevicesTableViewController new];
    audioDevicesTableViewController.delegate = self;
    
    _audioDevicesTableViewController = audioDevicesTableViewController;
    return audioDevicesTableViewController;
}

- (EditMachineVirtioSoundDeviceStreamsTableViewController *)_virtioSoundDeviceStreamsTableViewController {
    if (auto virtioSoundDeviceStreamsTableViewController = _virtioSoundDeviceStreamsTableViewController) return virtioSoundDeviceStreamsTableViewController;
    
    EditMachineVirtioSoundDeviceStreamsTableViewController *virtioSoundDeviceStreamsTableViewController = [EditMachineVirtioSoundDeviceStreamsTableViewController new];
    virtioSoundDeviceStreamsTableViewController.delegate = self;
    
    _virtioSoundDeviceStreamsTableViewController = virtioSoundDeviceStreamsTableViewController;
    return virtioSoundDeviceStreamsTableViewController;
}

- (NSSplitViewItem *)_virtioSoundDeviceStreamsTableSplitViewItem {
    if (auto virtioSoundDeviceStreamsTableSplitViewItem = _virtioSoundDeviceStreamsTableSplitViewItem) return virtioSoundDeviceStreamsTableSplitViewItem;
    
    NSSplitViewItem *virtioSoundDeviceStreamsTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.virtioSoundDeviceStreamsTableViewController];
    
    _virtioSoundDeviceStreamsTableSplitViewItem = [virtioSoundDeviceStreamsTableSplitViewItem retain];
    return virtioSoundDeviceStreamsTableSplitViewItem;
}

- (NSSplitViewItem *)_audioDevicesTableSplitViewItem {
    if (auto audioDevicesTableSplitViewItem = _audioDevicesTableSplitViewItem) return audioDevicesTableSplitViewItem;
    
    NSSplitViewItem *audioDevicesTableSplitViewItem = [NSSplitViewItem contentListWithViewController:self.audioDevicesTableViewController];
    
    _audioDevicesTableSplitViewItem = [audioDevicesTableSplitViewItem retain];
    return audioDevicesTableSplitViewItem;
}

- (NSViewController *)_emptyAudioDeviceViewController {
    if (auto emptyAudioDeviceViewController = _emptyAudioDeviceViewController) return emptyAudioDeviceViewController;
    
    NSViewController *emptyAudioDeviceViewController = [NSViewController new];
    
    _emptyAudioDeviceViewController = emptyAudioDeviceViewController;
    return emptyAudioDeviceViewController;
}

- (NSSplitViewItem *)_emptyAudioDeviceSplitViewItem {
    if (auto emptyAudioDeviceSplitViewItem = _emptyAudioDeviceSplitViewItem) return emptyAudioDeviceSplitViewItem;
    
    NSSplitViewItem *emptyAudioDeviceSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyAudioDeviceViewController];
    
    _emptyAudioDeviceSplitViewItem = [emptyAudioDeviceSplitViewItem retain];
    return emptyAudioDeviceSplitViewItem;
}
- (EditMachineVirtioSoundDeviceOutputStreamViewController *)_virtioSoundDeviceOutputStreamViewController {
    if (auto virtioSoundDeviceOutputStreamViewController = _virtioSoundDeviceOutputStreamViewController) return virtioSoundDeviceOutputStreamViewController;
    
    EditMachineVirtioSoundDeviceOutputStreamViewController *virtioSoundDeviceOutputStreamViewController = [EditMachineVirtioSoundDeviceOutputStreamViewController new];
    virtioSoundDeviceOutputStreamViewController.delegate = self;
    
    _virtioSoundDeviceOutputStreamViewController = virtioSoundDeviceOutputStreamViewController;
    return virtioSoundDeviceOutputStreamViewController;
}

- (NSSplitViewItem *)_virtioSoundDeviceOutputStreamSplitViewItem {
    if (auto virtioSoundDeviceOutputStreamSplitViewItem = _virtioSoundDeviceOutputStreamSplitViewItem) return virtioSoundDeviceOutputStreamSplitViewItem;
    
    NSSplitViewItem *virtioSoundDeviceOutputStreamSplitViewItem = [NSSplitViewItem contentListWithViewController:self.virtioSoundDeviceOutputStreamViewController];
    
    _virtioSoundDeviceOutputStreamSplitViewItem = [virtioSoundDeviceOutputStreamSplitViewItem retain];
    return virtioSoundDeviceOutputStreamSplitViewItem;
}

- (EditMachineVirtioSoundDeviceInputStreamViewController *)_virtioSoundDeviceInputStreamViewController {
    if (auto virtioSoundDeviceInputStreamViewController = _virtioSoundDeviceInputStreamViewController) return virtioSoundDeviceInputStreamViewController;
    
    EditMachineVirtioSoundDeviceInputStreamViewController *virtioSoundDeviceInputStreamViewController = [EditMachineVirtioSoundDeviceInputStreamViewController new];
    virtioSoundDeviceInputStreamViewController.delegate = self;
    
    _virtioSoundDeviceInputStreamViewController = virtioSoundDeviceInputStreamViewController;
    return virtioSoundDeviceInputStreamViewController;
}

- (NSSplitViewItem *)_virtioSoundDeviceInputStreamSplitViewItem {
    if (auto virtioSoundDeviceInputStreamSplitViewItem = _virtioSoundDeviceInputStreamSplitViewItem) return virtioSoundDeviceInputStreamSplitViewItem;
    
    NSSplitViewItem *virtioSoundDeviceInputStreamSplitViewItem = [NSSplitViewItem contentListWithViewController:self.virtioSoundDeviceInputStreamViewController];
    
    _virtioSoundDeviceInputStreamSplitViewItem = [virtioSoundDeviceInputStreamSplitViewItem retain];
    return virtioSoundDeviceInputStreamSplitViewItem;
}

- (NSViewController *)_emptyStreamViewController {
    if (auto emptyStreamViewController = _emptyStreamViewController) return emptyStreamViewController;
    
    NSViewController *emptyStreamViewController = [NSViewController new];
    
    _emptyStreamViewController = emptyStreamViewController;
    return emptyStreamViewController;
}

- (NSSplitViewItem *)_emptyStreamSplitViewItem {
    if (auto emptyStreamSplitViewItem = _emptyStreamSplitViewItem) return emptyStreamSplitViewItem;
    
    NSSplitViewItem *emptyStreamSplitViewItem = [NSSplitViewItem contentListWithViewController:self.emptyStreamViewController];
    
    _emptyStreamSplitViewItem = [emptyStreamSplitViewItem retain];
    return emptyStreamSplitViewItem;
}

- (void)editMachineAudioDevicesTableViewController:(EditMachineAudioDevicesTableViewController *)editMachineAudioDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex {
    self.selectedAudioDeviceIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.emptyAudioDeviceSplitViewItem, self.emptyStreamSplitViewItem];
        return;
    }
    
    __kindof VZAudioDeviceConfiguration *audioDevice = self.configuration.audioDevices[selectedIndex];
    
    if ([audioDevice isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]) {
        auto casted = static_cast<VZVirtioSoundDeviceConfiguration *>(audioDevice);
        self.virtioSoundDeviceStreamsTableViewController.streams = casted.streams;
        
        NSInteger selectedStreamIndex = self.selectedStreamIndex;
        if ((selectedStreamIndex == NSNotFound) or (selectedStreamIndex == -1)) {
            self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.emptyStreamSplitViewItem];
        } else {
            __kindof VZVirtioSoundDeviceStreamConfiguration *stream = casted.streams[selectedStreamIndex];
            
            if ([stream isKindOfClass:[VZVirtioSoundDeviceOutputStreamConfiguration class]]) {
                self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.virtioSoundDeviceOutputStreamSplitViewItem];
            } else if ([stream isKindOfClass:[VZVirtioSoundDeviceInputStreamConfiguration class]]) {
                self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.virtioSoundDeviceInputStreamSplitViewItem];
            } else {
                abort();
            }
        }
    } else {
        abort();
    }
}

- (void)editMachineAudioDevicesTableViewController:(EditMachineAudioDevicesTableViewController *)editMachineAudioDevicesTableViewController didUpdateAudioDevices:(NSArray<__kindof VZAudioDeviceConfiguration *> *)audioDevices {
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    configuration.audioDevices = audioDevices;
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineVirtioSoundDeviceStreamsViewController:(nonnull EditMachineVirtioSoundDeviceStreamsTableViewController *)editMachineVirtioSoundDeviceStreamsViewController didSelectAtIndex:(NSInteger)selectedIndex { 
    self.selectedStreamIndex = selectedIndex;
    
    if ((selectedIndex == NSNotFound) or (selectedIndex == -1)) {
        self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.emptyStreamSplitViewItem];
        return;
    }
    
    NSInteger selectedAudioDeviceIndex = self.selectedAudioDeviceIndex;
    assert((selectedAudioDeviceIndex != NSNotFound) and (selectedAudioDeviceIndex != -1));
    
    __kindof VZAudioDeviceConfiguration *audioDevice = self.configuration.audioDevices[selectedAudioDeviceIndex];
    assert([audioDevice isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]);
    auto casted = static_cast<VZVirtioSoundDeviceConfiguration *>(audioDevice);
    
    __kindof VZVirtioSoundDeviceStreamConfiguration *stream = casted.streams[selectedIndex];
    if ([stream isKindOfClass:[VZVirtioSoundDeviceOutputStreamConfiguration class]]) {
        auto casted = static_cast<VZVirtioSoundDeviceOutputStreamConfiguration *>(stream);
        self.virtioSoundDeviceOutputStreamViewController.configuration = casted;
        self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.virtioSoundDeviceOutputStreamSplitViewItem];
    } else if ([stream isKindOfClass:[VZVirtioSoundDeviceInputStreamConfiguration class]]) {
        auto casted = static_cast<VZVirtioSoundDeviceInputStreamConfiguration *>(stream);
        self.virtioSoundDeviceInputStreamViewController.configuration = casted;
        self.splitViewController.splitViewItems = @[self.audioDevicesTableSplitViewItem, self.virtioSoundDeviceStreamsTableSplitViewItem, self.virtioSoundDeviceInputStreamSplitViewItem];
    } else {
        abort();
    }
}

- (void)editMachineVirtioSoundDeviceStreamsViewController:(nonnull EditMachineVirtioSoundDeviceStreamsTableViewController *)editMachineVirtioSoundDeviceStreamsViewController didUpdateStreams:(nonnull NSArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *)streams { 
    NSInteger selectedAudioDeviceIndex = self.selectedAudioDeviceIndex;
    assert((selectedAudioDeviceIndex != NSNotFound) and (selectedAudioDeviceIndex != -1));
    
    VZVirtualMachineConfiguration *configuration = [self.configuration copy];
    
    NSArray<__kindof VZAudioDeviceConfiguration *> *audioDevices = configuration.audioDevices;
    __kindof VZAudioDeviceConfiguration *audioDevice = audioDevices[selectedAudioDeviceIndex];
    assert([audioDevice isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]);
    auto casted = static_cast<VZVirtioSoundDeviceConfiguration *>(audioDevice);
    casted.streams = streams;
    
    configuration.audioDevices = audioDevices;
    
    self.configuration = configuration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesViewController:self didUpdateConfiguration:configuration];
    }
    
    [configuration release];
}

- (void)editMachineVirtioSoundDeviceOutputStreamViewController:(EditMachineVirtioSoundDeviceOutputStreamViewController *)editMachineVirtioSoundDeviceOutputStreamViewController didUpdateConfiguration:(VZVirtioSoundDeviceOutputStreamConfiguration *)configuration {
    [self _updateVirtioSoundDeviceStreamConfiguration:configuration];
}

- (void)editMachineVirtioSoundDeviceInputStreamViewController:(EditMachineVirtioSoundDeviceInputStreamViewController *)editMachineVirtioSoundDeviceInputStreamViewController didUpdateConfiguration:(VZVirtioSoundDeviceInputStreamConfiguration *)configuration {
    [self _updateVirtioSoundDeviceStreamConfiguration:configuration];
}

- (void)_updateVirtioSoundDeviceStreamConfiguration:(__kindof VZVirtioSoundDeviceStreamConfiguration *)configuration {
    NSInteger selectedAudioDeviceIndex = self.selectedAudioDeviceIndex;
    assert((selectedAudioDeviceIndex != NSNotFound) and (selectedAudioDeviceIndex != -1));
    
    NSInteger selectedStreamIndex = self.selectedStreamIndex;
    assert((selectedStreamIndex != NSNotFound) and (selectedStreamIndex != -1));
    
    VZVirtualMachineConfiguration *virtualMachineConfiguration = [self.configuration copy];
    
    NSArray<__kindof VZAudioDeviceConfiguration *> *audioDevices = virtualMachineConfiguration.audioDevices;
    __kindof VZAudioDeviceConfiguration *audioDevice = audioDevices[selectedAudioDeviceIndex];
    assert([audioDevice isKindOfClass:[VZVirtioSoundDeviceConfiguration class]]);
    auto virtioSoundDeviceConfiguration = static_cast<VZVirtioSoundDeviceConfiguration *>(audioDevice);
    
    NSMutableArray<__kindof VZVirtioSoundDeviceStreamConfiguration *> *streams = [virtioSoundDeviceConfiguration.streams mutableCopy];
    [streams removeObjectAtIndex:selectedStreamIndex];
    [streams insertObject:configuration atIndex:selectedStreamIndex];
    virtioSoundDeviceConfiguration.streams = streams;
    [streams release];
    
    virtualMachineConfiguration.audioDevices = audioDevices;
    
    self.configuration = virtualMachineConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineAudioDevicesViewController:self didUpdateConfiguration:virtualMachineConfiguration];
    }
    
    [virtualMachineConfiguration release];
}

@end
