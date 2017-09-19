//
//  MKMapView+MCL.h
//  MCoreLocation
//
//  Created by Malcolm Hall on 20/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MCoreLocation/MCLDefines.h>

@interface MKMapView (MCL)

- (void)MCL_setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (MKCoordinateRegion)MCL_coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                    andZoomLevel:(NSUInteger)zoomLevel;
- (double)MCL_zoomLevel;

@end
