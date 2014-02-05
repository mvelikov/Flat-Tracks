//
//  DetailViewController.h
//  Flat Tracks
//
//  Created by mihata on 1/31/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MVRoute.h"
#import "MVPoint.h"

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) MKPolyline *routeLine; //your line
@property (nonatomic, retain) MKPolylineRenderer *routeLineView; //overlay view

@property (weak, nonatomic) IBOutlet UIBarButtonItem *startButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *stopButton;

@property (weak, nonatomic) MVRoute *route;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
