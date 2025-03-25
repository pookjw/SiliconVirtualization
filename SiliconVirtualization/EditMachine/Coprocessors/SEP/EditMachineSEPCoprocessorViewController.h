//
//  EditMachineSEPCoprocessorViewController.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineSEPCoprocessorViewController;
@protocol EditMachineSEPCoprocessorViewControllerDelegate <NSObject>
- (void)editMachineSEPCoprocessorViewController:(EditMachineSEPCoprocessorViewController *)editMachineSEPCoprocessorViewController didUpdateSEPCoprocessorConfigurtion:(id)SEPCoprocessorConfigurtion;
@end

@interface EditMachineSEPCoprocessorViewController : NSViewController
@property (copy, nonatomic, nullable) id SEPCoprocessorConfigurtion;
@property (assign, nonatomic, nullable) id<EditMachineSEPCoprocessorViewControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
