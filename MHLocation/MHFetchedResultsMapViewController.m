//
//  MHFetchedResultsMapViewController.m
//  WiFiFoFum-Passwords
//
//  Created by Malcolm Hall on 27/04/2015.
//  Copyright (c) 2015 Dynamically Loaded. All rights reserved.
//

#import "MHFetchedResultsMapViewController.h"
#import "NSPredicate+Region.h"

NSString* kDefaultAnnotationViewIdentifier = @"Pin";

@interface MHFetchedResultsMapViewController()

//@property (nonatomic) NSPredicate* previousPredicate;

@end

@implementation MHFetchedResultsMapViewController{
    NSFetchedResultsController* _fetchedResultsController;
    NSFetchRequest* _fetchRequest;
    MKCoordinateRegion _lastCoordinateRegion;
}

-(NSManagedObjectContext*)managedObjectContext{
    return self.fetchedResultsController.managedObjectContext;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    // set the default cell reuse identifer here so we can use it internally without copying every time we need it if we were to use an accessor and a nil check.
    _annotationViewIdentifier = kDefaultAnnotationViewIdentifier;
    self.limitFetchToMapRegion = NO;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)setFetchedResultsController:(NSFetchedResultsController *)fetchedResultsController{
    _fetchedResultsController = fetchedResultsController;
    _fetchedResultsController.delegate = self;
    // only reload if the view is loaded because we will do the first load after the view loads.
    if(self.isViewLoaded){
        [self reloadData];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self reloadData];
}

-(NSPredicate*)predicateForCoordinateRegion:(MKCoordinateRegion)region{
    return [NSPredicate mh_predicateWithCoordinateRegion:region];
}

// perform a new fetch
-(void)reloadData{
    MKCoordinateRegion region = self.mapView.region;
    
//    if(self.limitFetchToMapRegion){
//        // if the predicate hasn't changed and we haven't moved then do nothing.
//        if(self.previousPredicate == _fetchedResultsController.fetchRequest.predicate){
//            if(region.center.latitude == _lastCoordinateRegion.center.latitude && region.center.longitude == _lastCoordinateRegion.center.longitude && region.span.latitudeDelta == _lastCoordinateRegion.span.latitudeDelta && region.span.longitudeDelta == _lastCoordinateRegion.span.longitudeDelta){
//                return;
//            }
//        }
//        NSPredicate* predicate = [self predicateForCoordinateRegion:region];
//        if(_fetchedResultsController.fetchRequest.predicate){
//            predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[_fetchedResultsController.fetchRequest.predicate, predicate]];
//        }
//        _fetchedResultsController.fetchRequest.predicate = predicate;
//        
//    }
    
    if(!_fetchedResultsController){
        return;
    }
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    NSArray* fetchedObjects = _fetchedResultsController.fetchedObjects;
    
    NSMutableArray* removeAnnotations = [NSMutableArray array];
    NSMutableArray* addAnnotations = [NSMutableArray array];
    
    // find the annotations to remove from the map
    for(id<MKAnnotation> annotation in self.mapView.annotations){
        // todo check if kind of class that that the results controller is supposed to be returning.
        if([annotation isEqual:self.mapView.userLocation]){
            // do nothing with user
        }
        else if([fetchedObjects containsObject:annotation]){
            // already on map
        }else{
            [removeAnnotations addObject:annotation];
        }
    }
    // find the annotations to add to the map
    for(id<MKAnnotation> annotation in fetchedObjects){
        if([self.mapView.annotations containsObject:annotation]){
            // already on the map
        }
        else{
            [addAnnotations addObject:annotation];
        }
    }
    
    [self.mapView removeAnnotations:removeAnnotations];
    [self.mapView addAnnotations:addAnnotations];
    [self.annotationsTableView reloadData];
    
    //[self.mapView showAnnotations:fetchedObjects animated:YES];
    
    _lastCoordinateRegion = region;
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    // don't listen to map changes until after the view has appeared. (its called while map is initializing).
    if(!_fetchedResultsController){
        return;
    }
    if(!self.limitFetchToMapRegion){
        return;
    }
    // load once they have stopped panning
    [self delayedReload];
}

-(void)delayedReload{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(reloadData) object:nil];
    [self performSelector:@selector(reloadData) withObject:nil afterDelay:0.5];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    if(annotation == mapView.userLocation){
        return nil;
    }
    MKPinAnnotationView* view = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:_annotationViewIdentifier];
    if(!view){
        view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:_annotationViewIdentifier];
        // todo only if annotation has a title
        view.canShowCallout = YES;
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        UIImage *image = [[UIImage imageNamed:@"DisclosureArrow"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [rightButton setImage:image forState:UIControlStateNormal];
        [rightButton sizeToFit];
        view.rightCalloutAccessoryView = rightButton;
    }
    [self configureAnnotationView:view annotation:annotation];
    return view;
}

-(void)configureAnnotationView:(MKAnnotationView*)annotationView annotation:(id<MKAnnotation>)annotation{
    annotationView.annotation = annotation;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return [self canEditObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

//default to yes to match normal.
-(BOOL)canEditObject:(NSManagedObject*)managedObject{
    return YES;
}

-(void)deleteObject:(NSManagedObject*)managedObject{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    [context deleteObject:managedObject];
    NSError* error;
    if(![context save:&error]){
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //#ifdef DEBUG
        abort();
        //#endif
    }
}

-(void)commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forObject:(NSManagedObject*)object{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteObject:object];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self commitEditingStyle:editingStyle forObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}
/*
 
 - (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath{
 return YES;
 }
 
 - (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
 return action == @selector(copy:);
 }
 
 
 - (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
 MyApp *myApp = (MyApp*) [self.fetchedResultsController objectAtIndexPath:indexPath];
 [UIPasteboard generalPasteboard].string = clip.text;
 }
 */

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != _fetchedResultsController){
        return;
    }
    // begin updates
    [self.annotationsTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    if(controller != _fetchedResultsController){
        return;
    }
    switch(type) {
        case NSFetchedResultsChangeInsert:
            //[tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            //[mapView addAnnotation:anObject];
            [self insertAnnotationsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:newIndexPath.row]]];
            break;
            
        case NSFetchedResultsChangeDelete:
            //[mapView removeAnnotation:anObject];
            [self deleteAnnotations:@[anObject] atIndexPaths:@[[NSIndexPath indexPathWithIndex:indexPath.row]]];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //NSLog(@"Update");
            // previously we called configure cell but that didn't allow an update to change cell type.
            [self.annotationsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
            
        case NSFetchedResultsChangeMove:
        {
            //NSLog(@"Move");
            if(![indexPath isEqual:newIndexPath]){
                //NSLog(@"move %@ to %@", indexPath, newIndexPath);
                // move assumes reload however if we do both it crashes with 2 animations cannot be done at the same time.
                [self.annotationsTableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.annotationsTableView reloadRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                });
            }else{
                //NSLog(@"Move %@", indexPath);
                // it hadn't actually moved but it was updated. Required as of iOS 9.
                [self.annotationsTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if(controller != _fetchedResultsController){
        return;
    }
    // end updates
    [self.annotationsTableView endUpdates];
}

- (id<MKAnnotation>)annotationAtIndex:(NSUInteger)index{
    return [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (NSInteger)numberOfAnnotations{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections].firstObject;
    return [sectionInfo numberOfObjects];
}

-(NSUInteger)indexOfAnnotation:(id<MKAnnotation>)annotation{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections].firstObject;
    return [sectionInfo.objects indexOfObject:annotation];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

-(void)dealloc{
    NSLog(@"dealloc");
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
}

@end
