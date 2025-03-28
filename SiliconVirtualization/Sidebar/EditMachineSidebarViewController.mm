//
//  EditMachineSidebarViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineSidebarViewController.h"
#import "EditMachineSidebarViewItem.h"
#import "EditMachineSidebarSeparatorView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface _EditMachineSidebarCollectionViewCompositionalLayout : NSCollectionViewCompositionalLayout
@end
@implementation _EditMachineSidebarCollectionViewCompositionalLayout
- (void)prepareLayout {
    if (!NSEqualSizes(self.collectionView.bounds.size, NSZeroSize)) {
        [super prepareLayout];
    }
}
@end

@interface EditMachineSidebarViewController () <NSCollectionViewDelegate>
@property (class, nonatomic, readonly, getter=_viewItemIdentifier) NSUserInterfaceItemIdentifier viewItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorItemIdentifier) NSUserInterfaceItemIdentifier separatorItemIdentifier;
@property (class, nonatomic, readonly, getter=_separatorElementKind) NSCollectionViewSupplementaryElementKind separatorElementKind;
@property (retain, nonatomic, readonly, getter=_collectionView) NSCollectionView *collectionView;
@property (retain, nonatomic, readonly, getter=_dataSource) NSCollectionViewDiffableDataSource<NSNull *, EditMachineSidebarItemModel *> *dataSource;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@end

@implementation EditMachineSidebarViewController
@synthesize collectionView = _collectionView;
@synthesize dataSource = _dataSource;
@synthesize scrollView = _scrollView;

+ (NSUserInterfaceItemIdentifier)_viewItemIdentifier {
    return NSStringFromClass([EditMachineSidebarViewItem class]);
}

+ (NSCollectionViewSupplementaryElementKind)_separatorItemIdentifier {
    return NSStringFromClass([EditMachineSidebarSeparatorView class]);
}

+ (NSCollectionViewSupplementaryElementKind)_separatorElementKind {
    return NSStringFromClass([EditMachineSidebarSeparatorView class]);
}

- (void)dealloc {
    [_collectionView release];
    [_dataSource release];
    [_scrollView release];
    [super dealloc];
}

- (void)loadView {
    self.view = self.scrollView;
}

- (NSArray<EditMachineSidebarItemModel *> *)itemModels {
    return self.dataSource.snapshot.itemIdentifiers;
}

- (void)setItemModels:(NSArray<EditMachineSidebarItemModel *> *)itemModels {
    NSDiffableDataSourceSnapshot<NSNull *, EditMachineSidebarItemModel *> *snapshot = [NSDiffableDataSourceSnapshot new];
    
    [snapshot appendSectionsWithIdentifiers:@[[NSNull null]]];
    [snapshot appendItemsWithIdentifiers:itemModels intoSectionWithIdentifier:[NSNull null]];
    
    [self.dataSource applySnapshot:snapshot animatingDifferences:YES];
    [snapshot release];
}

- (NSCollectionView *)_collectionView {
    if (auto collectionView = _collectionView) return collectionView;
    
    NSCollectionViewCompositionalLayoutConfiguration *configuration = [NSCollectionViewCompositionalLayoutConfiguration new];
    configuration.scrollDirection = NSCollectionViewScrollDirectionVertical;
    
    NSCollectionViewCompositionalLayout *collectionViewLayout = [[_EditMachineSidebarCollectionViewCompositionalLayout alloc] initWithSectionProvider:^NSCollectionLayoutSection * _Nullable(NSInteger sectionIndex, id<NSCollectionLayoutEnvironment> _Nonnull) {
        NSCollectionLayoutSize *itemSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                          heightDimension:[NSCollectionLayoutDimension estimatedDimension:36.]];
        
        NSCollectionLayoutSize *separatorSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                               heightDimension:[NSCollectionLayoutDimension absoluteDimension:1.]];
        
        NSCollectionLayoutSupplementaryItem *separatorItem = [NSCollectionLayoutSupplementaryItem supplementaryItemWithLayoutSize:separatorSize
                                                                                                                      elementKind:EditMachineSidebarViewController.separatorElementKind
                                                                                                                  containerAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeBottom]
                                                                                                                       itemAnchor:[NSCollectionLayoutAnchor layoutAnchorWithEdges:NSDirectionalRectEdgeTop]];
        
        NSCollectionLayoutItem *item = [NSCollectionLayoutItem itemWithLayoutSize:itemSize supplementaryItems:@[separatorItem]];
        
        NSCollectionLayoutSize *groupSize = [NSCollectionLayoutSize sizeWithWidthDimension:[NSCollectionLayoutDimension fractionalWidthDimension:1.]
                                                                           heightDimension:[NSCollectionLayoutDimension estimatedDimension:37.]];
        
        NSCollectionLayoutGroup *group = [NSCollectionLayoutGroup verticalGroupWithLayoutSize:groupSize subitem:item count:1];
        
        group.edgeSpacing = [NSCollectionLayoutEdgeSpacing spacingForLeading:nil top:nil trailing:nil bottom:[NSCollectionLayoutSpacing fixedSpacing:1.]];
        
        NSCollectionLayoutSection *section = [NSCollectionLayoutSection sectionWithGroup:group];
        
        return section;
    }
                                                                                                                       configuration:configuration];
    
    [configuration release];
    
    NSCollectionView *collectionView = [NSCollectionView new];
    collectionView.collectionViewLayout = collectionViewLayout;
    [collectionViewLayout release];
    
    [collectionView registerClass:[EditMachineSidebarViewItem class] forItemWithIdentifier:EditMachineSidebarViewController.viewItemIdentifier];
    [collectionView registerClass:[EditMachineSidebarSeparatorView class] forSupplementaryViewOfKind:EditMachineSidebarViewController.separatorElementKind withIdentifier:EditMachineSidebarViewController.separatorItemIdentifier];
    
    collectionView.selectable = YES;
    collectionView.allowsMultipleSelection = NO;
    collectionView.allowsEmptySelection = NO;
    collectionView.delegate = self;
    collectionView.backgroundColors = @[NSColor.clearColor];
    
    _collectionView = collectionView;
    return collectionView;
}

