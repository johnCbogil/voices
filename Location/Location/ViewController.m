#import "ViewController.h"


@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];

    
    self.tableView.hidden = YES;
    
    self.manager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    [self createVoicesLabel];
    
    self.buttonLabel.layer.cornerRadius = 5;

    self.photoRequestCounter = 0;

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
    [self.buttonLabel addMotionEffect:group];
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir" size:70]];
    
    
    shimmeringView.contentView = self.voicesLabel;
    shimmeringView.shimmering = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonPressed:(id)sender
{
    NSLog(@"Button Pressed");

    [self.manager requestWhenInUseAuthorization];
    
    [self checkForLocationServices];
    
}



- (void)checkForLocationServices
{
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        NSLog(@"Location services are enabled");
        self.manager.delegate = self;
        self.manager.distanceFilter = 200;
        self.manager.desiredAccuracy = kCLLocationAccuracyBest;
        [self checkForInternetServices];

    }
    
    else{
        
        [self locationServicesUnavailable];
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

- (void)locationServicesUnavailable
{
    
    UIAlertView *noLocationServices = [[UIAlertView alloc]initWithTitle:@"Oops" message:@"We weren't able to figure out your location, check to make sure that location services are enabled and try again"delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [noLocationServices show];
    
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
    
    return [self.sfCongressmen count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"CustomCell";
    CustomTableViewCell *cell = (CustomTableViewCell*)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    cell.congressman = [self.sfCongressmen objectAtIndex:indexPath.row];
    
    
    if (cell.congressman == nil) {
        
        self.tableView.hidden = YES;
        
    }
    else{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.name.text = [NSString stringWithFormat:@"%@. %@ %@" , cell.congressman.officeTitle, cell.congressman.firstName, cell.congressman.lastName];
            cell.detail.text = [NSString stringWithFormat:@"(%@) - Term Ends: %@", cell.congressman.party, cell.congressman.termEnd];
            
            cell.photoView.image = cell.congressman.photo;
            
            
            [cell.tweetButton setTitle:@"Twitter" forState:UIControlStateNormal];
            [cell.facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
            [cell.callButton setTitle:@"Call" forState:UIControlStateNormal];
            
            
            
            self.tableView.hidden = NO;
            
        });
        
    }
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}



#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
    [self locationServicesUnavailable];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [self.manager stopUpdatingLocation];
    
    self.currentLocation = locations[0];
    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    
    NSLog(@"Firing SF Request");
    [self sunlightFoundationRequest:self.currentLocation.coordinate.latitude coordinates:self.currentLocation.coordinate.longitude];
    
    NSLog(@"Firing Google Request");
    [self googleRequest:(CLLocation*)self.currentLocation];

    
}

#pragma mark - API Requests

- (void)sunlightFoundationRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude
{
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://congress.api.sunlightfoundation.com/legislators/locate?latitude=%.8f&longitude=%.8f&apikey=6c15da72f7f04c91bad04c89c178e01e", latitude, longitude]];
    NSLog(@"SF URL: %@", url);
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    
    getRequest.HTTPMethod = @"GET";
    
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    self.sfConnection = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
}

- (void)googleRequest:(CLLocation*)currentLocation
{
    
    [self.geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        self.placemark = [placemarks lastObject];
        
        NSString * address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.placemark.subThoroughfare, self.placemark.thoroughfare, self.placemark.postalCode, self.placemark.administrativeArea, self.placemark.country];
        NSString *formattedAddress = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/civicinfo/v2/representatives?address=%@&includeOffices=true&levels=country&roles=legislatorLowerBody&roles=legislatorUpperBody&key=AIzaSyAFmuzxmKaPRHW6DTh3ZEfUySugM_Jj7_s", formattedAddress ]];
        NSLog(@"Google URL: %@", url);
        
        NSMutableURLRequest *googleGetRequest = [NSMutableURLRequest requestWithURL:url];
        googleGetRequest.HTTPMethod = @"GET";
        self.googleConn = [[NSURLConnection alloc] initWithRequest:googleGetRequest delegate:self];
        
    }];
}




