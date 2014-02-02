//
//  LibraryAPI.m
//  Flat Tracks
//
//  Created by mihata on 2/1/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import "LibraryAPI.h"
#import "PersistencyManager.h"

@interface LibraryAPI() {
    PersistencyManager *persistencyManager;
}

@end
@implementation LibraryAPI

- (id) init {
    self = [super init];
    
    if (self) {
        persistencyManager = [[PersistencyManager alloc] init];
    }
    
    return self;
}

+ (LibraryAPI*) sharedInstance {
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    [persistencyManager setManagedObjectContext:managedObjectContext];
}

@end
