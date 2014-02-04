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
@property CLLocationManager* locationManager;
@property CLLocation* currentLocation;
@property NSTimer* timer;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize mapView, currentLocation, locationManager, startButton, route, timer;
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
//        self.detailDescriptionLabel.text = [[self.detailItem valueForKey:@"timeStamp"] description];
    }
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

#pragma mark - CLLocationManagerDelegate protocol implementation
-(void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    currentLocation = [locations lastObject];
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = currentLocation.coordinate.latitude + rand() % 20;
    zoomLocation.longitude = currentLocation.coordinate.longitude + rand() % 20;
    NSLog(@"%f %f", zoomLocation.latitude, zoomLocation.longitude);
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 100 * METERS_PER_MILE,  100 * METERS_PER_MILE);

    
    MVLocation *annotation = [[MVLocation alloc] initWithTitle:[NSString stringWithFormat:@"%@", [NSDate date] ] andSubtitle:@"" andCoordinate:zoomLocation];
    
    [mapView addAnnotation:annotation];
//    [mapView setRegion:viewRegion animated:YES];
    [locationManager stopUpdatingLocation];
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



- (void)viewDidLoad
{
    [super viewDidLoad];
    currentLocation = [[CLLocation alloc] init];
    
    [self startStandardLocationService];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
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
    NSLog(@"time");
    [locationManager startUpdatingLocation];
}

- (IBAction)stopButtonTapped:(id)sender {
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButtonTapped:)];
    self.navigationItem.rightBarButtonItem = shareButton;
}

- (IBAction)shareButtonTapped:(id)sender {
    
}
@end
