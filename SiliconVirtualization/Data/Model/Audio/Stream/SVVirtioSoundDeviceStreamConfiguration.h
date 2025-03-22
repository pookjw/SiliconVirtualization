//
//  SVVirtioSoundDeviceStreamConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/22/25.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class SVVirtioSoundDeviceConfiguration;

@interface SVVirtioSoundDeviceStreamConfiguration : NSManagedObject
+ (NSFetchRequest<SVVirtioSoundDeviceStreamConfiguration *> *)fetchRequest;
@property (retain, nonatomic, nullable) SVVirtioSoundDeviceConfiguration *soundDevice;
@end

NS_ASSUME_NONNULL_END
