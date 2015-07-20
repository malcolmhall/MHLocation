//
//  MapViewController.m
//  LeoMapDemo2
//
//  Created by Malcolm Hall on 10/11/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import "MHMapViewController.h"
#import "MHMapTypeBarButtonItem.h"
#import "MHAnnotationsTableBarButtonItem.h"
#import <objc/runtime.h>
#import "CLLocationManager+Authorization.h"

// Use & of this to get a unique pointer for this class.
static NSString* kShowsUserLocationChanged = @"kShowsUserLocationChanged";
static NSString* kDefaultAnnotationReuseIdentifier = @"Annotation";

@implementation MHMapViewController{
    MKUserTrackingBarButtonItem* _defaultUserTrackingBarButtonItem;
    MHMapTypeBarButtonItem* _defaultMapTypeBarButtonItem;
    MHAnnotationsTableBarButtonItem* _defaultAnnotationsTableBarButtonItem;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    // set the default cell reuse identifer here so we can use it internally without copying every time we need it if we were to use an accessor and a nil check.
    _annotationReuseIdentifier = kDefaultAnnotationReuseIdentifier;
}

-(MKMapView*)mapView{
    return (MKMapView*)self.view;
}

-(void)setUserTrackingBarButtonItem:(MKUserTrackingBarButtonItem *)userTrackingBarButtonItem{
    _userTrackingBarButtonItem = userTrackingBarButtonItem;
    [self _reloadToolBarItems];
}

-(void)setMapTypeBarButtonItem:(MHMapTypeBarButtonItem *)mapTypeBarButtonItem{
    _mapTypeBarButtonItem = mapTypeBarButtonItem;
    [self _reloadToolBarItems];
}

-(void)setAnnotationsTableBarButtonItem:(MHAnnotationsTableBarButtonItem *)annotationsTableBarButtonItem{
    _annotationsTableBarButtonItem = annotationsTableBarButtonItem;
    [self _reloadToolBarItems];
}

-(void)_reloadToolBarItems{
    //teh flexible spaces allow the buttons to spread out evenly when switching to landscape.
    //only add buttons that are not nil, i.e. havent been removed.
    NSMutableArray* toolBarItems = [NSMutableArray array];
    if(_userTrackingBarButtonItem){
        [toolBarItems addObject:_userTrackingBarButtonItem];
    }
    [toolBarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    if(_mapTypeBarButtonItem){
        [toolBarItems addObject:_mapTypeBarButtonItem];
    }
    [toolBarItems addObject:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]];
    
    if(_annotationsTableBarButtonItem){
        [toolBarItems addObject:_annotationsTableBarButtonItem];
    }
    self.toolbarItems = toolBarItems;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //magic to work without a view set in the storboard or in code.
    //check if a view has been set in the storyboard, like what UITableViewController does.
    //check if don't have a map view
    if(![self.view isKindOfClass:[MKMapView class]]){
        //check if the default view was loaded. Default view always has no background color.
        if([self.view isKindOfClass:[UIView class]] && !self.view.backgroundColor){
            // replace the view with the map view
            self.view = [[MKMapView alloc] initWithFrame:CGRectZero];
        }else{
            // todo: make a proper exception.
            [NSException raise:@"MapViewController didn't find a map view" format:@"Found a %@. Check the storyboard view controller has had its default view swapped to a map", self.view.class];
        }
    }
    
    _defaultUserTrackingBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    _userTrackingBarButtonItem = _defaultUserTrackingBarButtonItem;

    // save it to defaults
    _defaultMapTypeBarButtonItem = [[MHMapTypeBarButtonItem alloc] initWithMapView:self.mapView userDefaultsKey:@"DLMapType"];
    _mapTypeBarButtonItem = _defaultMapTypeBarButtonItem;
    
    _defaultAnnotationsTableBarButtonItem = [[MHAnnotationsTableBarButtonItem alloc] initWithMapView:self.mapView];
    _annotationsTableBarButtonItem = _defaultAnnotationsTableBarButtonItem;
    
    [self _reloadToolBarItems];

    self.navigationController.toolbarHidden = NO;
    
    // When they tap the tracking button request authorization
    [self.mapView addObserver:self
                   forKeyPath:@"showsUserLocation"
                      options:(NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionOld)
                      context:&kShowsUserLocationChanged];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:_annotationReuseIdentifier];
    if(!pin){
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:_annotationReuseIdentifier];
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImage *image = [[UIImage imageNamed:@"DisclosureArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton sizeToFit];
        pin.rightCalloutAccessoryView = rightButton;
    }
    pin.annotation = annotation;
    pin.canShowCallout = annotation.title ? YES : NO;
    return pin;
}

- (void)dealloc
{
    // remove the observer to prevent a crash somehint that is dealloced cannot still be observing.
    [self.mapView removeObserver:self forKeyPath:@"showsUserLocation"];
}

// New in iOS 8 this technique results in this warning shown:
// Trying to start MapKit location updates without prompting for location authorization. Must call -[CLLocationManager requestWhenInUseAuthorization] or -[CLLocationManager requestAlwaysAuthorization] first.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    // if it was our observation
    if(context == &kShowsUserLocationChanged){
        if([[change objectForKey:NSKeyValueChangeNewKey] boolValue]){
            [CLLocationManager mh_requestLocationAuthorizationIfNotDetermined];
        }
    }
    else{
        // if necessary, pass the method up the subclass hierarchy.
        if([super respondsToSelector:@selector(observeValueForKeyPath:ofObject:change:context:)]){
            [super observeValueForKeyPath:keyPath
                                 ofObject:object
                                   change:change
                                  context:context];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

// Category for requesting authorization
/*
@implementation MKMapView(Authorization)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(setShowsUserLocation:);
        SEL swizzledSelector = @selector(mh_setShowsUserLocation:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)mh_setShowsUserLocation:(BOOL)showsUserLocation{
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        BOOL always = NO;
        if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
            always = YES;
        }
        else if(![[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]){
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Location usage description missing from Info.plist" userInfo:nil];
        }
        static CLLocationManager* lm = nil;
        static dispatch_once_t once;
        dispatch_once(&once, ^ {
            // Code to run once
            lm = [[CLLocationManager alloc] init];
        });
        if(always){
            [lm requestAlwaysAuthorization];
        }else{
            [lm requestWhenInUseAuthorization];
        }
    }
    [self mh_setShowsUserLocation:showsUserLocation];
}

@end
*/




