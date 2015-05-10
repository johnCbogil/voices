#import "HomeViewController.h"

@interface HomeViewController ()
@end

@implementation HomeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    
    self.APIRequestsClass = [[APIRequests alloc] init];
    self.APIRequestsClass.HomeViewController = self;
    
    self.tableView.alpha = 0.0;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.swipeLeftLabel.textColor = [UIColor colorWithRed:83.0 / 255
                                                green:95.0 / 255.0
                                                 blue:107.0 / 255.0
                                                alpha:1.0];
    [self createVoicesLabel];
    [self createParallaxEffect];
    [self createDownloadShimmer];
    [self createSearchBar];
    [self createButtonSeparator];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [tap addTarget:self action:@selector(searchBarCancelButtonClicked:)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"ReloadTableViewNotification" object:nil];
    

    [self createLocationManager];
//    [self.manager requestWhenInUseAuthorization];
    
    [self checkForLocationServices];
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

- (UIMotionEffectGroup *)createMotionEffect {
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    
    verticalMotionEffect.minimumRelativeValue = @(-7);
    verticalMotionEffect.maximumRelativeValue = @(7);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect = [
                                                           [UIInterpolatingMotionEffect alloc]
                                                           initWithKeyPath:@"center.x"
                                                           type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    
    horizontalMotionEffect.minimumRelativeValue = @(-7);
    horizontalMotionEffect.maximumRelativeValue = @(7);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[ horizontalMotionEffect, verticalMotionEffect ];
    
    return group;
}

- (void)createVoicesLabel {

    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir" size:80]];
    self.voicesLabel.textColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                 green:(128.0 / 255.0)
                                                  blue:(5.0 / 255.0)
                                                 alpha:1.0];
    
    shimmeringView.contentView = self.voicesLabel;
    //shimmeringView.shimmering = YES;
}

- (void)createParallaxEffect{
    
    UIMotionEffectGroup *motionEffect = [self createMotionEffect];
    
    [self.tableView addMotionEffect:motionEffect];
    [self.voicesLabel addMotionEffect:motionEffect];
    [self.whoRepsButton addMotionEffect:motionEffect];
    [self.searchButton addMotionEffect:motionEffect];
    [self.searchBar addMotionEffect:motionEffect];
    [self.blueView addMotionEffect:motionEffect];
    [self.swipeLeftLabel addMotionEffect:motionEffect];
    [self.whoRepsLabel addMotionEffect:motionEffect];
    
}

- (void)createDownloadShimmer{
    
// Set the entire button to shimmer
//    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.blueView.bounds];
//    //shimmeringView.alpha = .25;
//    [self.blueView addSubview:shimmeringView];
//    
//    self.blueView = [[UIView alloc] initWithFrame:shimmeringView.bounds];
//
//    
//    UIView * v = [[UIView alloc] initWithFrame:shimmeringView.bounds];
//    [v setBackgroundColor:[UIColor whiteColor]];
//    
//    
//    shimmeringView.contentView = self.blueView;
//    
//    // Start shimmering.
//    shimmeringView.shimmering = YES;
    

    self.shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.whoRepsLabel.bounds];
    
    [self.whoRepsLabel addSubview:self.shimmeringView];
    
    self.whoRepsLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.bounds];
    
    self.whoRepsLabel.textAlignment = NSTextAlignmentCenter;
    
    self.whoRepsLabel.text = NSLocalizedString(@"Your Community", nil);
    [self.whoRepsLabel setFont:[UIFont fontWithName:@"Avenir" size:20]];
    self.whoRepsLabel.textColor = [UIColor whiteColor];
    
    self.shimmeringView.contentView = self.whoRepsLabel;

    
}

- (void)setDownloadShimmer:(BOOL)status{
    
    self.shimmeringView.shimmering = status;
  
}

- (void)createButtonSeparator {
    self.buttonSeparator = [[UIView alloc] initWithFrame:CGRectMake(247, 55, 1, 28)];
    self.buttonSeparator.backgroundColor =
    [UIColor colorWithRed:133 green:133. blue:133 alpha:.5];
    
    [self.buttonSeparator addMotionEffect:[self createMotionEffect]];
    [self.view addSubview:self.buttonSeparator];
}

#pragma mark - UISearchBar methods

