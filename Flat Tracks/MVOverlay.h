

#import <Foundation/Foundation.h>
@import MapKit;

@interface MVOverlay : NSObject <MKOverlay>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) MKMapRect boundingMapRect;
- (id) initWithRect: (MKMapRect) rect;

@property (nonatomic, strong) UIBezierPath* path;

@end
