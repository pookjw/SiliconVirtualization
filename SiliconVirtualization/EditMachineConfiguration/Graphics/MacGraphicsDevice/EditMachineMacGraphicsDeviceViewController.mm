//
//  EditMachineMacGraphicsDeviceViewController.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/16/25.
//

#import "EditMachineMacGraphicsDeviceViewController.h"
#import "EditMachineMacGraphicsDeviceCellView.h"
#import <objc/message.h>
#import <objc/runtime.h>

@interface EditMachineMacGraphicsDeviceViewController () <NSTableViewDataSource, NSTableViewDelegate, NSMenuDelegate>
@property (class, nonatomic, readonly, getter=_cellIdentifier) NSUserInterfaceItemIdentifier cellIdentifier;
@property (retain, nonatomic, readonly, getter=_tableView) NSTableView *tableView;
@property (retain, nonatomic, readonly, getter=_scrollView) NSScrollView *scrollView;
@property (retain, nonatomic, readonly, getter=_createButton) NSButton *createButton;
@end

@implementation EditMachineMacGraphicsDeviceViewController
@synthesize tableView = _tableView;
@synthesize scrollView = _scrollView;
@synthesize createButton = _createButton;

+ (NSUserInterfaceItemIdentifier)_cellIdentifier {
    return NSStringFromClass([EditMachineMacGraphicsDeviceCellView class]);
}

- (void)dealloc {
    [_macGraphicsDeviceConfiguration release];
    [_tableView release];
    [_scrollView release];
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
    
    [self _didChangeDelegate];
}


- (void)setMacGraphicsDeviceConfiguration:(VZMacGraphicsDeviceConfiguration *)macGraphicsDeviceConfiguration {
    if (macGraphicsDeviceConfiguration != nil) {
        assert([macGraphicsDeviceConfiguration isKindOfClass:[VZMacGraphicsDeviceConfiguration class]]);
    }
    
    [_macGraphicsDeviceConfiguration release];
    _macGraphicsDeviceConfiguration = [macGraphicsDeviceConfiguration copy];
    
    NSTableView *tableView = self.tableView;
    NSInteger selectedRow = tableView.selectedRow;
    [tableView reloadData];
    [tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:selectedRow] byExtendingSelection:NO];
}

- (void)setDelegate:(id<EditMachineMacGraphicsDeviceViewControllerDelegate>)delegate {
    _delegate = delegate;
    [self _didChangeDelegate];
}

- (void)_didChangeDelegate {
    self.createButton.hidden = (self.delegate == nil);
}

- (NSTableView *)_tableView {
    if (auto tableView = _tableView) return tableView;
    
    NSTableView *tableView = [NSTableView new];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.allowsEmptySelection = YES;
    tableView.style = NSTableViewStyleFullWidth;
    
    NSNib *cellNib = [[NSNib alloc] initWithNibNamed:NSStringFromClass([EditMachineMacGraphicsDeviceCellView class]) bundle:[NSBundle bundleForClass:[EditMachineMacGraphicsDeviceCellView class]]];
    [tableView registerNib:cellNib forIdentifier:EditMachineMacGraphicsDeviceViewController.cellIdentifier];
    [cellNib release];
    
    NSTableColumn *heightColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    heightColumn.title = @"Height";
    [tableView addTableColumn:heightColumn];
    [heightColumn release];
    
    NSTableColumn *widthColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    widthColumn.title = @"Width";
    [tableView addTableColumn:widthColumn];
    [widthColumn release];
    
    NSTableColumn *inchColumn = [[NSTableColumn alloc] initWithIdentifier:@""];
    inchColumn.title = @"Inch";
    [tableView addTableColumn:inchColumn];
    [inchColumn release];
    
    NSMenu *menu = [NSMenu new];
    menu.delegate = self;
    tableView.menu = menu;
    [menu release];
    
    _tableView = tableView;
    return tableView;
}

