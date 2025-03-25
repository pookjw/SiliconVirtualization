//
//  EditMachineVirtioFileSystemDeviceDirectoryShareView.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineVirtioFileSystemDeviceDirectoryShareView : NSView
@property (copy, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL readOnly;
@end

NS_ASSUME_NONNULL_END
