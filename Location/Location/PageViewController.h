//
//  RootViewController.h
//  Location
//
//  Created by John Bogil on 1/22/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

@class ViewController;

@interface PageViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (strong, nonatomic) ViewController *vc;



@end
