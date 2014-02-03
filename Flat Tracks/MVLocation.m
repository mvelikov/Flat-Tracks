//
//  MVLocation.m
//  Flat Tracks
//
//  Created by mihata on 2/3/14.
//  Copyright (c) 2014 mihata. All rights reserved.
//

#import "MVLocation.h"
#import <AddressBook/AddressBook.h>

@interface MVLocation()
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end

@implementation MVLocation
- (id)initWithTitle:(NSString*)title andSubtitle:(NSString*)subtitle andCoordinate:(CLLocationCoordinate2D)coordinate {
    if (self = [super init]) {
        if ([title isKindOfClass:[NSString class]]) {
            self.title = title;
        } else {
            self.title = @"Unknown title";
        }
        self.subtitle = subtitle;
        self.theCoordinate = coordinate;
    }
    return self;
}


- (NSString *)title {
    return _title;
}

- (NSString *)subtitle {
    return _subtitle;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem *)mapItem {
    NSDictionary *titleDict = @{(NSString*) kABPersonAddressStreetKey: _title};
    
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinate addressDictionary:titleDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}
@end
