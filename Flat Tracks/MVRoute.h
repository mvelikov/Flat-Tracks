//
//  Route.h
//  Flat Tracks
//
//  Created by mihata on 2/1/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MVPoint;

@interface MVRoute : NSManagedObject

@property (nonatomic, retain) NSDate * start;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * end;
@property (nonatomic, retain) NSSet *points;
@end

@interface MVRoute (CoreDataGeneratedAccessors)

- (void)addPointsObject:(MVPoint *)value;
- (void)removePointsObject:(MVPoint *)value;
- (void)addPoints:(NSSet *)values;
- (void)removePoints:(NSSet *)values;

@end
