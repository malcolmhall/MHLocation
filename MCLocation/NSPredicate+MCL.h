//
//  NSPredicate+Region.h
//  MCLocation
//
//  Created by Malcolm Hall on 26/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <MCLocation/MCLDefines.h>

@interface NSPredicate (MCL)

+ (NSPredicate *)MCL_predicateWithCoordinateRegion:(MKCoordinateRegion)region;
+ (NSPredicate *)MCL_predicateWithCoordinateRegion:(MKCoordinateRegion)region keyPrefix:(NSString *)keyPrefix;

@end