- (NSScrollView *)_scrollView {
    if (auto scrollView = _scrollView) return scrollView;
    
    NSScrollView *scrollView = [NSScrollView new];
    scrollView.documentView = self.tableView;
    
    _scrollView = scrollView;
    return scrollView;
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
    VZMacGraphicsDisplayConfiguration *configuration = [[VZMacGraphicsDisplayConfiguration alloc] initWithWidthInPixels:1920 heightInPixels:1080 pixelsPerInch:92];
    
    VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration = [self.macGraphicsDeviceConfiguration copy];
    
    NSArray<VZMacGraphicsDisplayConfiguration *> *displays = macGraphicsDeviceConfiguration.displays;
    if (displays == nil) {
        displays = @[configuration];
    } else {
        displays = [displays arrayByAddingObject:configuration];
    }
    [configuration release];
    macGraphicsDeviceConfiguration.displays = displays;
    
    self.macGraphicsDeviceConfiguration = macGraphicsDeviceConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacGraphicsDeviceViewController:self didUpdateConfiguration:macGraphicsDeviceConfiguration];
    }
    
    [macGraphicsDeviceConfiguration release];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.macGraphicsDeviceConfiguration.displays.count;
}

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    EditMachineMacGraphicsDeviceCellView *cell = [tableView makeViewWithIdentifier:EditMachineMacGraphicsDeviceViewController.cellIdentifier owner:nil];
    VZMacGraphicsDisplayConfiguration *displayConfiguration = self.macGraphicsDeviceConfiguration.displays[row];
    
    NSInteger index = [tableView.tableColumns indexOfObject:tableColumn];
    if (index == 0) {
        cell.textField.stringValue = @(displayConfiguration.heightInPixels).stringValue;
    } else if (index == 1) {
        cell.textField.stringValue = @(displayConfiguration.widthInPixels).stringValue;
    } else if (index == 2) {
        cell.textField.stringValue = @(displayConfiguration.pixelsPerInch).stringValue;
    } else {
        abort();
    }
    
    return cell;
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    if ([notification.object isEqual:self.tableView]) {
        auto delegate = self.delegate;
        if (delegate == nil) return;
        
        [delegate editMachineMacGraphicsDeviceViewController:self didSelectAtIndex:self.tableView.selectedRow];
    }
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
    
    NSMenuItem *prefersLowPowerItem = [NSMenuItem new];
    prefersLowPowerItem.title = @"Prefers Low Power";
    prefersLowPowerItem.image = [NSImage imageWithSystemSymbolName:@"battery.25percent" accessibilityDescription:nil];
    prefersLowPowerItem.target = self;
    prefersLowPowerItem.action = @selector(_didTriggerPrefersLowPowerItem:);
    BOOL _prefersLowPower = reinterpret_cast<BOOL (*)(id, SEL)>(objc_msgSend)(self.macGraphicsDeviceConfiguration, sel_registerName("_prefersLowPower"));
    prefersLowPowerItem.state = _prefersLowPower ? NSControlStateValueOn : NSControlStateValueOff;
    [menu addItem:prefersLowPowerItem];
    [prefersLowPowerItem release];
}

- (void)_didTriggerDeleteItem:(NSMenuItem *)sender {
    NSInteger clickedRow = self.tableView.clickedRow;
    assert((clickedRow != NSNotFound) and (clickedRow != -1));
    
    VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration = [self.macGraphicsDeviceConfiguration copy];
    
    NSMutableArray<VZMacGraphicsDisplayConfiguration *> *displays = [macGraphicsDeviceConfiguration.displays mutableCopy];
    [displays removeObjectAtIndex:clickedRow];
    macGraphicsDeviceConfiguration.displays = displays;
    [displays release];
    
    self.macGraphicsDeviceConfiguration = macGraphicsDeviceConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacGraphicsDeviceViewController:self didUpdateConfiguration:macGraphicsDeviceConfiguration];
    }
    
    [macGraphicsDeviceConfiguration release];
}


- (void)_didTriggerPrefersLowPowerItem:(NSMenuItem *)sender {
    BOOL _prefersLowPower = (sender.state != NSControlStateValueOn);
    
    VZMacGraphicsDeviceConfiguration *macGraphicsDeviceConfiguration = [self.macGraphicsDeviceConfiguration copy];
    reinterpret_cast<void (*)(id, SEL, BOOL)>(objc_msgSend)(macGraphicsDeviceConfiguration, sel_registerName("_setPrefersLowPower:"), _prefersLowPower);
    
    self.macGraphicsDeviceConfiguration = macGraphicsDeviceConfiguration;
    
    if (auto delegate = self.delegate) {
        [delegate editMachineMacGraphicsDeviceViewController:self didUpdateConfiguration:macGraphicsDeviceConfiguration];
    }
    
    [macGraphicsDeviceConfiguration release];
}

@end
