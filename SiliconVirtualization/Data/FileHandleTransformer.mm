//
//  FileHandleTransformer.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/23/25.
//

#import "FileHandleTransformer.h"

@implementation FileHandleTransformer

+ (NSValueTransformerName)transformerName {
    return @"FileHandleTransformer";
}

+ (NSArray<Class> *)allowedTopLevelClasses {
    return [[super allowedTopLevelClasses] arrayByAddingObject:[NSFileHandle class]];
}

@end
