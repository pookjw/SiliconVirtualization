//
//  EditMachineMemoryBalloonDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineMemoryBalloonDevicesViewController : NSViewController
@property (copy, nonatomic) NSArray<__kindof VZMemoryBalloonDevice *> *memoryBalloonDevices;
@end

NS_ASSUME_NONNULL_END
