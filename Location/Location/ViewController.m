//
//  ViewController.m
//  Location with google
//


#import "ViewController.h"




@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    self.navigationBar.hidden = YES;
    self.tableView.hidden = YES;
    
    self.manager = [[CLLocationManager alloc] init];
    
    
    
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self createVoicesLabel];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [self.tableView reloadData];
}

- (void)createVoicesLabel{
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir-Light" size:70]];
    
    shimmeringView.contentView = self.voicesLabel;
    shimmeringView.shimmering = YES;
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonPressed:(id)sender{
    
    [self.manager requestWhenInUseAuthorization];
    
    [self checkForInternetAndLocationServices];
    
}

- (void)checkForInternetAndLocationServices{
    
    // Check for location services
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        self.manager.delegate = self;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self.manager startUpdatingLocation];
    }
    
    else{
        
        [self locationServicesUnavailable];
    }
    
    // Check for internet connection
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        UIAlertView *noInternetConnection = [[UIAlertView alloc]initWithTitle:@"No Internet Connection" message:@"Please check your network connection and try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [noInternetConnection show];
        
    }
    
    if(self.progressView.progress == 0){
        
        [self.progressView setProgress:0 animated:YES];
    }
    else{
        [self.progressView setProgress:0 animated:NO];
    }
    
    
}

- (void)locationServicesUnavailable{
    
    UIAlertView *noLocationServices = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"We weren't able to figure out your location, check to make sure that location services are enabled and try again"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [noLocationServices show];
    
}

#pragma mark - UITableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    // Assign data to cells
    cell.congressman = [self.listOfMembers objectAtIndex:indexPath.row];
    
    
    if (cell.congressman == nil) {
        
        self.tableView.hidden = YES;
        
    }
    else{
        
        
        cell.name.text = [NSString stringWithFormat:@"%@. %@ %@" , cell.congressman.officeTitle, cell.congressman.firstName, cell.congressman.lastName];
        cell.detail.text = [NSString stringWithFormat:@"(%@) - Term Ends: %@", cell.congressman.party, cell.congressman.termEnd];
        
        cell.photoView.image = cell.congressman.photo;
        
        
        [cell.tweetButton setTitle:@"Twitter" forState:UIControlStateNormal];
        [cell.facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
        
        NSLog(@"Assigned data to cell #%ld", (long)indexPath.row);
        
        self.tableView.hidden = NO;
        
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Assign phone numbers to cells
    NSString *phone = [(Congressman*)[self.listOfMembers objectAtIndex:indexPath.row]phone];
    if(phone != nil) {
        NSString *phoneNumber= [@"tel://" stringByAppendingString:phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        NSLog(@"Dialed %@",phoneNumber);
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

// This is a callback method of the PassTwitterObjectProtocol
- (void)passTwitterObject:(UIViewController*)controller{
    
    [self presentViewController:controller animated:YES completion:nil];
    NSLog(@"Presented twitter view controller");
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
    [self locationServicesUnavailable];
    
}

//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
//
//    [self.manager stopUpdatingLocation];
//
//    CLLocation *currentLocation = newLocation;
//    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
//
//    [self sunlightFoundationRequest:currentLocation.coordinate.latitude coordinates:currentLocation.coordinate.longitude];
//
//    [self googleRequest:(CLLocation*)currentLocation];
//
//}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    [self.manager stopUpdatingLocation];
    
    CLLocation *currentLocation = locations[0];
    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [self sunlightFoundationRequest:currentLocation.coordinate.latitude coordinates:currentLocation.coordinate.longitude];
    
    [self googleRequest:(CLLocation*)currentLocation];
    
}


- (void)googleRequest:(CLLocation*)currentLocation{
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        self.placemark = [placemarks lastObject];
        
        NSString * address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.placemark.subThoroughfare, self.placemark.thoroughfare, self.placemark.postalCode, self.placemark.administrativeArea, self.placemark.country];
        NSString *formattedAddress = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/civicinfo/v2/representatives?address=%@&key=AIzaSyAFmuzxmKaPRHW6DTh3ZEfUySugM_Jj7_s", formattedAddress]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/civicinfo/v2/representatives?address=%@&includeOffices=true&levels=country&roles=legislatorLowerBody&roles=legislatorUpperBody&key=AIzaSyAFmuzxmKaPRHW6DTh3ZEfUySugM_Jj7_s", formattedAddress ]];
        NSLog(@"%@",url);
        
        
        NSMutableURLRequest *googleGetRequest = [NSMutableURLRequest requestWithURL:url];
        googleGetRequest.HTTPMethod = @"GET";
        self.googleConn = [[NSURLConnection alloc] initWithRequest:googleGetRequest delegate:self];
        
    }];
}




#pragma mark - Sunlight Foundation method

