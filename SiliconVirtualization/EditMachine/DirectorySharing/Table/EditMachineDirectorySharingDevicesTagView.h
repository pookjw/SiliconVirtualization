//
//  EditMachineDirectorySharingDevicesTagView.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineDirectorySharingDevicesTagView : NSView
@property (copy, nonatomic) NSString *deviceTag;
@property (copy, nonatomic, readonly, nullable) NSError *validationError;
@end

NS_ASSUME_NONNULL_END
