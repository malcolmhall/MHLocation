//
//  MHLMapTypeBarButtonItem.h
//  MHLocation
//
//  Created by Malcolm Hall on 11/11/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

// Just add to a toolbar and you don't need to do anything else. Set the mapView.mapType and the seg control will automatically update.

/*
 If sharing the same default across different map views then put this in each view controller which will update the map to the previously saved setting by a different view controller.
 
 - (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mapView.mapType = [[[NSUserDefaults standardUserDefaults] objectForKey:MapTypePrefKey] integerValue];
 }
*/

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MHLocation/MHLDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHLMapTypeBarButtonItem : UIBarButtonItem

- (instancetype)initWithMapView:(MKMapView *)mapView;
- (instancetype)initWithMapView:(MKMapView *)mapView userDefaultsKey:(nullable NSString *)userDefaultsKey;

@property (nonatomic, strong) MKMapView *mapView;

@end

NS_ASSUME_NONNULL_END