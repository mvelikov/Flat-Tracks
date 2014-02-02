//
//  PersistencyManager.h
//  Flat Tracks
//
//  Created by mihata on 2/1/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MVRoute.h"
#import "MVPoint.h"

@interface PersistencyManager : NSObject

//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (NSArray*) getRoutes;
- (NSDictionary*) getARouteWithAllPoints;
- (void) addRouteWithTitle: (NSString*)title;
- (void) deleteRouteAtIndex: (int)index;
- (void) endRoute: (MVRoute*)route;

- (NSArray*) getPointsForRoute: (MVRoute*)route;
- (void) addPointWithLatitude: (double)latitude andLongitude: (double)longitude ForRoute: (MVRoute*)route;
- (void) addPointWithLatitude:(double)latitude andLongitude:(double)longitude;
@end
