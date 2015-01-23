//
//  RootViewController.h
//  Location
//
//  Created by John Bogil on 1/22/15.
//  Copyright (c) 2015 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>


@property (strong, nonatomic) UIPageViewController *pageViewController;


@end
