#import "ViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.tableView.hidden = YES;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.aboutLabel.textColor = [UIColor colorWithRed:(130.0/255.0) green:(130.0/255.0) blue:(130.0/255.0) alpha:1];
    [self createVoicesLabel];
    [self createSearchBar];
    

    self.searchButton.imageEdgeInsets = UIEdgeInsetsMake(self.searchButton.frame.size.height - 35, self.searchButton.frame.size.width - 35, 12, 12);


        
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];

    self.APIRequestsClass = [[APIRequests alloc]init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"ReloadTableViewNotification" object:nil];
    

    
    NSString *scriptString = @"Hello, my name is [your name] and I would like the Congressman to [support/oppose] [something that you care about] and I will be voting this November";
    
    UIFont *font = [UIFont fontWithName:@"Avenir" size:16.0];
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
    NSMutableAttributedString *scriptAttributedString = [[NSMutableAttributedString alloc] initWithString:scriptString attributes:attrsDictionary];
    
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(18,11)];
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(66,48)];
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(18,11)];
    
    

    
    [self.scriptTextView setAttributedText:scriptAttributedString];
    self.scriptTextView.textAlignment = 1.0;

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void) dismissKeyboard
{
    [self.searchBar resignFirstResponder];
}

- (void)createVoicesLabel
{
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-8);
    verticalMotionEffect.maximumRelativeValue = @(8);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-8);
    horizontalMotionEffect.maximumRelativeValue = @(8);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    [self.tableView addMotionEffect:group];
    [self.voicesLabel addMotionEffect:group];
    [self.whoRepsButton addMotionEffect:group];
    [self.searchButton addMotionEffect:group];
    [self.searchBar addMotionEffect:group];
    [self.blueView addMotionEffect:group];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir" size:60]];
    self.voicesLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1.0];
    
    
    shimmeringView.contentView = self.voicesLabel;
    shimmeringView.shimmering = YES;
    
    
}

#pragma mark - UISearchBar methods

-(void)createSearchBar{
    
    self.blueView.layer.cornerRadius = 5;
    self.blueView.backgroundColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1.0];
    
    
    self.searchBar.alpha = 0.0;
    self.searchBar.userInteractionEnabled = NO;
    self.searchBar.delegate = self;
    
    // Set cancel button to white color
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil]forState:UIControlStateNormal];
    
    // Set placeholder text to white
    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[UIColor whiteColor]];
    
    // Set the input text font
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Avenir" size:15],}];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (IBAction)searchButtonPressed:(id)sender {
    
    [self createLocationManager];
    [self.manager requestWhenInUseAuthorization];
    [self.searchBar becomeFirstResponder];
    self.whoRepsButton.enabled = NO;
    self.searchButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{self.whoRepsButton.alpha = 0.0;} completion:^(BOOL finished) {
        self.searchBar.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.2 animations:^{self.searchBar.alpha = 1.0;}];
        
    }];

}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"Cancel button pressed");
    self.searchBar.text = nil;
    [self.APIRequestsClass.googleMapsConnection cancel];
    [self.APIRequestsClass.sfConnection cancel];
    [self.APIRequestsClass.googleCivConnection cancel];
    [self.APIRequestsClass.photoConnection cancel];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    self.whoRepsButton.enabled = YES;
    [UIView animateWithDuration:.2 animations:^{self.searchBar.alpha = 0.0;} completion:^(BOOL finished) {
        self.searchBar.userInteractionEnabled = NO;
        [UIView animateWithDuration:.2 animations:^{self.whoRepsButton.alpha = 1.0;}];
        self.searchButton.hidden = NO;
   
    }];
}


#pragma mark - Execute Request Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if(self.searchBar.text.length > 0) {
        
        //check for internet
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            UIAlertView *noInternetConnection = [[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Please check your network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [noInternetConnection show];
            
        }
        else{
            
            [self.searchBar resignFirstResponder];
            [self.APIRequestsClass googleMapsRequest:self.searchBar.text];

        }
 
    }
}


- (IBAction)whoRepsButtonPressed:(id)sender
{
    NSLog(@"Button Pressed");
    
    [self createLocationManager];
    [self.manager requestWhenInUseAuthorization];
    
    [self checkForLocationServices];
}







#pragma mark - Service Check Methods

- (void)checkForLocationServices
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are enabled");

        [self checkForInternetServices];

    }
    
    else{
        
        [self locationServicesUnavailableAlert];
    }
}


-(void)checkForInternetServices
{
    
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *noInternetConnection = [[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Please check your network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noInternetConnection show];
        
    }
    else{
        
        [self.manager startUpdatingLocation];
        
    }
    
    
}

- (void)locationServicesUnavailableAlert
{
    
    UIAlertView *noLocationServices = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"We weren't able to figure out your location, check to make sure that location services are enabled and try again"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [noLocationServices show];
    
}


#pragma mark - CLLocationManagerDelegate Methods



- (void)createLocationManager{
    
    self.manager = [[CLLocationManager alloc] init];
    self.manager.delegate = self;
    self.manager.distanceFilter = 200;
    self.manager.desiredAccuracy = kCLLocationAccuracyBest;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
    //[self locationServicesUnavailable];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.manager stopUpdatingLocation];
    self.manager = nil;
    
    self.currentLocation = locations[0];
    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    
    [self.APIRequestsClass sunlightFoundationRequest:self.currentLocation.coordinate.latitude coordinates:self.currentLocation.coordinate.longitude];
    
    [self.APIRequestsClass googleCivRequest:self.currentLocation.coordinate.latitude coordinates:self.currentLocation.coordinate.longitude];
    
}



#pragma mark - UITableView Methods

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.APIRequestsClass.sfCongressmen count];
}

- (void)reloadTableView:(NSNotification*)notification
{
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.congressman = [self.APIRequestsClass.sfCongressmen objectAtIndex:indexPath.row];
    
    
    if (cell.congressman == nil) {
        
        self.tableView.hidden = YES;
        
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.name.text = [NSString stringWithFormat:@"%@. %@ %@" , cell.congressman.officeTitle, cell.congressman.firstName, cell.congressman.lastName];
            cell.name.textColor = [UIColor colorWithRed:(100.0/255.0) green:(100.0/255.0) blue:(100.0/255.0) alpha:1.0];
            
            cell.name.marqueeType = MLLeftRight;
            cell.name.rate = 15.0f;
            cell.name.fadeLength = 10.0f;
            //cell.name.leadingBuffer = 1.0f;
            //cell.name.trailingBuffer = 1.0f;
            cell.name.textAlignment = NSTextAlignmentLeft;
            cell.name.tag = 102;
            
            cell.detail.text = [NSString stringWithFormat:@"(%@) Next Election: %@", cell.congressman.party, cell.congressman.termEnd];
            cell.detail.textColor = [UIColor colorWithRed:(130.0/255.0) green:(130.0/255.0) blue:(130.0/255.0) alpha:1.0];
            
            cell.photoView.image = cell.congressman.photo;
            
            
            [cell.tweetButton setTitle:@"Twitter" forState:UIControlStateNormal];
            [cell.facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
            [cell.callButton setTitle:@"Call" forState:UIControlStateNormal];
            
            
            
            self.tableView.hidden = NO;
            
        });
    }
    return cell;
}

@end
