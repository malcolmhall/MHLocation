//
//  CLLocationManager+Authorization.h
//  MHLocation
//
//  Created by Malcolm Hall on 20/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MHLocation/MHLDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface CLLocationManager (MHL)

// checks if the Info plist is configured correctly and requests the appropriate authorization depending on plist contents.
// NSLocationWhenInUseUsageDescription
+ (void)mhl_requestLocationAuthorizationIfNotDetermined;

@end

NS_ASSUME_NONNULL_END