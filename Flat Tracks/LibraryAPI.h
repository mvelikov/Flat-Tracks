//
//  LibraryAPI.h
//  Flat Tracks
//
//  Created by mihata on 2/1/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Route.h"
#import "Point.h"

@interface LibraryAPI : NSObject

+ (LibraryAPI*)sharedInstance;

- (NSArray*) getRoutes;
- (NSDictionary*) getARouteWithAllPoints;
- (void) addRouteWithTitle: (NSString*)title;
- (void) deleteRouteAtIndex: (int)index;
- (void) endRoute: (Route*)route;

- (NSArray*) getPointsForRoute: (Route*)route;
- (void) addPointWithLatitude: (double)latitude andLongitude: (double)longitude ForRoute: (Route*)route;
- (void) addPointWithLatitude:(double)latitude andLongitude:(double)longitude;

- (void) setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController;
- (void) setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
//- (void) saveData;
@end
