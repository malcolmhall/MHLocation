//
//  NSPredicate+MCL.m
//  MCoreLocation
//
//  Created by Malcolm Hall on 26/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "NSPredicate+MCL.h"

@implementation NSPredicate (MCL)

+ (NSPredicate *)mcl_predicateWithCoordinateRegion:(MKCoordinateRegion)region keyPrefix:(NSString *)keyPrefix{
    CLLocationCoordinate2D center = region.center;
    CLLocationCoordinate2D northWestCorner, southEastCorner;
    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    
    NSString *latitudeKey;
    NSString *longitudeKey;
    if(keyPrefix){
        latitudeKey = [NSString stringWithFormat:@"%@.latitude", keyPrefix];
        longitudeKey  = [NSString stringWithFormat:@"%@.longitude", keyPrefix];
    }else{
        latitudeKey = @"latitude";
        longitudeKey = @"longitude";
    }
    
    return [NSPredicate predicateWithFormat:@"%K > %f AND %K < %f AND %K > %f AND %K < %f", latitudeKey, northWestCorner.latitude, latitudeKey, southEastCorner.latitude, longitudeKey, southEastCorner.longitude, longitudeKey, northWestCorner.longitude];
}

+ (NSPredicate *)mcl_predicateWithCoordinateRegion:(MKCoordinateRegion)region{
    return [NSPredicate mcl_predicateWithCoordinateRegion:region keyPrefix:nil];
}

@end