- (void)createSearchBar {
    
    self.blueView.layer.cornerRadius = 5;
    self.blueView.backgroundColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                    green:(128.0 / 255.0)
                                                     blue:(5.0 / 255.0)
                                                    alpha:1.0];
    
    self.searchBar.alpha = 0.0;
    self.searchBar.userInteractionEnabled = NO;
    self.searchBar.delegate = self;
    
    // Set cancel button to white color
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]forState:UIControlStateNormal];
    
    // Set placeholder text to white
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil]setTextColor:[UIColor whiteColor]];
    
    // Set the input text font
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setDefaultTextAttributes:@{NSFontAttributeName : [UIFont fontWithName:@"Avenir" size:15],
                                }];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setDefaultTextAttributes:@{
                                NSForegroundColorAttributeName : [UIColor whiteColor]
                                }];
    
    self.searchButton.imageEdgeInsets =
    UIEdgeInsetsMake(self.searchButton.frame.size.height - 35,
                     self.searchButton.frame.size.width - 35, 12, 12);
    
    [self.searchBar setImage:[UIImage new]
            forSearchBarIcon:UISearchBarIconSearch
                       state:UIControlStateNormal];
    [[UISearchBar appearance] setPositionAdjustment:UIOffsetMake(-20, 0)
                                   forSearchBarIcon:UISearchBarIconSearch];
    
    [self.searchBar setTintColor:[UIColor whiteColor]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setTintColor:[UIColor colorWithRed:255.0 / 255.0
                                  green:160.0 / 255.0
                                   blue:5.0 / 255.0
                                  alpha:1.0]];
    
    [self.searchBar setImage:[UIImage imageNamed:@"clearButton"]
            forSearchBarIcon:UISearchBarIconClear
                       state:UIControlStateHighlighted];
    [self.searchBar setImage:[UIImage imageNamed:@"clearButton"]
            forSearchBarIcon:UISearchBarIconClear
                       state:UIControlStateNormal];
}

- (IBAction)searchButtonPressed:(id)sender {
    
    self.buttonSeparator.hidden = YES;
    
    [self.searchBar becomeFirstResponder];
    self.whoRepsButton.enabled = NO;
    self.searchButton.hidden = YES;
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.whoRepsLabel.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.searchBar.userInteractionEnabled = YES;
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.searchBar.alpha = 1.0;
                                          }];
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.buttonSeparator.alpha = 0.0;
                                          }];
                     }];
}



- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    NSLog(@"Cancel button pressed");
    self.searchBar.text = nil;
    [self.APIRequestsClass.googleMapsConnection cancel];
    [self.APIRequestsClass.sfConnection cancel];
    [self.APIRequestsClass.googleCivConnection cancel];
    [self.APIRequestsClass.photoConnection cancel];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //[self hideActivityIndicator];
    [self setDownloadShimmer:NO];
    self.buttonSeparator.hidden = NO;
    self.whoRepsButton.enabled = YES;
    [UIView animateWithDuration:.2
                     animations:^{
                         self.searchBar.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.searchBar.userInteractionEnabled = NO;
                         [UIView animateWithDuration:.2
                                          animations:^{
                                              self.whoRepsLabel.alpha = 1.0;
                                          }];
                         self.searchButton.hidden = NO;
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.buttonSeparator.alpha = 1.0;
                                          }];
                         
                     }];
}

#pragma mark - Execute Request Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self setDownloadShimmer:YES];
   // [self showActivityInidcator];
    if (self.searchBar.text.length > 0) {
        
        // check for internet
        [self createLocationManager];
        [self.manager requestWhenInUseAuthorization];
        Reachability *networkReachability =
        [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus =
        [networkReachability currentReachabilityStatus];
        
        if (networkStatus == NotReachable) {
            //[self hideActivityIndicator];
            [self setDownloadShimmer:NO];
            UIAlertView *noInternetConnection = [[UIAlertView alloc]
                                                 initWithTitle:@"No Internet Connection"
                                                 message:
                                                 @"Please check your network connection and try again"
                                                 delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [noInternetConnection show];
            
        } else {
            
            [self.searchBar resignFirstResponder];
            [self.APIRequestsClass determineGPSCoordinates:self.searchBar.text];
        }
    }
}

- (IBAction)whoRepsButtonPressed:(id)sender {
    NSLog(@"Button Pressed");
//    if (!self.activityIndicator) {
//        [self showActivityInidcator];
//    }
    [self setDownloadShimmer:YES];
    [self createLocationManager];
    [self.manager requestWhenInUseAuthorization];
    
    [self checkForLocationServices];
}


#pragma mark - Service Check Methods

- (void)checkForLocationServices {
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        NSLog(@"Location services are enabled");
        self.locationAuthorization = YES;
        
        [self checkForInternetServices];
        
    }
    
    else {
        
        self.locationAuthorization = NO;
        [self locationServicesUnavailableAlert];
    }
}

