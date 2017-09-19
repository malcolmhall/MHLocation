//
//  MasterViewController.h
//  MCLocationDemo
//
//  Created by Malcolm Hall on 13/10/2016.
//  Copyright © 2016 Malcolm Hall. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MCLocation/MCLocation.h>

@class DetailViewController;

@interface MasterViewController : MCLMapViewController

@property (strong, nonatomic) DetailViewController *detailViewController;


@end

