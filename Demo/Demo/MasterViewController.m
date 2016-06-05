//
//  MasterViewController.m
//  Demo
//
//  Created by Malcolm Hall on 20/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"

@interface MasterViewController ()

// after inserting to this array also call the insert method below.
@property (nonatomic) NSMutableArray* annotations;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.annotations = [NSMutableArray array];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.annotationTablePresentationStyle = MHAnnotationTablePresentationStyleSheet;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)insertNewObject:(id)sender{
    [self insertNewAnnotationAtLocation:self.mapView.centerCoordinate];
}

-(void)insertNewAnnotationAtLocation:(CLLocationCoordinate2D)coord{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Add Annotation"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
     {
         textField.placeholder = @"text";
         textField.autocapitalizationType = UITextAutocapitalizationTypeSentences;
     }];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alert addAction:cancelAction];
    
    UIAlertAction* defaultAction =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:^(UIAlertAction * action) {
                               // do the insert
                              
                               UITextField *textField = alert.textFields.firstObject;
                               MKPointAnnotation* p = [[MKPointAnnotation alloc] init];
                               p.coordinate = coord;
                               p.title = textField.text;
                               
                               [self.annotations addObject:p];
                               [self insertAnnotationsAtIndexPaths:@[[NSIndexPath indexPathWithIndex:self.annotations.count - 1]]];
                           }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(id<MKAnnotation>)annotationAtIndex:(NSUInteger)index{
    return [self.annotations objectAtIndex:index];
}

- (NSInteger)numberOfAnnotations{
    return self.annotations.count;
}

-(NSUInteger)indexOfAnnotation:(id<MKAnnotation>)annotation{
    return [self.annotations indexOfObject:annotation];
}

-(void)willPresentDetailController:(UIViewController*)viewController annotation:(id<MKAnnotation>)annotation{
    DetailViewController* detailViewController = (DetailViewController*)viewController;
    detailViewController.detailItem = annotation.title;
}

// called both from the pin callout and the table disclosure button.
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([[segue identifier] isEqualToString:MHShowAnnotationDetailSegueIdentifier]) { // "showDetail"
//        MKAnnotationView* view = (MKAnnotationView*)sender;
//        [[segue destinationViewController] setDetailItem:view.annotation.title];
//    }
//}

@end