- (void)checkForInternetServices {
    
    Reachability *networkReachability =
    [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        //[self hideActivityIndicator];
        [self setDownloadShimmer:NO];
        UIAlertView *noInternetConnection = [[UIAlertView alloc]
                                             initWithTitle:@"No Internet Connection"
                                             message:@"Please check your network connection and try again"
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
        [noInternetConnection show];
        
    } else {
        
        [self setDownloadShimmer:YES];
        [self.manager startUpdatingLocation];
    }
}

- (void)locationServicesUnavailableAlert {
    
    UIAlertView *noLocationServices = [[UIAlertView alloc]
                                       initWithTitle:@"Oops"
                                       message:@"We weren't able to figure out your location, check "
                                       @"to make sure that location services are enabled and "
                                       @"try again"
                                       delegate:nil
                                       cancelButtonTitle:@"Ok"
                                       otherButtonTitles:nil];
    [noLocationServices show];
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)createLocationManager {
    
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.distanceFilter = 200;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
    //[self hideActivityIndicator];
    [self setDownloadShimmer:NO];
    self.manager = nil;
    [self locationServicesUnavailableAlert];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self.manager stopUpdatingLocation];
    self.manager = nil;
    
    self.currentLocation = locations[0];
    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n",self.currentLocation.coordinate.latitude,self.currentLocation.coordinate.longitude);
    
    [self setDownloadShimmer:YES];
    [self.APIRequestsClass sunlightFoundationRequest:self.currentLocation.coordinate.latitude coordinates:self.currentLocation.coordinate.longitude];
    
    [self.APIRequestsClass googleCivRequest:self.currentLocation.coordinate.latitude coordinates:self.currentLocation.coordinate.longitude];
}

#pragma mark - UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.APIRequestsClass.sfCongressmen.count == 1) {
        return 1;
    } else {
        return 3;
    }
}

- (void)reloadTableView:(NSNotification *)notification {
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Create cell
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = (CustomTableViewCell *)
    [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // load cell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell"
                                                     owner:self
                                                   options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Check if the search text was ambiguous
    if (self.APIRequestsClass.sfCongressmen.count == 2 && indexPath.row == 2) {
        
        static NSString *simpleTableIdentifier = @"MissingRepCell";
        CustomTableViewCell *cell = (CustomTableViewCell *)
        [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MissingRepCell"
                                                         owner:self
                                                       options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.tableView.alpha = 1.0;
                         }];
        //[self hideActivityIndicator];
        [self setDownloadShimmer:NO];
        return cell;
        
    } else {
        
        cell.congressman =
        [self.APIRequestsClass.sfCongressmen objectAtIndex:indexPath.row];
        
        // This checks if app is starting up or nah
        if (cell.congressman == nil) {
            
            self.tableView.alpha = 0.0;
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cell.name.text = [NSString
                                  stringWithFormat:@"%@. %@ %@", cell.congressman.officeTitle,
                                  cell.congressman.firstName,
                                  cell.congressman.lastName];
                cell.name.textColor = [UIColor colorWithRed:(100.0 / 255.0)
                                                      green:(100.0 / 255.0)
                                                       blue:(100.0 / 255.0)
                                                      alpha:1.0];
                
                cell.name.marqueeType = MLContinuous;
                cell.name.rate = 15.0f;
                cell.name.fadeLength = 10.0f;
                // cell.name.leadingBuffer = 1.0f;
                // cell.name.trailingBuffer = 1.0f;
                cell.name.textAlignment = NSTextAlignmentLeft;
                cell.name.tag = 102;
                
                cell.detail.text = [NSString stringWithFormat:@"(%@) Next Election: %@",
                                    cell.congressman.party,
                                    cell.congressman.termEnd];
                cell.detail.textColor = [UIColor colorWithRed:(130.0 / 255.0)
                                                        green:(130.0 / 255.0)
                                                         blue:(130.0 / 255.0)
                                                        alpha:1.0];
                
                cell.photoView.image = cell.congressman.photo;
                
                [cell.tweetButton setTitle:@"Twitter" forState:UIControlStateNormal];
                [cell.facebookButton setTitle:@"Facebook"
                                     forState:UIControlStateNormal];
                [cell.callButton setTitle:@"Call" forState:UIControlStateNormal];
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     self.tableView.alpha = 1.0;
                                 }];
            });
            
            //[self hideActivityIndicator];
            [self setDownloadShimmer:NO];
            return cell;
        }
        // this is getting called 3 times at startup
        //[self hideActivityIndicator];
        [self setDownloadShimmer:NO];
        return cell;
    }
}
@end
