#import "ViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        // app already launched
        NSLog(@"app has launched previously");
        self.orangeView.hidden = YES;
        self.searchByLocationLabel.hidden = YES;
        self.searchByLabel.hidden = YES;
        self.moreInfoLabel.hidden = YES;
        self.bar1Label.hidden = YES;
        self.bar2Label.hidden = YES;
        self.bar3Label.hidden = YES;
        self.getStartedButton.hidden = YES;
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"first time launching app");
        
        
        
    }
    
    
    
    
    
    
    
    self.APIRequestsClass = [[APIRequests alloc]init];
    self.APIRequestsClass.viewController = self;
    
    
    
    self.tableView.alpha = 0.0;
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.aboutLabel.textColor = [UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0];
    [self createVoicesLabel];
    [self createSearchBar];
    [self createAttributedStrings];
    [self createButtonSeparator];
    
    
    self.searchButton.imageEdgeInsets = UIEdgeInsetsMake(self.searchButton.frame.size.height - 35, self.searchButton.frame.size.width - 35, 12, 12);
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableView:) name:@"ReloadTableViewNotification" object:nil];
    
}

- (void)createAttributedStrings
{
    // About page 1 - "voices is"
    self.pageHeaderOne.textColor = [UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0];
    self.voicesIsTextView.textColor = [UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0];
    
    
    // About page 2 - "sopa"
    self.pageHeaderTwo.textColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1];
    
    UIFont *avenirFont = [UIFont fontWithName:@"Avenir" size:16.0];
    
    NSMutableAttributedString *sopaString = [[NSMutableAttributedString alloc]initWithString:@"On a single day in 2012, more than 14 million people called their Congressmen to protect the internet. Learn more here"];
    [sopaString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:18.0] range:NSMakeRange(0, [sopaString length])];
    [sopaString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(114, 4)];
    [sopaString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0] range:NSMakeRange(0,114)];
    [sopaString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1.0] range:NSMakeRange(114, 4)];
    [sopaString addAttribute:NSUnderlineColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(114, 4)];
    [sopaString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(114, 4)];
    
    
    [self.sopaTextView setAttributedText:sopaString];
    self.sopaTextView.textAlignment = 1.0;
    

    
    // About page 3 - "script"
    self.pageHeaderThree.textColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1];
    self.itsEasyTextView.textColor = [UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0];
    
    NSString *scriptString = @"Hello, my name is [your name] and I would like the Congressman to [support/oppose] [something that you care about] and I will be voting in November";
    
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:avenirFont forKey:NSFontAttributeName];
    NSMutableAttributedString *scriptAttributedString = [[NSMutableAttributedString alloc] initWithString:scriptString attributes:attrsDictionary];

    
    //grey
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0] range:NSMakeRange(0,scriptAttributedString.length)];
    
    // orange
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(18,11)];
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(65,49)];
    
    //font
    [scriptAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:19.0] range:NSMakeRange(0, 100)];
    
    
    [self.scriptTextView setAttributedText:scriptAttributedString];
    self.scriptTextView.textAlignment = 1.0;

}



- (IBAction)hereLinkPressed:(id)sender
{
    NSLayoutManager *layoutManager = self.sopaTextView.layoutManager;
    CGPoint location = [sender locationInView:self.sopaTextView];
    location.x -= self.sopaTextView.textContainerInset.left;
    location.y -= self.sopaTextView.textContainerInset.top;
    
    NSUInteger characterIndex;
    characterIndex = [layoutManager characterIndexForPoint:location
                                           inTextContainer:self.sopaTextView.textContainer
                  fractionOfDistanceBetweenInsertionPoints:NULL];
    
    if (characterIndex > 114) {
        
        NSRange range;
        id value = [self.sopaTextView.attributedText attribute:@"myCustomTag" atIndex:characterIndex effectiveRange:&range];
        
        NSLog(@"%@, %lu, %lu", value, (unsigned long)range.location, (unsigned long)range.length);
    
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [self.view.window.rootViewController presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"webViewController"] animated:YES completion:nil];
        //[self dismissViewControllerAnimated:YES completion:nil];
        
    }
   
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

- (UIMotionEffectGroup*) createMotionEffect {
    
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-7);
    verticalMotionEffect.maximumRelativeValue = @(7);
    
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-7);
    horizontalMotionEffect.maximumRelativeValue = @(7);
    
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    return group;
    
}

