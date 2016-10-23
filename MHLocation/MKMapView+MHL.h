//
//  MKMapView+MHL.h
//  MHLocation
//
//  Created by Malcolm Hall on 20/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <MHLocation/MHLDefines.h>

@interface MKMapView (MHL)

- (void)mhl_setCenterCoordinate:(CLLocationCoordinate2D)centerCoordinate
                  zoomLevel:(NSUInteger)zoomLevel
                   animated:(BOOL)animated;

- (MKCoordinateRegion)mhl_coordinateRegionWithMapView:(MKMapView *)mapView
                                centerCoordinate:(CLLocationCoordinate2D)centerCoordinate
                                    andZoomLevel:(NSUInteger)zoomLevel;
- (double)mhl_zoomLevel;

@end