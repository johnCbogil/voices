//
//  ViewController.h
//  Location
//
//  Created by PJ Vea on 12/19/13.
//  Copyright (c) 2013 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Congressman.h"
#import "CustomTableViewCell.h"
#import "FBShimmering.h"
#import "FBShimmeringView.h"
#import "Reachability.h"


@interface ViewController : UIViewController  <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, UISearchBarDelegate, UISearchDisplayDelegate, loadTwitterViewProtocol, UINavigationControllerDelegate, UINavigationBarDelegate>


// UI Objects
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UILabel *voicesLabel;
@property (strong, nonatomic) IBOutlet UIButton *buttonLable;


// Data Properties
@property (strong, nonatomic) NSMutableData *responseData;
@property (strong, nonatomic) NSMutableArray *listOfMembers;
@property long long totalFileSize;
@property long long receivedDataBytes;

// Actions
-(IBAction)buttonPressed:(id)sender;




@end
