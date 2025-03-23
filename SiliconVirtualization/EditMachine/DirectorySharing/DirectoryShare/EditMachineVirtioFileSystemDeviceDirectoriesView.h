//
//  EditMachineVirtioFileSystemDeviceDirectoriesView.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import <Cocoa/Cocoa.h>
#import <Virtualization/Virtualization.h>

NS_ASSUME_NONNULL_BEGIN

@class EditMachineVirtioFileSystemDeviceDirectoriesView;
@protocol EditMachineVirtioFileSystemDeviceDirectoriesViewDelegate <NSObject>
- (void)editMachineVirtioFileSystemDeviceDirectoriesView:(EditMachineVirtioFileSystemDeviceDirectoriesView *)editMachineVirtioFileSystemDeviceDirectoriesView didUpdateDirectories:(NSDictionary<NSString *, VZSharedDirectory *> *)directories;
@end

@interface EditMachineVirtioFileSystemDeviceDirectoriesView : NSView
@property (copy, nonatomic, nullable) NSDictionary<NSString *, VZSharedDirectory *> *directories;
@property (assign, nonatomic, nullable) id<EditMachineVirtioFileSystemDeviceDirectoriesViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