- (void)photoRequest:(NSString*)bioGuide
{
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://theunitedstates.io/images/congress/450x550/%@.jpg", bioGuide]];
    NSLog(@"PhotoRequest URL: %@", url);
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    
    getRequest.HTTPMethod = @"GET";
    
    [getRequest setValue:@"image/jpg" forHTTPHeaderField:@"Accept"];
    
    self.photoConnection = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    
    
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(connection == self.googleConn){
        self.totalFileSize = response.expectedContentLength;
        
        self.googleResponseData = [[NSMutableData alloc]init];
    }
    else if(connection == self.sfConnection){
        
        self.sfResponseData = [[NSMutableData alloc] init];
        
    }
    
    else if (connection == self.photoConnection){
        
        self.photoResponseData = [[NSMutableData alloc]init];
        
    }
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{

    if(connection == self.googleConn){
        
        [self.googleResponseData appendData:data];
        
    }
    else if(connection == self.sfConnection){
        
        [self.sfResponseData appendData:data];
    }
    
    else if(connection == self.photoConnection){

        [self.photoResponseData appendData:data];
    }
    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (connection == self.sfConnection){
        
        self.sfCongressmen = [[NSMutableArray alloc]init];
        
        [self.manager stopUpdatingLocation];
        
        NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.sfResponseData options:0 error:nil];
        NSMutableDictionary *results = [decodedData valueForKey:@"results"];
        
        
        self.congressmenPhotos = [[NSMutableArray alloc]init];
        self.bioGuides = [[NSMutableArray alloc]init];
        
        
        for(int i = 0; i < [results count]; i++){
            
            self.sfDude = [[Congressman alloc]init];
            self.sfDude.firstName = [results valueForKey:@"first_name"][i];
            self.sfDude.lastName = [results valueForKey:@"last_name"][i];
            self.sfDude.bioGuide = [results valueForKey:@"bioguide_id"][i];
            [self.bioGuides addObject:self.sfDude.bioGuide];
            self.sfDude.party = [results valueForKey:@"party"][i];
            self.sfDude.termEnd = [results valueForKey:@"term_end"][i];
            [self formatTermDates:self.sfDude.termEnd congressman:self.sfDude];
            self.sfDude.officeTitle = [results valueForKey:@"title"][i];
            self.sfDude.twitterID = [results valueForKey:@"twitter_id"][i];
            self.sfDude.facebookID = [results valueForKey:@"facebook_id"][i];
            self.sfDude.phone = [results valueForKey:@"phone"][i];
            self.sfDude.phone = [self.sfDude.phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            
            [self.sfCongressmen addObject:self.sfDude];
            
        }
        
        NSLog(@"Firing first photo request");
        [self photoRequest:self.bioGuides[0]];
        
        
    }

    else if (connection == self.googleConn) {
        
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
                }
                
                // Repeat for facebook
                else if ([[[officials[i] valueForKey:@"channels"][j] valueForKey:@"type"] isEqualToString:@"Facebook"]) {
                    googDude.facebookID = [[officials[i] valueForKey:@"channels"][j] valueForKey:@"id"];
                }
                
                // Add to array
                [self.googCongressmen addObject:googDude];
            }
        }
        
        // Match googCongressmen to sfCongressman
        [self matchData];
        
        
    }
         else if (connection == self.photoConnection){
        
        self.photoRequestCounter++;
        NSLog(@"PhotoRequestCounter is: %d", self.photoRequestCounter);
             
        
        [self.congressmenPhotos addObject:[UIImage imageWithData:self.photoResponseData]];
        
        if (self.photoRequestCounter == 1) {
            
            [[self.sfCongressmen objectAtIndex:0]setPhoto:self.congressmenPhotos[0]];
            
            if([self.sfCongressmen count] > 1){
                
                NSLog(@"Firing second photo request");
                [self photoRequest:self.bioGuides[1]];
            }
            else
            {
                self.photoRequestCounter = 0;
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            }
        }
        else if (self.photoRequestCounter == 2){
            
            [[self.sfCongressmen objectAtIndex:1]setPhoto:self.congressmenPhotos[1]];
            
            NSLog(@"Firing third photo request");
            [self photoRequest:self.bioGuides[2]];
            
        }
        
        if([self.sfCongressmen count] == 3 && [self.congressmenPhotos count] == 3){
            
            [[self.sfCongressmen objectAtIndex:2]setPhoto:self.congressmenPhotos[2]];
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            self.photoRequestCounter = 0;
            
        }
    }
    [self.tableView reloadData];
}

- (void)matchData
{
    
    
    for (int i=0; i < [self.sfCongressmen count]; i++){
        for(int j = 0; j < [self.googCongressmen count]; j++){
            
            if([[self.sfCongressmen[i] phone] isEqualToString:[self.googCongressmen[j] phone]] ){
                [self.sfCongressmen[i] setTwitterID:[self.googCongressmen[j] twitterID]];
                [self.sfCongressmen[i] setFacebookID:[self.googCongressmen[j] facebookID]];
            }
        }
    }
}


- (NSString*)cleanPhoneNumber:(NSString*)phoneNumber
{
    
    
    NSString *cleanedPhoneNumber = [[NSString alloc]init];
    
    cleanedPhoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
    cleanedPhoneNumber = [cleanedPhoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return cleanedPhoneNumber;
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
}

- (void)formatTermDates:(NSString*)termDate congressman:(Congressman*)congressman
{
    
    congressman.termEnd = [[NSString alloc]init];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * dateNotFormatted = [dateFormatter dateFromString:termDate];
    [dateFormatter setDateFormat:@"d MMM YYYY"];
    NSString * termDateFormatted = [dateFormatter stringFromDate:dateNotFormatted];
    congressman.termEnd =  termDateFormatted;
    
}


@end
