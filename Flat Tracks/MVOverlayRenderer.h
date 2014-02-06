
#import <Foundation/Foundation.h>
@import MapKit;

@interface MVOverlayRenderer : MKOverlayRenderer;
- (id) initWithOverlay:(id <MKOverlay>)overlay angle: (CGFloat) angle;
@end
