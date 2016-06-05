//
//  NSPredicate+Region.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 26/04/2015.
//  Copyright (c) 2015 Dynamically Loaded. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSPredicate (Region)

+(NSPredicate*)mh_predicateWithCoordinateRegion:(MKCoordinateRegion)region;
+(NSPredicate*)mh_predicateWithCoordinateRegion:(MKCoordinateRegion)region keyPrefix:(NSString*)keyPrefix;

@end
