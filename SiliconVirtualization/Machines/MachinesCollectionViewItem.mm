//
//  MachinesCollectionViewItem.mm
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "MachinesCollectionViewItem.h"
#import "SVCoreDataStack.h"

@interface MachinesCollectionViewItem ()

@end

@implementation MachinesCollectionViewItem

- (void)dealloc {
    [_objectID release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSTextField *textField = [NSTextField wrappingLabelWithString:@""];
    textField.selectable = NO;
    textField.textColor = NSColor.whiteColor;
    textField.backgroundColor = NSColor.systemPinkColor;
    textField.drawsBackground = YES;
    textField.frame = self.view.bounds;
    textField.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
    [self.view addSubview:textField];
    self.textField = textField;
    
    [self _updateTextField];
}

- (void)setObjectID:(NSManagedObjectID *)objectID {
    [_objectID release];
    _objectID = [objectID copy];
    [self _updateTextField];
}

- (void)_updateTextField {
    [self loadViewIfNeeded];
    
    NSTextField *textField = self.textField;
    assert(textField != nil);
    
    NSManagedObjectID *objectID = self.objectID;
    if (objectID == nil) {
        textField.stringValue = @"(null)";
        return;
    }
    assert(!objectID.temporaryID);
    
    NSManagedObjectContext *managedObjectContext = SVCoreDataStack.sharedInstance.backgroundContext;
    
    [managedObjectContext performBlock:^{
        SVVirtualMachine * _Nullable virtualMachine = [managedObjectContext objectWithID:objectID];
        NSDate * _Nullable timestamp = virtualMachine.timestamp;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.objectID isEqual:objectID] or (self.objectID == nil and objectID == nil)) {
                if (timestamp == nil) {
                    textField.stringValue = @"(null)";
                } else {
                    textField.stringValue = timestamp.description;
                }
            }
        });
    }];
}

@end
