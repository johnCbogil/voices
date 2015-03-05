//
//  WebViewController.m
//  Voices
//
//  Created by Aditya Narayan on 3/4/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   // self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;

    // Load the URL from the previous view
    NSURL *websiteUrl = [NSURL URLWithString:(@"http://en.wikipedia.org/wiki/Protests_against_SOPA_and_PIPA") ];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;



}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
