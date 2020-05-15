//
//  MCLNonBackgroundLocationManager.m
//  WiFiFoFum Intrepid
//
//  Created by Malcolm Hall on 20/10/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import "MCLNonBackgroundLocationManager.h"

@implementation MCLNonBackgroundLocationManager

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)applicationWillEnterForeground:(NSNotification *)note {
    //if the view is on screen start it up again
    if([self.delegate isKindOfClass:UIViewController.class]){
        UIViewController* vc = (UIViewController*)self.delegate;
        if (vc.view.window != nil) {
            [self startUpdatingLocation];
        }
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)note {
    //doesnt harm if already stopped in the case when not on this view
    [self stopUpdatingLocation];
}

@end
