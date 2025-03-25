//
//  EditMachineCoprocessorsTableViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineCoprocessorsTableViewController;
@protocol EditMachineCoprocessorsTableViewControllerDelegate <NSObject>
- (void)editMachineCoprocessorsTableViewController:(EditMachineCoprocessorsTableViewController *)editMachineCoprocessorsTableViewController didSelectAtIndex:(NSInteger)selectedIndex;
- (void)editMachineCoprocessorsTableViewController:(EditMachineCoprocessorsTableViewController *)editMachineCoprocessorsTableViewController didUpdateCoprocessors:(NSArray *)coprocessors;
@end

@interface EditMachineCoprocessorsTableViewController : NSViewController
@property (copy, nonatomic, nullable) NSArray *coprocessors;
@property (assign, nonatomic, nullable) id<EditMachineCoprocessorsTableViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
