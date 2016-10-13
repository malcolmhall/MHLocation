//
//  MHLManagedObject.m
//  MHLocation
//
//  Created by Malcolm Hall on 22/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "MHLManagedObject.h"


@interface MHLManagedObject()
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) double horizontalAccuracy;
@property (nonatomic) double verticalAccuracy;
@property (nonatomic) double course;
@property (nonatomic) double speed;
@property (nonatomic) double altitude;
@property (nonatomic, retain) NSDate* timestamp;
@end

@implementation MHLManagedObject

@dynamic latitude;
@dynamic longitude;
@dynamic horizontalAccuracy;
@dynamic verticalAccuracy;
@dynamic course;
@dynamic speed;
@dynamic altitude;
@dynamic timestamp;

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"coordinate"]) {
        NSArray *affectingKeys = @[@"location"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    else if([key isEqualToString:@"location"]) {
        NSArray *affectingKeys = @[@"latitude", @"longitude",@"horizontalAccuracy",@"verticalAccuracy",@"course",@"speed",@"altitude",@"timestamp"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}
//
//-(void)_setPrimitiveLocationValue:(id)value forKey:(NSString*)key{
//    [self willChangeValueForKey:key];
//    
//    [self setPrimitiveValue:value forKey:key];
//    // clear the location object so it can be re-generated
//    [self setPrimitiveValue:nil forKey:@"coreLocation"];
//    
//    [self didChangeValueForKey:key];
//}
//
//-(void)setLatitude:(NSNumber *)latitude {
//    [self _setPrimitiveLocationValue:latitude forKey:@"latitude"];
//}
//
//-(void)setLongitude:(NSNumber *)longitude {
//   [self _setPrimitiveLocationValue:longitude forKey:@"longitude"];
//}

- (void)setLocation:(CLLocation *)location {
    
    [self willChangeValueForKey:@"location"];
    
    self.latitude = location.coordinate.latitude;
    self.longitude = location.coordinate.longitude;
    self.horizontalAccuracy = location.horizontalAccuracy;
    self.verticalAccuracy = location.verticalAccuracy;
    self.timestamp = location.timestamp;
    self.speed = location.speed;
    self.course = location.course;
    self.altitude = location.altitude;
    
    [self didChangeValueForKey:@"location"];
}

- (CLLocation *)location {
    
    [self willAccessValueForKey:@"location"];
    
    CLLocation *location = [self primitiveValueForKey:@"location"];
    
    // check if we need to recreate the location.
    if (location == nil) {
        
        location = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(self.latitude, self.longitude)
                                                 altitude:self.altitude
                                       horizontalAccuracy:self.horizontalAccuracy
                                         verticalAccuracy:self.verticalAccuracy
                                                   course:self.course
                                                    speed:self.speed
                                                timestamp:self.timestamp];
        
        
        [self setPrimitiveValue:location forKey:@"location"];
    }
    
    [self didAccessValueForKey:@"location"];
    
    return location;
}

// used by MKAnnotation, we also have the required key-value observing methods above to notify the map when the location has changed so it can ask for the new coordinate.
- (CLLocationCoordinate2D)coordinate{
    return self.location.coordinate;
}

@end
