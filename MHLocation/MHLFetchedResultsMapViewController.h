//
//  MHLFetchedResultsMapViewController.h
//  MHLocation
//
//  Created by Malcolm Hall on 27/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>
#import <MHLocation/MHLDefines.h>
#import <MHLocation/MHLMapViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHLFetchedResultsMapViewController : MHLMapViewController<NSFetchedResultsControllerDelegate>

// The default value is "Cell".
@property (nonatomic, copy) NSString *annotationViewIdentifier;

@property (nonatomic, strong, nullable) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong, nullable) NSString *keyPrefix;

// not implemented
@property (nonatomic, assign) BOOL limitFetchToMapRegion;

// override to update the query
- (NSPredicate *)predicateForCoordinateRegion:(MKCoordinateRegion)region;

// override to configure the view.
- (void)configureAnnotationView:(MKAnnotationView *)annotationView annotation:(id<MKAnnotation>)annotation;

// defaults to allowing delete.
- (void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(NSManagedObject *)object;

// defaults to YES.
- (BOOL)canEditObject:(NSManagedObject *)managedObject;

// defaults to delete and saves context.
- (void)deleteObject:(NSManagedObject *)managedObject;

// calls performFetch then reloadData.
- (BOOL)reloadData:(NSError **)error;

@end

NS_ASSUME_NONNULL_END