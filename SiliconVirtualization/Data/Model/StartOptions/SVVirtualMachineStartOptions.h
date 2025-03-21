//
//  SVVirtualMachineStartOptions.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtualMachine;

@interface SVVirtualMachineStartOptions : NSManagedObject
+ (NSFetchRequest<SVVirtualMachineStartOptions *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtualMachine *machine;
@end

NS_ASSUME_NONNULL_END