- (void)createVoicesLabel
{
    UIMotionEffectGroup *motionEffect = [self createMotionEffect];
    
    [self.tableView addMotionEffect:motionEffect];
    [self.voicesLabel addMotionEffect:motionEffect];
    [self.whoRepsButton addMotionEffect:motionEffect];
    [self.searchButton addMotionEffect:motionEffect];
    [self.searchBar addMotionEffect:motionEffect];
    [self.blueView addMotionEffect:motionEffect];
    [self.aboutLabel addMotionEffect:motionEffect];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir" size:80
                               ]];
    self.voicesLabel.textColor = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1.0];
    
    
    shimmeringView.contentView = self.voicesLabel;
    shimmeringView.shimmering = YES;
    
    
}

- (void) createButtonSeparator {
    self.buttonSeparator = [[UIView alloc] initWithFrame:CGRectMake(247, 57, 1, 24)];
    self.buttonSeparator.backgroundColor = [UIColor colorWithRed:133 green:133. blue:133 alpha:.5];
    
    [self.buttonSeparator addMotionEffect:[self createMotionEffect]];
    [self.view addSubview:self.buttonSeparator];
    
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
    
    self.buttonSeparator.hidden = YES;
    
    [self createLocationManager];
    [self.manager requestWhenInUseAuthorization];
    [self.searchBar becomeFirstResponder];
    self.whoRepsButton.enabled = NO;
    self.searchButton.hidden = YES;
    [UIView animateWithDuration:0.2 animations:^{self.whoRepsButton.alpha = 0.0;} completion:^(BOOL finished) {
        self.searchBar.userInteractionEnabled = YES;
        [UIView animateWithDuration:0.2 animations:^{self.searchBar.alpha = 1.0;}];
        [UIView animateWithDuration:0.2 animations:^{self.buttonSeparator.alpha = 0.0;}];
        
    }];
}

- (IBAction)getStartedButtonPressed:(id)sender {
    
    [UIView animateWithDuration:0.5
                     animations:^{
    
    self.orangeView.alpha = 0;
    self.searchByLocationLabel.alpha = 0;
    self.searchByLabel.alpha = 0;
    self.moreInfoLabel.alpha = 0;
    self.bar1Label.alpha = 0;
    self.bar2Label.alpha = 0;
    self.bar3Label.alpha = 0;
    self.getStartedButton.alpha = 0;
                         
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
    [self hideActivityIndicator];
    self.buttonSeparator.hidden = NO;
    self.whoRepsButton.enabled = YES;
    [UIView animateWithDuration:.2 animations:^{self.searchBar.alpha = 0.0;} completion:^(BOOL finished) {
        self.searchBar.userInteractionEnabled = NO;
        [UIView animateWithDuration:.2 animations:^{self.whoRepsButton.alpha = 1.0;}];
        self.searchButton.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{self.buttonSeparator.alpha = 1.0;}];
        
    }];
}


#pragma mark - Execute Request Methods

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    [self showActivityInidcator];
    if(self.searchBar.text.length > 0) {
        
        //check for internet
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            [self hideActivityIndicator];
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
    [self showActivityInidcator];
    [self createLocationManager];
    [self.manager requestWhenInUseAuthorization];
    
    [self checkForLocationServices];
}

#pragma mark - Activity Indicator

- (void) showActivityInidcator {
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.color = [UIColor colorWithRed:(255.0/255.0) green:(128.0/255.0) blue:(5.0/255.0) alpha:1.0];
    self.activityIndicator.center = CGPointMake(160.0, 110.0);
    self.activityIndicator.hidesWhenStopped = YES;
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
    NSLog(@"%@", self.activityIndicator);
}

- (void) hideActivityIndicator {
    [self.activityIndicator stopAnimating];

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
        [self hideActivityIndicator];
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
    [self hideActivityIndicator];
    self.manager = nil;
    [self locationServicesUnavailableAlert];
    
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
  
    if (self.APIRequestsClass.sfCongressmen.count == 1) {
        return 1;
    }
    else{
        return 3;
    }
}

- (void)reloadTableView:(NSNotification*)notification
{
    [self.tableView reloadData];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    // Create cell
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    // load cell
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    // Check if the search text was ambiguous
    if (self.APIRequestsClass.sfCongressmen.count == 2 && indexPath.row == 2){
        
        
        static NSString *simpleTableIdentifier = @"MissingRepCell";
        CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MissingRepCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        [UIView animateWithDuration:0.2
                         animations:^{
                             self.tableView.alpha = 1.0;
                         }];
        //[self hideActivityIndicator];
        return cell;
        
    }
    else{
        
        
        cell.congressman = [self.APIRequestsClass.sfCongressmen objectAtIndex:indexPath.row];
        
        // This checks if app is starting up or nah
        if (cell.congressman == nil) {
            
            
            self.tableView.alpha = 0.0;
            
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
                
                
                [UIView animateWithDuration:0.2
                                 animations:^{
                                     self.tableView.alpha = 1.0;
                                 }];
            });
        }
        
        [self hideActivityIndicator];
        return cell;
    }
}
@end
