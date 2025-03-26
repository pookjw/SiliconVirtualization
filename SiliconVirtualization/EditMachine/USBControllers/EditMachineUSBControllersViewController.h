//
//  EditMachineUSBControllersViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/26/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineUSBControllersViewController : NSViewController
@property (copy, nonatomic, nullable, setter=setUSBControllers:) NSArray<__kindof VZUSBController *> *usbControllers;
@end

NS_ASSUME_NONNULL_END
