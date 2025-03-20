//
//  EditMachineKeyboardsTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/20/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineKeyboardsTableViewController;
@protocol EditMachineKeyboardsTableViewControllerDelegate <NSObject>
- (void)editMachineKeyboardsTableViewController:(EditMachineKeyboardsTableViewController *)editMachineKeyboardsTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineKeyboardsTableViewController:(EditMachineKeyboardsTableViewController *)editMachineKeyboardsTableViewController didUpdateKeyboards:(NSArray<__kindof VZKeyboardConfiguration *> *)keyboards;
@end

@interface EditMachineKeyboardsTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray<__kindof VZKeyboardConfiguration *> *keyboards;
@property (assign, nonatomic, nullable) id<EditMachineKeyboardsTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
