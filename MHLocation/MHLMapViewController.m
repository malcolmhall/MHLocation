//
//  MapViewController.m
//  MHLocation
//
//  Created by Malcolm Hall on 10/11/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import "MHLMapViewController.h"
#import "MHLMapTypeBarButtonItem.h"
#import <objc/runtime.h>
#import "CLLocationManager+MHL.h"
#import "MHLAnnotationDetailSegue.h"

NSString * const MHShowAnnotationDetailSegueIdentifier = @"showAnnotationDetail";
NSString * const MHAnnotationCellIdentifier = @"annotation";

// Use & of this to get a unique pointer for this class.
static NSString *kShowsUserLocationChanged = @"kShowsUserLocationChanged";
static NSString *kDefaultAnnotationReuseIdentifier = @"Annotation";

//private API for getting the list icon instead of including the png as a resource.
#if defined(JB)

@interface UIImage(UIImagePrivate)

+ (UIImage *)kitImageNamed:(NSString*)named; // UIButtonBarListIcon

@end

#endif

//@interface MHAnnotationsSectionInfo : NSObject
//
///* Name of the section
// */
//@property (nonatomic) NSString *name;
//
///* Title of the section (used when displaying the index)
// */
//@property (nullable, nonatomic) NSString *indexTitle;
//
///* Number of objects in section
// */
//@property (nonatomic) NSUInteger numberOfObjects;
//
///* Returns the array of objects in the section.
// */
//@property (nullable, nonatomic) NSMutableArray *objects;
//
//@end // MHAnnotationsSectionInfo
//
//@implementation MHAnnotationsSectionInfo
//
//@end


@interface MHLMapViewController()

@property (nonatomic, readwrite) MHLMapTypeBarButtonItem* mapTypeBarButtonItem;
@property (nonatomic, readwrite) MKUserTrackingBarButtonItem* userTrackingBarButtonItem;
@property (nonatomic, readwrite) UIBarButtonItem* annotationsTableBarButtonItem;
@property (nonatomic, readwrite) NSArray<UIBarButtonItem*>* defaultToolBarItems;
@property (nonatomic) BOOL presentingAnnotationsTable;
@property (nonatomic) NSMutableArray<id<MKAnnotation>> *sections;
@property (nonatomic) NSLayoutConstraint* zeroHeightLayoutConstraint;
@property (nonatomic) NSLayoutConstraint* proportionalHeightLayoutConstraint;

@end

@implementation MHLMapViewController

-(id<MKAnnotation>)annotationAtIndex:(NSUInteger)index{
    return nil;
}

- (NSInteger)numberOfAnnotations{
    return 0;
}

- (NSUInteger)indexOfAnnotation:(id<MKAnnotation>)annotation{
    return NSNotFound;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    // set the default cell reuse identifer here so we can use it internally without copying every time we need it if we were to use an accessor and a nil check.
    _annotationReuseIdentifier = kDefaultAnnotationReuseIdentifier;
}

