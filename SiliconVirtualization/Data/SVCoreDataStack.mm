//
//  SVCoreDataStack.m
//  SiliconVirtualization
//
//  Created by Jinwoo Kim on 3/18/25.
//

#import "SVCoreDataStack.h"
#import "NSManagedObjectModel+Category.h"
#import <Cocoa/Cocoa.h>

NSNotificationName const SVCoreDataStackDidInitializeNotification = @"SVCoreDataStackDidInitializeNotification";

@interface SVCoreDataStack ()
@property (retain, nonatomic, readonly, getter=_persistentContainer) NSPersistentContainer *persistentContainer;
@end

@implementation SVCoreDataStack

+ (SVCoreDataStack *)sharedInstance {
    static SVCoreDataStack *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [SVCoreDataStack new];
    });
    
    return instance;
}

+ (NSURL *)_localStoreURLWithCreatingDirectory:(BOOL)createDirectory __attribute__((objc_direct)) {
    NSFileManager *fileManager = NSFileManager.defaultManager;
    NSURL *applicationSupportURL = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask][0];
    NSURL *containerURL = [applicationSupportURL URLByAppendingPathComponent:NSRunningApplication.currentApplication.bundleIdentifier];
    
    if (createDirectory) {
        BOOL isDirectory;
        BOOL exists = [fileManager fileExistsAtPath:containerURL.path isDirectory:&isDirectory];
        
        NSError * _Nullable error = nil;
        
        if (!exists) {
            [fileManager createDirectoryAtURL:containerURL withIntermediateDirectories:YES attributes:nil error:&error];
            assert(error == nil);
        } else {
            assert(isDirectory);
        }
    }
    
    NSURL *result = [[containerURL URLByAppendingPathComponent:@"local"] URLByAppendingPathExtension:@"sqlite"];
    NSLog(@"%@", result.path);
    
    return result;
}

- (instancetype)init {
    if (self = [super init]) {
        NSManagedObjectContext *backgroundContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        
        [backgroundContext performBlock:^{
            NSPersistentContainer *persistentContainer = [[NSPersistentContainer alloc] initWithName:@"Container" managedObjectModel:[NSManagedObjectModel sv_makeManagedObjectModel]];
            
            NSPersistentStoreDescription *localPersistentStoreDescription = [[NSPersistentStoreDescription alloc] initWithURL:[SVCoreDataStack _localStoreURLWithCreatingDirectory:YES]];
            localPersistentStoreDescription.type = NSSQLiteStoreType;
            localPersistentStoreDescription.shouldAddStoreAsynchronously = NO;
            localPersistentStoreDescription.shouldInferMappingModelAutomatically = NO;
            localPersistentStoreDescription.shouldMigrateStoreAutomatically = NO;
            [localPersistentStoreDescription setOption:@YES forKey:NSPersistentHistoryTrackingKey];
            
            persistentContainer.persistentStoreDescriptions = @[localPersistentStoreDescription];
            [localPersistentStoreDescription release];
            
            [persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription * _Nonnull, NSError * _Nullable error) {
                assert(error == nil);
            }];
            
            assert(persistentContainer.persistentStoreCoordinator.persistentStores.count == 1);
            
            _persistentContainer = persistentContainer;
            backgroundContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator;
            
            [NSNotificationCenter.defaultCenter postNotificationName:SVCoreDataStackDidInitializeNotification object:self];
        }];
        
        _backgroundContext = backgroundContext;
    }
    
    return self;
}

- (void)dealloc {
    [_persistentContainer release];
    [_backgroundContext release];
    [super dealloc];
}

- (BOOL)isInitialized {
    return self.backgroundContext.persistentStoreCoordinator != nil;
}

@end
