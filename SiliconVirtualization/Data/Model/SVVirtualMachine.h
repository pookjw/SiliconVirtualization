//
//  SVVirtualMachine.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/21/25.
//

#import <CoreData/CoreData.h>
#import "SVVirtualMachineConfiguration.h"
#import "SVVirtualMachineStartOptions.h"

NS_ASSUME_NONNULL_BEGIN

@interface SVVirtualMachine : NSManagedObject
+ (NSFetchRequest<SVVirtualMachine *> *)fetchRequest;
@property (copy, nonatomic, nullable) NSDate *timestamp;
@property (retain, nonatomic, nullable) SVVirtualMachineConfiguration *configuration;
@property (retain, nonatomic, nullable) SVVirtualMachineStartOptions *startOptions;
@end

NS_ASSUME_NONNULL_END