- (void)sunlightFoundationRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude{
    
    // Create the request
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://congress.api.sunlightfoundation.com/legislators/locate?latitude=%.8f&longitude=%.8f&apikey=6c15da72f7f04c91bad04c89c178e01e", latitude, longitude]];
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    
    // Specify that the request will be a GET
    getRequest.HTTPMethod = @"GET";
    
    // Set the header fields
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    // Create URL connection and fire request
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    conn = nil;
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    self.totalFileSize = response.expectedContentLength;
    
    if(connection == self.googleConn){
        
        self.googleResponseData = [[NSMutableData alloc]init];
    }
    else{
        
        _responseData = [[NSMutableData alloc] init];
        
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    if (connection == self.googleConn) {
        self.receivedDataBytes += [data length];
        
        [self.progressView setProgress:0 animated:NO];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Animate on the next run loop so the animation starts from 0.
            [self.progressView setProgress:0.1 animated:YES];
            self.progressView.progress = self.receivedDataBytes/ (float)self.totalFileSize;
            
        });
    }

    
    if(connection == self.googleConn){
        
        [self.googleResponseData appendData:data];
        
    }
    else{
        
        [_responseData appendData:data];
    }
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    if (connection == self.googleConn) {
        
        self.googCongressmen = [[NSMutableArray alloc]init];

        // Decode the json data
        NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.googleResponseData options:0 error:nil];
        
        // Extract only the officials from the dict
        NSMutableArray *officials = [decodedData valueForKey:@"officials"];
        
        // Iterate through the officials
        for (int i = 0; i < officials.count; i++) {
            
            // Extract the phone number for each official
            NSMutableArray *phones = [officials[i] valueForKey:@"phones"];
            
            // Create a new congressman object for each official
            Congressman * googDude = [[Congressman alloc]init];
            
            // Clean the phone number and assign it to the congressman
            googDude.phone = [self cleanPhoneNumber:phones[0]];
            
            // Iterate through each of the channels in congressman
            for (int j = 0; j < [[officials[i] valueForKey:@"channels"] count]; j++) {
                
                // We only want the twitter values
                if ([[[officials[i] valueForKey:@"channels"][j] valueForKey:@"type"] isEqualToString:@"Twitter"]) {
                    
                    // Assign the twitter handle
                    googDude.twitterID = [[officials[i] valueForKey:@"channels"][j] valueForKey:@"id"];
                    
                    // Repeat for facebook
                } else if ([[[officials[i] valueForKey:@"channels"][j] valueForKey:@"type"] isEqualToString:@"Facebook"]) {
                    googDude.facebookID = [[officials[i] valueForKey:@"channels"][j] valueForKey:@"id"];
                }
                
                // Add to array
                [self.googCongressmen addObject:googDude];
            }
        }
        
        // Match googCongressmen to sfCongressman
        [self matchData];
        
 
    }
    else{
        
        self.listOfMembers = [[NSMutableArray alloc]init];
        
        // Stop updating location bc we only need it once
        [self.manager stopUpdatingLocation];
        
        // Decode data
        NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
        NSMutableDictionary *results = [decodedData valueForKey:@"results"];

        
        for(int i = 0; i < [results count]; i++){
            
            Congressman *sfDude = [[Congressman alloc]init];
            sfDude.bioGuide = [results valueForKey:@"bioguide_id"][i];
            [self downloadPhotos:sfDude.bioGuide congressman:sfDude];
            sfDude.firstName = [results valueForKey:@"first_name"][i];
            sfDude.lastName = [results valueForKey:@"last_name"][i];
            sfDude.party = [results valueForKey:@"party"][i];
            sfDude.termEnd = [results valueForKey:@"term_end"][i];
            [self formatTermDates:sfDude.termEnd congressman:sfDude];
            sfDude.officeTitle = [results valueForKey:@"title"][i];
            sfDude.twitterID = [results valueForKey:@"twitter_id"][i];
            sfDude.facebookID = [results valueForKey:@"facebook_id"][i];
            sfDude.phone = [results valueForKey:@"phone"][i];
            sfDude.phone = [sfDude.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];

            
            [self.listOfMembers addObject:sfDude];
            
        }
    }
}

- (void)matchData{
    
    
    for (int i=0; i < [self.listOfMembers count]; i++){
        for(int j = 0; j < [self.googCongressmen count]; j++){
            
            if([[self.listOfMembers[i] phone] isEqualToString:[self.googCongressmen[j] phone]] ){
                [self.listOfMembers[i] setTwitterID:[self.googCongressmen[j] twitterID]];
                [self.listOfMembers[i] setFacebookID:[self.googCongressmen[j] facebookID]];
                
            }
        }
    }
}


- (NSString*)cleanPhoneNumber:(NSString*)phoneNumber{
    
    // Strip the google phone numbers
    
    NSString *cleanedPhoneNumber = [[NSString alloc]init];
    
    cleanedPhoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-"
                                                                withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@"("
                                                                       withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@")"
                                                                       withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@" "
                                                                       withString:@""];
    
    return cleanedPhoneNumber;
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

- (void)formatTermDates:(NSString*)termDate congressman:(Congressman*)congressman{
    
    congressman.termEnd = [[NSString alloc]init];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * dateNotFormatted = [dateFormatter dateFromString:termDate];
    [dateFormatter setDateFormat:@"d MMM YYYY"];
    NSString * termDateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
    congressman.termEnd =  termDateFormatted;
    
}


- (void)downloadPhotos:(NSString*)bioGuide congressman:(Congressman*)congressman{
    
    congressman.photo = [[UIImage alloc]init];
    
    NSString *urlWithBioGuide = [NSString stringWithFormat:@"http://theunitedstates.io/images/congress/450x550/%@.jpg", bioGuide];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlWithBioGuide]];
        
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            UIImage *image = [UIImage imageWithData:data];
            congressman.photo = image;
            NSLog(@"Assigned photo to congressman");
            [self.tableView reloadData];
        });
    });
}

@end
