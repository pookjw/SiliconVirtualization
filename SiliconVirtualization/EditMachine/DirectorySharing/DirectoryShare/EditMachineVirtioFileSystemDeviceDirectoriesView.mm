//
//  EditMachineVirtioFileSystemDeviceDirectoriesView.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/24/25.
//

#import "EditMachineVirtioFileSystemDeviceDirectoriesView.h"
#import "EditMachineVirtioFileSystemDeviceDirectoriesTableCellView.h"
#import "EditMachineVirtioFileSystemDeviceDirectoryShareView.h"

@interface EditMachineVirtioFileSystemDeviceDirectoriesView () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineVirtioFileSystemDeviceDirectoriesView
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineVirtioFileSystemDeviceDirectoriesTableCellView class]);
}

- (instancetype)initWithFrame:(NSRect)frame {
    if (self = [super initWithFrame:frame]) {
        NSScrollView *scrollView = self.scrollView;
        scrollView.frame = self.bounds;
        scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        [self addSubview:scrollView];
        
        NSButton *createButton = self.createButton;
        createButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:createButton];
        [NSLayoutConstraint activateConstraints:@[
            [createButton.trailingAnchor constraintEqualToAnchor:self.layoutMarginsGuide.trailingAnchor],
            [createButton.bottomAnchor constraintEqualToAnchor:self.layoutMarginsGuide.bottomAnchor]
        ]];
    }
    
    return self;
}

- (void)dealloc {
    [_directories release];
    [_scrollView release];
    [_tableView release];
    [_createButton release];
    [super dealloc];
}

- (void)setDirectories:(NSDictionary<NSString *,VZSharedDirectory *> *)directories {
    [_directories release];
    _directories = [directories copy];
    [self.tableView reloadData];
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    
    _scrollView = scrollView;
    return scrollView;
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineVirtioFileSystemDeviceDirectoriesTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineVirtioFileSystemDeviceDirectoriesTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineVirtioFileSystemDeviceDirectoriesView.cellItemIdentifier];
    [cellNib release];
    
    NSTableColumn *nameColumn = [[NSTableColumn alloc] initWithIdentifier:@"name"];
    nameColumn.title = @"Name";
    [tableView addTableColumn:nameColumn];
    [nameColumn release];
    
    NSTableColumn *URLColumn = [[NSTableColumn alloc] initWithIdentifier:@"url"];
    URLColumn.title = @"URL";
    [tableView addTableColumn:URLColumn];
    [URLColumn release];
    
    tableView.allowsEmptySelection = YES;
    tableView.allowsMultipleSelection = NO;
    tableView.dataSource = self;
    tableView.delegate = self;
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    tableView.menu = menu;
    [menu release];
    
    _tableView = tableView;
    return tableView;
}

- (NSButton *)_createButton {
    if (auto createButton = _createButton) return createButton;
    
    NSButton *createButton = [NSButton new];
    createButton.image = [NSImage imageWithSystemSymbolName:@"plus" accessibilityDescription:nil];
    createButton.target = self;
    createButton.action = @selector(_didTriggerCreateButton:);
    
    _createButton = createButton;
    return createButton;
}

- (void)_didTriggerCreateButton:(NSButton *)sender {
    NSOpenPanel *panel = [NSOpenPanel new];
    panel.canChooseFiles = NO;
    panel.canChooseDirectories = YES;
    panel.allowsMultipleSelection = NO;
    
    EditMachineVirtioFileSystemDeviceDirectoryShareView *accessoryView = [EditMachineVirtioFileSystemDeviceDirectoryShareView new];
    [accessoryView setFrameSize:accessoryView.fittingSize];
    panel.accessoryView = accessoryView;
    
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            VZSharedDirectory *directory = [[VZSharedDirectory alloc] initWithURL:URL readOnly:accessoryView.readOnly];
            
            NSMutableDictionary<NSString *, VZSharedDirectory *> *directories = [self.directories mutableCopy];
            assert(directories != nil);
            directories[accessoryView.name] = directory;
            [directory release];
            
            self.directories = directories;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineVirtioFileSystemDeviceDirectoriesView:self didUpdateDirectories:directories];
            }
            
            [directories release];
        }
    }];
    
    [accessoryView release];
    [panel release];
}

- (void)menuWillOpen:(NSMenu *)menu {
    [menu removeAllItems];
    
    NSInteger clickedRow = self.tableView.clickedRow;
    if ((clickedRow == NSNotFound) or (clickedRow == -1)) return;
    
    NSMenuItem *deleteItem = [NSMenuItem new];
    deleteItem.title = @"Delete";
    deleteItem.image = [NSImage imageWithSystemSymbolName:@"trash.fill" accessibilityDescription:nil];
    deleteItem.target = self;
    deleteItem.action = @selector(_didTriggerDeleteItem:);
    [menu addItem:deleteItem];
    [deleteItem release];
}

- (void)_didTriggerDeleteItem:(NSMenuItem *)sender {
    NSInteger clickedRow = self.tableView.clickedRow;
    assert((clickedRow != NSNotFound) and (clickedRow != -1));
    
    // TODO: Cached Sorted Names
    NSArray<NSString *> *sortedNames = [self.directories.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSString *name = sortedNames[clickedRow];
    
    NSMutableDictionary<NSString *, VZSharedDirectory *> *directories = [self.directories mutableCopy];
    assert(directories != nil);
    [directories removeObjectForKey:name];
    
    self.directories = directories;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineVirtioFileSystemDeviceDirectoriesView:self didUpdateDirectories:directories];
    }
    
    [directories release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.directories.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSInteger columnIndex = [tableView.tableColumns indexOfObject:tableColumn];
    assert(columnIndex != NSNotFound);
    
    EditMachineVirtioFileSystemDeviceDirectoriesTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineVirtioFileSystemDeviceDirectoriesView.cellItemIdentifier owner:nil];
    
    // TODO: Cached Sorted Names
    NSArray<NSString *> *sortedNames = [self.directories.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString * _Nonnull obj1, NSString * _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    switch (columnIndex) {
        case 0: {
            cell.textField.stringValue = sortedNames[row];
            break;
        }
        case 1: {
            cell.textField.stringValue = self.directories[sortedNames[row]].URL.absoluteString;
            break;
        }
        default:
            abort();
    }
    
    return cell;
}

@end
