//
//  DLNonBackgroundLocationManager.h
//  WiFiFoFum Intrepid
//
//  Created by Malcolm Hall on 20/10/13.
//  Copyright (c) 2013 Dynamically Loaded. All rights reserved.
//

//Use in an app that supports background location whem you also want a location manager
//that won't keep run the app in the background. E.g. for the Radar view in WiFiFoFum
//when on that view and the app backgrounds you don't want that to keep it running in background.

//Note: you still should stop/start yourself on view willAppear/willDissapear.

// Redesign, shouldn't be a subclass. 

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import <MCoreLocation/MCLDefines.h>

NS_ASSUME_NONNULL_BEGIN

@interface MCLNonBackgroundLocationManager : CLLocationManager

@end

NS_ASSUME_NONNULL_END
