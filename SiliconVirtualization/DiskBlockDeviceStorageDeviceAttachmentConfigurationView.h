//
//  DiskBlockDeviceStorageDeviceAttachmentConfigurationView.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiskBlockDeviceStorageDeviceAttachmentConfigurationView : NSView
@property (assign, nonatomic) int fileDescriptor;
@property (assign, nonatomic) BOOL readOnly;
@property (assign, nonatomic) VZDiskSynchronizationMode synchronizationMode;
@end

NS_ASSUME_NONNULL_END
