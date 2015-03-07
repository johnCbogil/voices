//
//  WebViewController.h
//  Voices
//
//  Created by Aditya Narayan on 3/4/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
- (IBAction)backButtonPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;

@end