- (void)showDetailForAnnotation:(id<MKAnnotation>)annotation{
    // do the default segue if exists.
    @try {
        [self performSegueWithIdentifier:MHShowAnnotationDetailSegueIdentifier sender:annotation];
    }
    @catch (NSException *exception) {
        NSLog(@"Warning you must hookup a custom segue to a detail view controller with class %@ and identifier %@", NSStringFromClass([MHLAnnotationDetailSegue class]), MHShowAnnotationDetailSegueIdentifier);
//        NSLog(@"exception %@", exception);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender{
    if([segue.identifier isEqualToString:MHShowAnnotationDetailSegueIdentifier]){
        [self prepareForAnnotationDetailViewController:segue.destinationViewController annotation:sender];
    }
    // allow interaction after we have prevented possible duplicate taps
//    dispatch_async(dispatch_get_main_queue(), ^{
//        self.annotationsTableView.userInteractionEnabled = YES;
//    });
}

//-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
//    // prevent duplicate taps
//    self.annotationsTableView.userInteractionEnabled = NO;
//    return YES;
//}


- (void)prepareForAnnotationDetailViewController:(UIViewController *)viewController annotation:(id<MKAnnotation>)annotation{
    // the default implementatino does nothing
}

- (void)insertAnnotationsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    // convert to table index paths
    NSMutableArray* fixedIndexPaths = [NSMutableArray array];
    NSMutableArray* annotations = [NSMutableArray array];
    for(NSIndexPath* indexPath in indexPaths){
        NSInteger index = [indexPath indexAtPosition:0];
        // add to array for table
        [fixedIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
        // add to array for map
        [annotations addObject:[self annotationAtIndex:index]];
    }
    [self.annotationsTableView insertRowsAtIndexPaths:fixedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.mapView addAnnotations:annotations];
}

// we need to supply the annotations, because if this is called from a fetch controller delete then the annotation has already gone so cannot
// use annotationAtIndex:index like the insert does.
- (void)deleteAnnotations:(NSArray<id<MKAnnotation>>*)annotations atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths{
    NSMutableArray* fixedIndexPaths = [NSMutableArray array];
//    NSMutableArray* annotations = [NSMutableArray array];
    for(NSIndexPath* indexPath in indexPaths){
        NSInteger index = [indexPath indexAtPosition:0];
        [fixedIndexPaths addObject:[NSIndexPath indexPathForRow:index inSection:0]];
//        [annotations addObject:[self annotationAtIndex:index]]; // crashes on the fetched controller delegate delete because its already gone.
    }
    [self.mapView removeAnnotations:annotations];
    [self.annotationsTableView deleteRowsAtIndexPaths:fixedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}


//
//-(UITableViewController*)annotationsTableViewController{
//    if(_annotationsTableViewController){
//        return _annotationsTableViewController;
//    }
//    // try to get the relationship
//    @try {
//        [self performSegueWithIdentifier:@"empty" sender:nil];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Segue not found: %@", exception);
//    }
//    // now its either a valid one or nil.
//    return _annotationsTableViewController;
//}

- (MKMapView*)mapView{
    return (MKMapView*)self.view;
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

    self.userTrackingBarButtonItem = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];

    // save it to defaults
    self.mapTypeBarButtonItem = [[MHLMapTypeBarButtonItem alloc] initWithMapView:self.mapView userDefaultsKey:@"DLMapType"];
    
    // find a default image if one wasn't set
    UIImage* image;
#if defined(JB)
        image = [UIImage kitImageNamed:@"UIButtonBarListIcon"];
#else
        image = [UIImage imageNamed:@"UIButtonBarListIcon"];
#endif
    
    if(image){
        self.annotationsTableBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(annotationsTableBarButtonTapped:)];
    }else{
        self.annotationsTableBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(annotationsTableBarButtonTapped:)];
    }

    UIBarButtonItem* spacer1 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem* spacer2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    self.defaultToolBarItems = @[self.userTrackingBarButtonItem, spacer1, self.mapTypeBarButtonItem, spacer2, self.annotationsTableBarButtonItem];
    self.toolbarItems = self.defaultToolBarItems;
    
    // When they tap the tracking button request authorization
    [self.mapView addObserver:self
                   forKeyPath:@"showsUserLocation"
                      options:(NSKeyValueObservingOptionNew |
                               NSKeyValueObservingOptionOld)
                      context:&kShowsUserLocationChanged];
    
    if(self.mapView.showsUserLocation){
        [CLLocationManager mhl_requestLocationAuthorizationIfNotDetermined];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if([annotation isKindOfClass:[MKUserLocation class]]){
        return nil;
    }
    MKPinAnnotationView* pin = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:_annotationReuseIdentifier];
    if(!pin){
        pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:_annotationReuseIdentifier];
        // add button if necessary
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

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
   
    //NSLog(@"calloutAccessoryControlTapped");
    [self showDetailForAnnotation:view.annotation];

}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view{
    // dont select if not showing because it will crash if not loaded yet. It will be selected on first load anyway.
//    if(!self.presentingAnnotationsTable){
//        return;
//    }
    if(view.annotation == mapView.userLocation){
        return;
    }
    NSInteger index = [self indexOfAnnotation:view.annotation];
    if(index == NSNotFound){
        return;
    }
    [self.annotationsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
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
            [CLLocationManager mhl_requestLocationAuthorizationIfNotDetermined];
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

-(void)_tableViewDidLoadRows:(UITableView*)tableView{
    if(self.mapView.selectedAnnotations.count){
        NSInteger index = [self indexOfAnnotation:self.mapView.selectedAnnotations.firstObject];
        [self.annotationsTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // after its loaded select the cell so if they override cellForAnnotation they don't need to set selected.
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_tableViewDidLoadRows:) object:tableView];
    [self performSelector:@selector(_tableViewDidLoadRows:) withObject:tableView afterDelay:0];
    return [self numberOfAnnotations];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     static NSString *CellIdentifier = @"ScanCell";
     static NSString *SearchCellIdentifier = @"SearchScanCell";
     
     BOOL sa = tableView == self.searchDisplayController.searchResultsTableView;
     
     NSString *ident = sa ? SearchCellIdentifier : CellIdentifier;
     
     WiFiScanCell *cell = [tableView dequeueReusableCellWithIdentifier:ident forIndexPath:indexPath];
     
     cell.scan = self.searchDisplayController.isActive ? [_searchScans objectAtIndex:indexPath.row] : [_wifiScans objectAtIndex:indexPath.row];
     
     return cell;
     */
    id<MKAnnotation> annotation = [self annotationAtIndex:indexPath.row];
    return [self cellForAnnotation:annotation];
}

- (UITableViewCell *)cellForAnnotation:(id<MKAnnotation>)annotation{
    UITableViewCell *cell = [self.annotationsTableView dequeueReusableCellWithIdentifier:MHAnnotationCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MHAnnotationCellIdentifier];
        //only add the detail accessorty if there is a detail segue which is impossible to find out.
        //        if([self.mapView.delegate respondsToSelector:@selector(mapView:annotationView:calloutAccessoryControlTapped:)]){
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.backgroundColor = [UIColor clearColor];
        //      }
    }
    
    cell.textLabel.text = annotation.title;
    cell.detailTextLabel.text = annotation.subtitle;
    
    cell.selected = (annotation == self.mapView.selectedAnnotations.firstObject);
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<MKAnnotation> annotation = [self annotationAtIndex:indexPath.row];
    [self.mapView selectAnnotation:annotation animated:NO];
    //[self.mapView setRegion:MKCoordinateRegionMakeWithDistance(annotation.coordinate, 50.0, 50.0f) animated:NO];
    [self.mapView setCenterCoordinate:annotation.coordinate animated:YES];
    // only dismiss if its full screen.
    if(self.annotationTablePresentationStyle == MHLAnnotationTablePresentationStyleModal){
        [self dismissAnnotationsTable];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    id<MKAnnotation> annotation = [self annotationAtIndex:indexPath.row];
    [self showDetailForAnnotation:annotation];
}

- (void)annotationsTableBarButtonTapped:(id)sender{
    if(self.presentingAnnotationsTable){
        [self dismissAnnotationsTable];
    }else{
        [self presentAnnotationsTable];
    }
}

- (void)doneButtonTapped:(id)sender{
    [self dismissAnnotationsTable];
}

- (void)dismissAnnotationsTable{
    self.presentingAnnotationsTable = NO;
    [self willDismissAnnotationsTable];
    if(self.annotationTablePresentationStyle == MHLAnnotationTablePresentationStyleModal){
        [self dismissViewControllerAnimated:YES completion:^{
            [self didDismissAnnotationsTable];
        }];
    }
    else{
        UITableView *tableView = self.annotationsTableView;
        [UIView animateWithDuration:0.3 animations:^{
            self.zeroHeightLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
            self.proportionalHeightLayoutConstraint.priority = UILayoutPriorityDefaultLow;
            [tableView layoutIfNeeded];
        }];
    }
}

// fix the map region to take into account the sheet overlaying the map, when setting the center point it will now be a bit higher.
- (void)updateMargin{
    self.mapView.layoutMargins = UIEdgeInsetsMake(8, 8, 8 + self.annotationsTableView.frame.size.height, 8);
}

- (void)viewWillLayoutSubviews{
//    if(self.navigationController.toolbarHidden){
//        [self.tableView mh_setHidden:YES animated:YES completion:nil];
//    }
    if(self.annotationTablePresentationStyle == MHLAnnotationTablePresentationStyleSheet){
        [self updateMargin];
    }
}

- (void)presentAnnotationsTable{
    self.presentingAnnotationsTable = YES;
    
    UITableView *tableView = self.annotationsTableView;
    if(!tableView){
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //_annotationsTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.annotationsTableView = tableView;
    }
    tableView.dataSource = self;
    // if the table has been shown before then it needs reloaded to show anything new.
//    if(tableView.delegate == self){
//        [tableView reloadData];
//    }else{
    tableView.delegate = self;
//    }
    tableView.contentInset = UIEdgeInsetsZero; // fixes white gap that gets bigger every time its shown.
    tableView.scrollIndicatorInsets = UIEdgeInsetsZero; // fixes scroll indicators getting smaller and smaller.
    
    if(self.annotationTablePresentationStyle == MHLAnnotationTablePresentationStyleModal){
        UITableViewController *a = [[UITableViewController alloc] init];
        a.tableView = tableView;
        
        // todo check on this
        //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            a.clearsSelectionOnViewWillAppear = NO;
        //}
        
        //not needed because it inherits the tint from the nav controller's view.
        //if (_originatingNavigationController != nil) {
        // a.view.tintColor = _originatingNavigationController.topViewController.view.tintColor;
        //}
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            a.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneButtonTapped:)];
        }
        //this tries to create an automatic title.
        //first try and get nav bar title
        a.title = self.navigationItem.title;
        //then try and get tab bar title
        if(!a.title){
            a.title = self.title;
            //then try if they set a title on this bar button item
            if(!a.title){
                a.title = self.annotationsTableBarButtonItem.title;
                //default to results
                if(!a.title){
                    a.title = @"Results";
                }
            }
        }
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:a];
        
        UINavigationController *originatingNavigationController = self.navigationController;
        if (originatingNavigationController != nil) {
            navigationController.toolbar.tintColor = originatingNavigationController.toolbar.tintColor;
            navigationController.navigationBar.barStyle = originatingNavigationController.navigationBar.barStyle;
            navigationController.navigationBar.translucent = originatingNavigationController.navigationBar.translucent;
            navigationController.navigationBar.tintColor = originatingNavigationController.navigationBar.tintColor;
            navigationController.extendedLayoutIncludesOpaqueBars = originatingNavigationController.extendedLayoutIncludesOpaqueBars;
            navigationController.view.tintColor = originatingNavigationController.view.tintColor;
        }
        
    //    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
    //        self.popover = [[UIPopoverController alloc] initWithContentViewController:self.navigationController];
    //        [_popover presentPopoverFromBarButtonItem:self permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    //    }
    //    else{
    //        [containerViewController presentViewController:self.navigationController animated:YES completion:nil];
    //    }
    //    [self presentViewController:navigationController animated:YES completion:nil];
        [self showDetailViewController:navigationController sender:self];
    }
    else if(self.annotationTablePresentationStyle == MHLAnnotationTablePresentationStyleSheet){
        [self.view addSubview:tableView];
        if(!tableView.constraints.count){
            NSLayoutConstraint* leading = [tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor];
            NSLayoutConstraint* trailing = [tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor];
            NSLayoutConstraint* bottom = [tableView.bottomAnchor constraintEqualToAnchor:self.bottomLayoutGuide.topAnchor];
            
            // when presenting make it a proportion of the superview
            self.proportionalHeightLayoutConstraint = [tableView.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.4];
            self.proportionalHeightLayoutConstraint.priority = UILayoutPriorityDefaultLow;
            
            // when hiding make it zero height.
            self.zeroHeightLayoutConstraint = [tableView.heightAnchor constraintEqualToConstant:0];
            self.zeroHeightLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
            
            NSArray<NSLayoutConstraint*>* constraintsToActivate = @[leading, trailing, bottom, self.proportionalHeightLayoutConstraint, self.zeroHeightLayoutConstraint];
            [constraintsToActivate enumerateObjectsUsingBlock:^(NSLayoutConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.active = YES;
            }];
            tableView.translatesAutoresizingMaskIntoConstraints = NO;
            // show it in its initial hidden position.
            [tableView layoutIfNeeded];
            
            // since this is the first time also add the blurred background
            UIVisualEffectView* blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
            blurView.frame = tableView.frame;
            blurView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            tableView.backgroundView = blurView;
            
            tableView.backgroundColor = [UIColor clearColor];
        }
        // present the table expanding from the bottom.
        [UIView animateWithDuration:0.3 animations:^{
            self.zeroHeightLayoutConstraint.priority = UILayoutPriorityDefaultLow;
            self.proportionalHeightLayoutConstraint.priority = UILayoutPriorityDefaultHigh;
            [tableView layoutIfNeeded];
        }];
    }else{
        self.presentingAnnotationsTable = NO;
    }
}

- (void)willDismissAnnotationsTable{

}

- (void)didDismissAnnotationsTable{
    
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




