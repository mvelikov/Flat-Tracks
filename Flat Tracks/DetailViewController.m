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

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.route) {
        [mapView setShowsUserLocation:YES];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    currentLocation = [[CLLocation alloc] init];
    
    [self startStandardLocationService];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)startStandardLocationService {
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    locationManager.distanceFilter = 500;
    
    [locationManager startUpdatingLocation];
    
}

#pragma Implementing MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygon *polygon = (MKPolygon *)overlay;
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:polygon];
        //        renderer.fillColor =
        renderer.strokeColor = [UIColor darkGrayColor];
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolyline *polyline = (MKPolyline*) overlay;
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:polyline];
        renderer.fillColor = [UIColor redColor];
        renderer.strokeColor = [UIColor redColor];
        renderer.lineWidth = 3;
        
        return renderer;
    }
    return nil;
}

#pragma mark - CLLocationManagerDelegate protocol implementation
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = currentLocation.coordinate.latitude + rand() % 2;
    zoomLocation.longitude = currentLocation.coordinate.longitude + rand() % 2; //
    
    if (previousLocation.latitude) {
        CLLocationCoordinate2D coordinateArray[2];
        coordinateArray[0] = CLLocationCoordinate2DMake(zoomLocation.latitude, zoomLocation.longitude);
        coordinateArray[1] = CLLocationCoordinate2DMake(previousLocation.latitude, previousLocation.longitude);
        
        
        MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coordinateArray count:2];
        [self.mapView setVisibleMapRect:[polyline boundingMapRect]]; //If you want the route to be visible
        [self.mapView addOverlay:polyline];
    }
    
    previousLocation.latitude = currentLocation.coordinate.latitude;
    previousLocation.longitude = currentLocation.coordinate.longitude;
    MVPoint *point = [NSEntityDescription insertNewObjectForEntityForName:@"Point" inManagedObjectContext:self.managedObjectContext];
    
    [point setValue:[NSNumber numberWithDouble:zoomLocation.latitude] forKey:@"latitude"];
    [point setValue:[NSNumber numberWithDouble:zoomLocation.longitude] forKey:@"longitude"];
    [point setValue:[NSDate date] forKey:@"timeStamp"];
    
    [route addPointsObject:point];
    //    NSLog(@"%f %f", zoomLocation.latitude, zoomLocation.longitude);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 100 * METERS_PER_MILE,  100 * METERS_PER_MILE);
    
    
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.coordinate = zoomLocation;
    annotation.title = [NSString stringWithFormat:@"%@", [NSDate date]];
    
    [mapView addAnnotation:annotation];
    
    [mapView setRegion:viewRegion animated:YES];
    [locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)startButtonTapped:(id)sender {
    UIBarButtonItem *stopButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stopButtonTapped:)];
    self.navigationItem.rightBarButtonItem = stopButton;
    
    [route setValue:[NSDate date] forKey:@"start"];
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(updateLocation:) userInfo:nil repeats:YES];
    
}

- (void) updateLocation:(NSTimer*) timer {
    
    [locationManager startUpdatingLocation];
}

- (IBAction)stopButtonTapped:(id)sender {
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped:)];
    self.navigationItem.rightBarButtonItem = shareButton;
    
    [timer invalidate];
    
    [route setValue:[NSDate date] forKey:@"end"];
}

- (IBAction)shareButtonTapped:(id)sender {
    
}
@end
