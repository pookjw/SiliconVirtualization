//
//  FileHandleTransformer.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileHandleTransformer : NSSecureUnarchiveFromDataTransformer
@property (class, nonatomic, readonly) NSValueTransformerName transformerName;
@end

NS_ASSUME_NONNULL_END
