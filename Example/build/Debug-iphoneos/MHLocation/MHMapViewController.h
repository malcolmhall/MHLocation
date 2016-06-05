//
//  MapViewController.h
//  LeoMapDemo2
//
//  Created by Malcolm Hall on 10/11/13.
//  Copyright (c) 2013 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

//Create a navigation based app.
//In the storyboard delete the master (table) view controller.
//Drag in a view controller and hook it up as the root in the navigation controlller.
//On navigation controller also check "Shows toolbar".
//In code change MasterViewController to be a subclass of MHMapViewController and delete all table code.
//That's it!

// To show a detail view controller when tapping the callout accessory or list view disclosure button,
// Add the new view controller and control drag from the map controller to the new one,
// Choose 'annotation detail' segue and set the identifer showDetail.
// Now in the map view controller subclass add this method, the MKAnnotation is the sender.


typedef NS_ENUM(NSInteger, MHAnnotationTablePresentationStyle) {
    MHAnnotationTablePresentationStyleModal,
    MHAnnotationTablePresentationStyleSheet
};

extern NSString* const MHShowAnnotationDetailSegueIdentifier; // The default is 'showAnnotationDetail' so set that identifier in the storyboard manual segue.
extern NSString* const MHAnnotationCellIdentifier; // To use a custom cell in the table view that is hooked up to the outlet use the identifier 'annotation'

@class MHMapTypeBarButtonItem, MHAnnotationsTableBarButtonItem;
@protocol MHMapViewControllerDataSource;

@interface MHMapViewController : UIViewController<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

//@property (nonatomic, weak, nullable) id <MHMapViewControllerDataSource> dataSource;

@property (nonatomic, readonly) MKMapView *mapView;

@property (nonatomic, readonly) MKUserTrackingBarButtonItem *userTrackingBarButtonItem;

@property (nonatomic, readonly) MHMapTypeBarButtonItem* mapTypeBarButtonItem;

@property (nonatomic, readonly) UIBarButtonItem* annotationsTableBarButtonItem;

// contains the 3 buttons and spacers.
@property (nonatomic, readonly) NSArray<UIBarButtonItem*>* defaultToolBarItems;

// defaults to "Annotation"
@property (nonatomic, copy) NSString* annotationReuseIdentifier;

@property (nonatomic) IBOutlet UITableView* annotationsTableView;

// if this is changed while the table is presented the behavior is undefined.
@property (assign) MHAnnotationTablePresentationStyle annotationTablePresentationStyle;

-(void)presentAnnotationsTable;

-(void)dismissAnnotationsTable;

// tapping the callout disclousure on a annotation view or the table cell accessory calls this. The default implementation calls performSegueWithIdentifier:MHShowAnnotationDetailSegueIdentifier
// and catches the exception if it doesn't exist.
-(void)showDetailForAnnotation:(id<MKAnnotation>)annotation;

// override to customise the detail controller. Internally this uses prepareForSegue so if you override that then you must call super.
-(void)prepareForAnnotationDetailViewController:(UIViewController*)viewController annotation:(id<MKAnnotation>)annotation;

// If you override prepareForSegue you must call super.

// inserts to table then adds to map. The annotation must have been added to annotations before calling these methods.
- (void)insertAnnotationsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)deleteAnnotations:(NSArray<id<MKAnnotation>>*)annotations atIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;
- (void)reloadAnnotationsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths;

- (id<MKAnnotation>)annotationAtIndex:(NSUInteger)index;
-(NSUInteger)indexOfAnnotation:(id<MKAnnotation>)annotation;
- (NSInteger)numberOfAnnotations;
- (UITableViewCell *)cellForAnnotation:(id<MKAnnotation>)annotation;
@end

//@protocol MHMapViewDelegate <MKMapViewDelegate>
//
//@optional
////supply an image for the annotation to support showing images for off-map annotation views.
//-(UIImage*)imageForAnnotation:(id<MKAnnotation>)annotation;
//
//@end

@protocol MHMapViewControllerDataSource<NSObject>
//@required

/*
@required

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;              // Default is 1 if not implemented

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;    // fixed font style. use custom view (UILabel) if you want something different
- (nullable NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section;

// Editing

// Individual rows can opt out of having the -editing property set for them. If not implemented, all rows are assumed to be editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath;

// Moving/reordering

// Allows the reorder accessory view to optionally be shown for a particular row. By default, the reorder control will be shown only if the datasource implements -tableView:moveRowAtIndexPath:toIndexPath:
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath;

// Index

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView __TVOS_PROHIBITED;                                                    // return list of section titles to display in section index view (e.g. "ABCD...Z#")
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index __TVOS_PROHIBITED;  // tell table which section corresponds to section title/index (e.g. "B",1))

// Data manipulation - insert and delete support

// After a row has the minus or plus button invoked (based on the UITableViewCellEditingStyle for the cell), the dataSource must commit the change
// Not called for edit actions using UITableViewRowAction - the action's handler will be invoked instead
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

// Data manipulation - reorder / moving support

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
*/
@end

NS_ASSUME_NONNULL_END
