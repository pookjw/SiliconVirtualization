//
//  EditMachineDirectorySharingDevicesViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineDirectorySharingDevicesViewController : NSViewController
@property (retain, nonatomic) NSArray<__kindof VZDirectorySharingDevice *> *directorySharingDevices;
@end

NS_ASSUME_NONNULL_END
