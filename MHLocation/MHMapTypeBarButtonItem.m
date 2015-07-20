//
//  MHMapTypeBarButtonItem.m
//  MHLocation
//
//  Created by Malcolm Hall on 11/11/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import "MHMapTypeBarButtonItem.h"

// a pointer for observing
static NSString* kMapTypeChangedContext = @"kMapTypeChangedContext";

static NSString* const kMapTypeKeyPath = @"mapType";

@interface MHMapTypeBarButtonItem(){
    BOOL ignoreChange;
}
@property (copy) NSString* userDefaultsKey;
- (void)_segmentChanged:(UISegmentedControl*)sender;
@end

@implementation MHMapTypeBarButtonItem

- (id)initWithMapView:(MKMapView *)mapView userDefaultsKey:(NSString*)userDefaultsKey{
    self = [super init];
    if (self) {
        self.mapView = mapView;
        self.userDefaultsKey = userDefaultsKey;
        
        UISegmentedControl *sc = [[UISegmentedControl alloc] initWithItems:@[@"Standard", @"Hybrid", @"Satellite"]];
        //sc.autoresizingMask = UIViewAutoresizingFlexibleWidth; // width can go to zero when rotating from landscape
        [sc addTarget:self action:@selector(_segmentChanged:) forControlEvents:UIControlEventValueChanged];
        self.customView = sc;
        //listen for changes to the map's type
        [mapView addObserver:self forKeyPath:kMapTypeKeyPath options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                                             context:&kMapTypeChangedContext];
        if(userDefaultsKey){
            //set the default map type, this will also cause the segmented index to change.
            mapView.mapType = [[NSUserDefaults standardUserDefaults] integerForKey:userDefaultsKey];
        }else{
            //just set the segment to the current map type.
            int i = self.mapView.mapType;
            if(i > 0){
                //trick to switch order of satellite and hybrid
                i = (i % 2) + 1;
            }
            sc.selectedSegmentIndex = i;
        }
    }
    return self;
}
    
- (id)initWithMapView:(MKMapView *)mapView{
    return [self initWithMapView:mapView userDefaultsKey:nil];
}

- (void)_segmentChanged:(UISegmentedControl*)sender {
    ignoreChange = YES;
    NSInteger i = sender.selectedSegmentIndex;
    if(i > 0){
        //trick to switch order of satellite and hybrid
        i = (i % 2) + 1;
    }
    self.mapView.mapType = i;
    if(self.userDefaultsKey){
        [[NSUserDefaults standardUserDefaults] setInteger:i forKey:self.userDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    ignoreChange = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    // if it was our observation
    if(context == &kMapTypeChangedContext){
        if (!ignoreChange && [keyPath isEqualToString:kMapTypeKeyPath] )
        {
            UISegmentedControl* s = (UISegmentedControl*)self.customView;
            int i = self.mapView.mapType;
            if(i > 0){
                //trick to switch order of satellite and hybrid
                i = (i % 2) + 1;
            }
            s.selectedSegmentIndex = i;
        }
    }else{
        // if necessary, pass the method up the subclass hierarchy.
        if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]){
            [super observeValueForKeyPath:keyPath
                                 ofObject:object
                                   change:change
                                  context:context];
        }
    }
}

- (void)dealloc
{
    [self.mapView removeObserver:self forKeyPath:kMapTypeKeyPath];
    self.mapView = nil;
    self.customView = nil;
}



@end
