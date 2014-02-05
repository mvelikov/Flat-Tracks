//
//  DetailViewController.m
//  Flat Tracks
//
//  Created by mihata on 1/31/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import "DetailViewController.h"
#import "MVLocation.h"
#define METERS_PER_MILE 1609.344

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) CLLocation* currentLocation;
@property (assign, nonatomic) CLLocationCoordinate2D previousLocation;
@property (weak, nonatomic) NSTimer* timer;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize mapView, currentLocation, locationManager, startButton, route, timer, previousLocation;
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentLocation = [[CLLocation alloc] init];
    mapView.delegate = self;
    
    [self addRoute];

    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 38.3244;
    zoomLocation.longitude = -121.424; //
    MVLocation *annotation = [[MVLocation alloc] initWithTitle:[NSString stringWithFormat:@"%@", [NSDate date] ] andSubtitle:@"" andCoordinate:zoomLocation];
    
    [mapView addAnnotation:annotation];

    [self configureView];
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.route) {
        [mapView setShowsUserLocation:YES];
//        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
}

- (void)addRoute {
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"EntranceToGoliathRoute" ofType:@"plist"];
    NSArray *pointsArray = [NSArray arrayWithContentsOfFile:thePath];
    
    NSInteger pointsCount = pointsArray.count;
    
    CLLocationCoordinate2D pointsToUse[pointsCount];
    
    for(int i = 0; i < pointsCount; i++) {
        CGPoint p = CGPointFromString(pointsArray[i]);
        pointsToUse[i] = CLLocationCoordinate2DMake(p.x,p.y);
    }
    
    self.routeLine = [MKPolyline polylineWithCoordinates:pointsToUse count:pointsCount];
    
    [mapView setVisibleMapRect:[self.routeLine boundingMapRect]]; //If you want the route to be visible
    
    [mapView addOverlay:self.routeLine];
//    [self.mapView addOverlay:myPolyline];
}

#pragma MKMapViewDelegate
- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:MKPolygon.class]) {
        MKPolylineRenderer *polygonView = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [UIColor magentaColor];
        
        return polygonView;
    } else if(overlay == self.routeLine) {
        if(nil == self.routeLineView) {
            self.routeLineView = [[MKPolylineRenderer alloc] initWithPolyline:self.routeLine];
            self.routeLineView.fillColor = [UIColor redColor];
            self.routeLineView.strokeColor = [UIColor redColor];
            self.routeLineView.lineWidth = 3;
        }
        
        return self.routeLineView;
    }
    
    return nil;
}

- (MKAnnotationView *)mapView:(MKMapView *)mapKitView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MVLocation";
    if ([annotation isKindOfClass:[MVLocation class]]) {
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [mapKitView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;

        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
