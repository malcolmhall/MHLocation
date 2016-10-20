//
//  MasterViewController.h
//  MHLocationDemo
//
//  Created by Malcolm Hall on 13/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MHLocation/MHLocation.h>

@class DetailViewController;

@interface MasterViewController : MHLMapViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

