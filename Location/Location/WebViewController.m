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
    //self.webView = [[UIWebView alloc]init];
    self.webView.delegate = self;
    [self showActivityInidcator];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.navBar.barTintColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1];
    self.navBar.tintColor = [UIColor whiteColor];

    
    
    // Load the URL from the previous view
    NSURL *websiteUrl = [NSURL URLWithString:(@"http://www.nytimes.com/2012/01/21/technology/senate-postpones-piracy-vote.html?_r=0") ];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:websiteUrl];
    [self.webView loadRequest:urlRequest];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self webViewDidFinishLoad:self.webView];
    



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

- (void) showActivityInidcator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.alpha = 1.0;
    //self.activityIndicator.color = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1.0];
    self.activityIndicator.center = CGPointMake(300, -22.0);
    self.activityIndicator.hidesWhenStopped = YES;
    [self.webView addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void) hideActivityIndicator {
    [self.activityIndicator stopAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if ([[webView stringByEvaluatingJavaScriptFromString:@"document.readyState"] isEqualToString:@"complete"]) {
        [self hideActivityIndicator];
    }
}

//- (IBAction)hereLinkPressed:(id)sender {
//  NSLayoutManager *layoutManager = self.sopaTextView.layoutManager;
//  CGPoint location = [sender locationInView:self.sopaTextView];
//  location.x -= self.sopaTextView.textContainerInset.left;
//  location.y -= self.sopaTextView.textContainerInset.top;
//
//  NSUInteger characterIndex;
//  characterIndex = [layoutManager
//                        characterIndexForPoint:location
//                               inTextContainer:self.sopaTextView.textContainer
//      fractionOfDistanceBetweenInsertionPoints:NULL];
//
//  if (characterIndex > 118) {
//
//    NSRange range;
//    id value = [self.sopaTextView.attributedText attribute:@"myCustomTag"
//                                                   atIndex:characterIndex
//                                            effectiveRange:&range];
//
//    NSLog(@"%@, %lu, %lu", value, (unsigned long)range.location,
//          (unsigned long)range.length);
//
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    [self.view.window.rootViewController
//        presentViewController:
//            [self.storyboard
//                instantiateViewControllerWithIdentifier:@"webViewController"]
//                     animated:YES
//                   completion:nil];
//  }
//}

@end
