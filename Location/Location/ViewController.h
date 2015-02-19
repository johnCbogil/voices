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
#import "NSURLConnections.h"


@interface ViewController : UIViewController  <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, UISearchBarDelegate>


// UI Objects
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *voicesLabel;
@property (strong, nonatomic) IBOutlet UIButton *whoRepsButton;
@property (strong, nonatomic) IBOutlet UILabel *aboutLabel;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIView *blueView;



// Data Properties

@property (strong, nonatomic) NSMutableData *googleResponseData;
@property (strong, nonatomic) NSMutableData *sfResponseData;
@property (strong, nonatomic) NSMutableData *photoResponseData;

@property (strong, nonatomic) NSURLConnection *googleConn;
@property (strong, nonatomic) NSURLConnection *sfConnection;
@property (strong, nonatomic) NSURLConnection *photoConnection;

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *currentLocation;

@property (strong, nonatomic) NSMutableArray *cleanedPhones;

@property (strong, nonatomic) NSMutableArray *sfCongressmen;
@property (strong, nonatomic) NSMutableArray *googCongressmen;
@property (strong, nonatomic) NSMutableArray *congressmenPhotos;
@property (strong, nonatomic) NSMutableArray *bioGuides;
@property int photoRequestCounter;

@property (strong, nonatomic) Congressman *sfDude;





@property long long totalFileSize;
@property long long receivedDataBytes;

// Actions
-(IBAction)buttonPressed:(id)sender; //improve this name
- (IBAction)searchButtonPressed:(id)sender;




@property (nonatomic,strong) NSURLConnections *NSURLConnectionsClass;


@end