- (NSCollectionViewDiffableDataSource<NSNull *,EditMachineSidebarItemModel *> *)_dataSource {
    if (auto dataSource = _dataSource) return dataSource;
    
    NSCollectionViewDiffableDataSource<NSNull *,EditMachineSidebarItemModel *> *dataSource = [[NSCollectionViewDiffableDataSource alloc] initWithCollectionView:self.collectionView itemProvider:^NSCollectionViewItem * _Nullable(NSCollectionView * _Nonnull collectionView, NSIndexPath * _Nonnull indexPath, EditMachineSidebarItemModel * _Nonnull itemModel) {
        EditMachineSidebarViewItem *item = [collectionView makeItemWithIdentifier:EditMachineSidebarViewController.viewItemIdentifier forIndexPath:indexPath];
        item.itemModel = itemModel;
        return item;
    }];
    
    dataSource.supplementaryViewProvider = ^NSView * _Nullable(NSCollectionView * _Nonnull collectionView, NSString * _Nonnull elementKind, NSIndexPath * _Nonnull indexPath) {
        if ([elementKind isEqualToString:EditMachineSidebarViewController.separatorItemIdentifier]) {
            EditMachineSidebarSeparatorView *view = [collectionView makeSupplementaryViewOfKind:EditMachineSidebarViewController.separatorElementKind withIdentifier:EditMachineSidebarViewController.separatorItemIdentifier forIndexPath:indexPath];
            return view;
        } else {
            abort();
        }
    };
    
    _dataSource = dataSource;
    return dataSource;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.collectionView;
    scrollView.contentView.drawsBackground = NO;
    scrollView.drawsBackground = NO;
    
    _scrollView = scrollView;
    return scrollView;
}

- (EditMachineSidebarItemModel *)selectedItemModel {
    for (NSIndexPath *indexPath in self.collectionView.selectionIndexPaths) {
        if (EditMachineSidebarItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath]) {
            return itemModel;
        }
    }
    
    abort();
}

- (void)setSelectedItemModel:(EditMachineSidebarItemModel *)itemModel {
    [self selectItemModel:itemModel notifyingDelegate:NO];
}

- (void)selectItemModel:(EditMachineSidebarItemModel *)itemModel notifyingDelegate:(BOOL)notifyingDelegate {
    NSIndexPath *indexPath = [self.dataSource indexPathForItemIdentifier:itemModel];
    assert(indexPath != nil);
    
    reinterpret_cast<void (*)(id, SEL, id, NSCollectionViewScrollPosition, BOOL)>(objc_msgSend)(self.collectionView, sel_registerName("_selectItemsAtIndexPaths:scrollPosition:notifyDelegate:"), [NSSet setWithObject:indexPath], NSCollectionViewScrollPositionNone, notifyingDelegate);
}

- (void)collectionView:(NSCollectionView *)collectionView didSelectItemsAtIndexPaths:(NSSet<NSIndexPath *> *)indexPaths {
    id<EditMachineSidebarViewControllerDelegate> delegate = self.delegate;
    if (delegate == nil) return;
    
    assert(indexPaths.count < 2);
    
    if (NSIndexPath *indexPath = indexPaths.allObjects.firstObject) {
        EditMachineSidebarItemModel *itemModel = [self.dataSource itemIdentifierForIndexPath:indexPath];
        assert(itemModel != nil);
        [delegate editMachineSidebarViewController:self didSelectItemModel:itemModel];
    }
}

@end
