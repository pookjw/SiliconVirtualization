//
//  EditMachineStorageControl.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/17/25.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditMachineStorageControl : NSControl
@property (copy, nonatomic) NSUnitInformationStorage *selectedUnit;
@property (assign, nonatomic) uint64_t unsignedInt64Value; // bytes
@property (assign, nonatomic) uint64_t maxValue; // bytes
@property (assign, nonatomic) uint64_t minValue; // bytes
@end

NS_ASSUME_NONNULL_END
