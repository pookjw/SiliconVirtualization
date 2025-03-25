//
//  EditMachineCoprocessorsTableViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/25/25.
//

#import "EditMachineCoprocessorsTableViewController.h"
#import "EditMachineCoprocessorsTableCellView.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface EditMachineCoprocessorsTableViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellItemIdentifier) NSUserInterfaceItemIdentifier cellItemIdentifier;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineCoprocessorsTableViewController
@synthesize scrollView = _scrollView;
@synthesize tableView = _tableView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellItemIdentifier {
    return NSStringFromClass([EditMachineCoprocessorsTableCellView class]);
}

- (void)dealloc {
    [_coprocessors release];
    [_scrollView release];
    [_tableView release];
    [_createButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSScrollView *scrollView = self.scrollView;
    scrollView.frame = self.view.bounds;
    scrollView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:scrollView];
    
    NSButton *createButton = self.createButton;
    createButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:createButton];
    [NSLayoutConstraint activateConstraints:@[
        [createButton.trailingAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.trailingAnchor],
        [createButton.bottomAnchor constraintEqualToAnchor:self.view.layoutMarginsGuide.bottomAnchor]
    ]];
}

- (void)setCoprocessors:(NSArray *)coprocessors {
    [_coprocessors release];
    _coprocessors = [coprocessors copy];
    
    [self _didChangeCoprocessors];
}

- (void)_didChangeCoprocessors {
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    
    if (tableView.numberOfRows > 0) {
        [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
    }
    
    [self _tableViewSelectionDidChange];
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
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineCoprocessorsTableCellView class]) bundle:[NSBundle bundleForClass:[EditMachineCoprocessorsTableCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineCoprocessorsTableViewController.cellItemIdentifier];
    [cellNib release];
    
    NSTableColumn *tableColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    [tableView addTableColumn:tableColumn];
    [tableColumn release];
    
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
    NSMenu *menu = [NSMenu new];
    
    {
        NSMenuItem *SEPItem = [NSMenuItem new];
        SEPItem.title = @"SEP";
        
        NSMenu *submenu = [NSMenu new];
        
        NSMenuItem *addExistingSEPStorageItem = [NSMenuItem new];
        addExistingSEPStorageItem.title = @"Add existing SEP Storage...";
        addExistingSEPStorageItem.target = self;
        addExistingSEPStorageItem.action = @selector(_didTriggerAddExistingSEPStorageItem:);
        [submenu addItem:addExistingSEPStorageItem];
        [addExistingSEPStorageItem release];
        
        NSMenuItem *createNewSEPStorageItem = [NSMenuItem new];
        createNewSEPStorageItem.title = @"Create new SEP Storage...";
        createNewSEPStorageItem.target = self;
        createNewSEPStorageItem.action = @selector(_didTriggerCreateNewSEPStorageItem:);
        [submenu addItem:createNewSEPStorageItem];
        [createNewSEPStorageItem release];
        
        SEPItem.submenu = submenu;
        [submenu release];
        [menu addItem:SEPItem];
        [SEPItem release];
    }
    
    [NSMenu popUpContextMenu:menu withEvent:self.view.window.currentEvent forView:sender];
    [menu release];
}

- (void)_didTriggerAddExistingSEPStorageItem:(NSMenuItem *)sender {
    NSOpenPanel *panel = [NSOpenPanel new];
    panel.canChooseFiles = YES;
    panel.canChooseDirectories = NO;
    panel.allowsMultipleSelection = NO;
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            id storage = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPStorage") alloc], sel_registerName("initWithURL:"), URL);
            
            id SEPCoprocessorConfiguration = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPCoprocessorConfiguration") alloc], sel_registerName("initWithStorage:"), storage);
            [storage release];
            
            NSArray *coprocessors = self.coprocessors;
            if (coprocessors == nil) {
                coprocessors = @[SEPCoprocessorConfiguration];
            } else {
                coprocessors = [coprocessors arrayByAddingObject:SEPCoprocessorConfiguration];
            }
            [SEPCoprocessorConfiguration release];
            
            self.coprocessors = coprocessors;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineCoprocessorsTableViewController:self didUpdateCoprocessors:coprocessors];
            }
        }
    }];
    
    [panel release];
}

- (void)_didTriggerCreateNewSEPStorageItem:(NSMenuItem *)sender {
    NSSavePanel *panel = [NSSavePanel new];
    
    [panel beginSheetModalForWindow:self.view.window completionHandler:^(NSModalResponse result) {
        if (NSURL *URL = panel.URL) {
            NSError * _Nullable error = nil;
            id storage = reinterpret_cast<id (*)(id, SEL, id, id *)>(objc_msgSend)([objc_lookUpClass("_VZSEPStorage") alloc], sel_registerName("initCreatingStorageAtURL:error:"), URL, &error);
            assert(error == nil);
            
            id SEPCoprocessorConfiguration = reinterpret_cast<id (*)(id, SEL, id)>(objc_msgSend)([objc_lookUpClass("_VZSEPCoprocessorConfiguration") alloc], sel_registerName("initWithStorage:"), storage);
            [storage release];
            
            NSArray *coprocessors = self.coprocessors;
            if (coprocessors == nil) {
                coprocessors = @[SEPCoprocessorConfiguration];
            } else {
                coprocessors = [coprocessors arrayByAddingObject:SEPCoprocessorConfiguration];
            }
            [SEPCoprocessorConfiguration release];
            
            self.coprocessors = coprocessors;
            
            if (auto delegate = self.delegate) {
                [delegate editMachineCoprocessorsTableViewController:self didUpdateCoprocessors:coprocessors];
            }
        }
    }];
    
    [panel release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.coprocessors.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineCoprocessorsTableCellView *cell = [tableView makeViewWithIdentifier:EditMachineCoprocessorsTableViewController.cellItemIdentifier owner:nil];
    
    id coprocessor = self.coprocessors[row];
    
    if ([coprocessor isKindOfClass:objc_lookUpClass("_VZSEPCoprocessorConfiguration")]) {
        cell.textField.stringValue = @"SEP Coprocessor";
    } else {
        abort();
    }
    
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([notification.object isEqual:self.tableView]) {
        [self _tableViewSelectionDidChange];
    }
}

- (void)_tableViewSelectionDidChange {
    auto delegate = self.delegate;
    if (delegate == nil) return;
    
    NSInteger selectedRow = self.tableView.selectedRow;
    [delegate editMachineCoprocessorsTableViewController:self didSelectAtIndex:selectedRow];
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
    
    NSMutableArray *coprocessors = [self.coprocessors mutableCopy];
    [coprocessors removeObjectAtIndex:clickedRow];
    
    self.coprocessors = coprocessors;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineCoprocessorsTableViewController:self didUpdateCoprocessors:coprocessors];
    }
    
    [coprocessors release];
}
@end
