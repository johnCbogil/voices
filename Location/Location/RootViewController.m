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
    UIViewController *thirdVC;
    UIViewController *fourthVC;
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
    thirdVC = [self.storyboard instantiateViewControllerWithIdentifier:@"thirdViewController"];
    fourthVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fourthViewController"];

    // This sets the starting VC
    viewControllers = @[firstVC];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    
    if (self.pageViewController.viewControllers[0] == secondVC)
    {
        return firstVC;
    }
    else if (self.pageViewController.viewControllers[0] == thirdVC){
        
        return secondVC;
    }
    else if (self.pageViewController.viewControllers[0] == fourthVC){
        return thirdVC;
    }


return nil;
}

    

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.pageViewController.viewControllers[0] == firstVC){
        
        return secondVC;

    }
    else if (self.pageViewController.viewControllers[0] == secondVC){
        return thirdVC;
    }
    else if (self.pageViewController.viewControllers[0] == thirdVC){
        return fourthVC;
    }
    else if (self.pageViewController.viewControllers[0] == fourthVC){
        return firstVC;
    }


    
    return nil;
}


@end
