//
//  Venue+Distance.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 22/04/2015.
//  Copyright (c) 2015 Dynamically Loaded. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface MHLocationManagedObject : NSManagedObject

@property (nonatomic, retain) CLLocation* location; // transient

@end

@interface MHLocationManagedObject(MKAnnotation)<MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end