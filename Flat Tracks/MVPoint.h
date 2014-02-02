//
//  Point.h
//  Flat Tracks
//
//  Created by mihata on 2/1/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MVPoint : NSManagedObject

@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSManagedObject *route;

@end
