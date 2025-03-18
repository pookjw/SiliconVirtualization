//
//  MachinesCollectionViewItem.h
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import <Cocoa/Cocoa.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface MachinesCollectionViewItem : NSCollectionViewItem
@property (copy, nonatomic, nullable) NSManagedObjectID *objectID;
@end

NS_ASSUME_NONNULL_END
