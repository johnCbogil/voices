//
//  ViewController.h
//  Location
//
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Congressman.h"
#import "CustomTableViewCell.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
#import "APIRequests.h"
#import "WebViewController.h"
#import "PageViewController.h"

@class PageViewController;
@class APIRequests;

@interface HomeViewController : UIViewController  <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, UISearchBarDelegate, UINavigationControllerDelegate>


// UI Objects
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *voicesLabel;
@property (strong, nonatomic) IBOutlet UIButton *whoRepsButton;
@property (strong, nonatomic) IBOutlet UILabel *swipeLeftLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *blueView;
//@property (strong, nonatomic) IBOutlet UILabel *pageHeaderOne;
@property (strong, nonatomic) IBOutlet UILabel *pageHeaderTwo;
@property (strong, nonatomic) IBOutlet UILabel *pageHeaderThree;
@property (strong, nonatomic) IBOutlet UITextView *voicesIsTextView;
@property (strong, nonatomic) IBOutlet UITextView *sopaTextView;
@property (strong, nonatomic) IBOutlet UITextView *scriptTextView;
@property (weak, nonatomic) IBOutlet UITextView *itsEasyTextView;
//@property (strong, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *buttonSeparator;
@property (strong, nonatomic) IBOutlet UILabel *whoRepsLabel;




//- (IBAction)hereLinkPressed:(id)sender;


// Data Properties

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (nonatomic) BOOL locationAuthorization;


@property (nonatomic, strong) FBShimmeringView *shimmeringView;




// Actions
-(IBAction)whoRepsButtonPressed:(id)sender;
- (IBAction)searchButtonPressed:(id)sender;


// Class properties

@property (nonatomic, strong) PageViewController *pageVC;
@property (nonatomic,strong) APIRequests *APIRequestsClass;

//- (void) hideActivityIndicator;
- (void)setDownloadShimmer:(BOOL)status;


@end
