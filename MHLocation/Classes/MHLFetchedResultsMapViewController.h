//
//  MHLFetchedResultsMapViewController.h
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 27/04/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import <MHLocation/MHLMapViewController.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface MHLFetchedResultsMapViewController : MHLMapViewController<NSFetchedResultsControllerDelegate>

// returns "Cell" if not set.
@property (nonatomic, copy) NSString* annotationViewIdentifier;

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

//convenience
@property (nonatomic, readonly) NSManagedObjectContext* managedObjectContext;

@property (strong) NSString* keyPrefix;

// unimplemented
@property (assign) BOOL limitFetchToMapRegion;

// override to update the query
-(NSPredicate*)predicateForCoordinateRegion:(MKCoordinateRegion)region;

// override to configure the view.
-(void)configureAnnotationView:(MKAnnotationView*)annotationView annotation:(id<MKAnnotation>)annotation;

// defaults to allowing delete.
-(void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(NSManagedObject*)object;

// defaults to YES.
-(BOOL)canEditObject:(NSManagedObject*)managedObject;

// defaults to delete and saves context.
-(void)deleteObject:(NSManagedObject*)managedObject;

@end
