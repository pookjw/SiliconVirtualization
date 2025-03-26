//
//  SVMacGraphicsDisplayConfiguration.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVGraphicsDisplayConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@class SVMacGraphicsDeviceConfiguration;

@interface SVMacGraphicsDisplayConfiguration : SVGraphicsDisplayConfiguration
+ (NSFetchRequest<SVMacGraphicsDisplayConfiguration *> *)fetchRequest;

@property (nonatomic) int64_t displayMode;
@property (nonatomic) int64_t heightInPixels;
@property (nonatomic) int64_t pixelsPerInch;
@property (nonatomic) int64_t widthInPixels;
@property (retain, nonatomic, nullable) SVMacGraphicsDeviceConfiguration *graphicsDevice;
@end

NS_ASSUME_NONNULL_END
