//
//  SVVirtioGraphicsScanoutConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDisplayConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVVirtioGraphicsDeviceConfiguration;

@interface SVVirtioGraphicsScanoutConfiguration : SVGraphicsDisplayConfiguration
+ (NSFetchRequest<SVVirtioGraphicsScanoutConfiguration *> *)fetchRequest;
@property (nonatomic) int64_t heightInPixels;
@property (nonatomic) int64_t widthInPixels;
@property (retain, nonatomic, nullable) SVVirtioGraphicsDeviceConfiguration *graphicsDevice;
@end

NS_ASSUME_NONNULL_END
