//
//  MHMapViewSegue.m
//  Demo
//
//  Created by Malcolm Hall on 20/07/2015.
//  Copyright (c) 2015 Malcolm Hall. All rights reserved.
//

#import "MHAnnotationDetailSegue.h"

const NSString* kDefaultAnnotationDetailSegueIdentifier = @"showDetail";

@implementation MHAnnotationDetailSegue

- (void)perform
{
    UIViewController *source = (UIViewController *)self.sourceViewController;
    UINavigationController* nav = source.navigationController;
    if(source.presentedViewController){
         nav = (UINavigationController*)source.presentedViewController;
    }
    [nav pushViewController:self.destinationViewController animated:YES];
}

@end
