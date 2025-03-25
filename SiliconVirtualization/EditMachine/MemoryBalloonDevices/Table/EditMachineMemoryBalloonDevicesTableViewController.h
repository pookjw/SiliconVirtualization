//
//  EditMachineMemoryBalloonDevicesTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineMemoryBalloonDevicesTableViewController;

@protocol EditMachineMemoryBalloonDevicesTableViewControllerDelegate <NSObject>
- (void)editMachineMemoryBalloonDevicesTableViewController:(EditMachineMemoryBalloonDevicesTableViewController *)editMachineMemoryBalloonDevicesTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
@end

@interface EditMachineMemoryBalloonDevicesTableViewController : NSViewController
@property (copy, nonatomic) NSArray<__kindof VZMemoryBalloonDevice *> *memoryBalloonDevices;
@property (assign, nonatomic, nullable) id<EditMachineMemoryBalloonDevicesTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
