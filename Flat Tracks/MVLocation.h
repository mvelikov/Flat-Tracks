//
//  MVLocation.h
//  Flat Tracks
//
//  Created by mihata on 2/3/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MVLocation : NSObject <MKAnnotation>

- (id)initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
