//
//  RootViewController.m
//  Location
//
//  Created by John Bogil on 1/22/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()
{
    
    NSArray *viewControllers;
    
    UIViewController *firstVC;
    UIViewController *secondVC;
}
@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create page view controller
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    firstVC = [self.storyboard instantiateViewControllerWithIdentifier:@"firstViewController"];
    secondVC = [self.storyboard instantiateViewControllerWithIdentifier:@"secondViewController"];
    
    viewControllers = @[firstVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == secondVC)
        return firstVC;
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == firstVC)
        return secondVC;
    return nil;
}


@end
