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

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) MVRoute *route;
@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
