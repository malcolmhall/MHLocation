//
//  NSPredicate+Region.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 26/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface NSPredicate (MHL)

+(NSPredicate*)mhl_predicateWithCoordinateRegion:(MKCoordinateRegion)region;
+(NSPredicate*)mhl_predicateWithCoordinateRegion:(MKCoordinateRegion)region keyPrefix:(NSString*)keyPrefix;

@end
