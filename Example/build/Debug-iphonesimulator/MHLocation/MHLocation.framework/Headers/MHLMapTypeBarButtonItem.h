//
//  MHLMapTypeBarButtonItem.h
//  MapControllerTest
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

@interface MHLMapTypeBarButtonItem : UIBarButtonItem

- (id)initWithMapView:(MKMapView *)mapView;
- (id)initWithMapView:(MKMapView *)mapView userDefaultsKey:(NSString*)userDefaultsKey;

@property (nonatomic, retain) MKMapView *mapView;

@end