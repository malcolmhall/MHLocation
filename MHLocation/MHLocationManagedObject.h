//
//  MHLocationManagedObject.h
//  MHLocation
//
//  Created by Malcolm Hall on 22/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface MHLocationManagedObject : NSManagedObject

@property (nonatomic, retain) CLLocation* location; // transient

@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) double altitude;

@end

@interface MHLocationManagedObject(MKAnnotation)<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end