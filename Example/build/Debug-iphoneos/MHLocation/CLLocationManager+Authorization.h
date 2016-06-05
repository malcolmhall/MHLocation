//
//  CLLocationManager+Authorization.h
//  MHLocation
//
//  Created by Malcolm Hall on 20/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface CLLocationManager (Authorization)

// checks if the Info plist is configured correctly and requests the appropriate authorization depending on plist contents.
// NSLocationWhenInUseUsageDescription
+(void)mh_requestLocationAuthorizationIfNotDetermined;

@end
