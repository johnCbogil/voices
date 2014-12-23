//
//  ViewController.m
//  Location
//


#import "ViewController.h"




@interface ViewController ()
@end

@implementation ViewController {
    
    CLLocationManager *manager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.navigationBar.hidden = YES;
    self.tableView.hidden = YES;
    
    manager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    
    [self createVoicesLabel];
    
    
    
    
    
    
    
}

-(void)createVoicesLabel{
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:64]];
    
    shimmeringView.contentView = self.voicesLabel;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    
    
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (IBAction)buttonPressed:(id)sender{
    
    [manager requestWhenInUseAuthorization];
    
    // Check for location services
    if([CLLocationManager locationServicesEnabled] &&
       [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied)
    {
        manager.delegate = self;
        manager.desiredAccuracy = kCLLocationAccuracyBest;
        [manager startUpdatingLocation];
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
}

-(void)locationServicesUnavailable{
    
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
    
    cell.delegate = self;
    
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
        
        
        cell.name.text = [NSString stringWithFormat:@"%@. %@ %@" , cell.congressman.ctitle, cell.congressman.firstName, cell.congressman.lastName];
        cell.detail.text = [NSString stringWithFormat:@"(%@) - Term Ends: %@", cell.congressman.party, cell.congressman.termEnd];
        
        cell.photoView.image = cell.congressman.photo;
        
        
        [cell.tweetButton setTitle:@"Twitter" forState:UIControlStateNormal];
        [cell.facebookButton setTitle:@"Facebook" forState:UIControlStateNormal];
        
        
        
        NSLog(@"Assigned data to cell #%ld", (long)indexPath.row);
        
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
-(void)passTwitterObject:(UIViewController*)controller{
    
    [self presentViewController:controller animated:YES completion:nil];
    NSLog(@"Presented twitter view controller");
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
    [self locationServicesUnavailable];
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocation *currentLocation = newLocation;
    NSLog(@"Retrieved current location, Latitude: %.8f Longitude: %.8f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
    [self sunlightFoundationRequest:currentLocation.coordinate.latitude coordinates:currentLocation.coordinate.longitude];
}


#pragma mark - Sunlight Foundation method

-(void)sunlightFoundationRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude{
    
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
    _responseData = [[NSMutableData alloc] init];


}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    self.receivedDataBytes += [data length];
    self.progressView.progress = self.receivedDataBytes / (float)self.totalFileSize;
    [_responseData appendData:data];


    
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    
    
    // Stop updating location bc we only need it once
    [manager stopUpdatingLocation];
    
    // Create Congressmen objects
    Congressman *senatorA = [[Congressman alloc]init];
    Congressman *senatorB = [[Congressman alloc]init];
    Congressman *representative = [[Congressman alloc]init];
    NSLog(@"Created Congressmen objects");
    
    // Decode data
    NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.responseData options:0 error:nil];
    NSMutableDictionary *results = [decodedData valueForKey:@"results"];
    
    // Parse the data
    NSMutableArray *firstName = [results valueForKey:@"first_name"];
    NSMutableArray *lastName = [results valueForKey:@"last_name"];
    NSMutableArray *party = [results valueForKey:@"party"];
    NSMutableArray *phone = [results valueForKey:@"phone"];
    NSMutableArray *termEnd = [results valueForKey:@"term_end"];
    NSMutableArray *ctitle = [results valueForKey:@"title"];
    NSMutableArray *bioGuide = [results valueForKey:@"bioguide_id"];
    NSMutableArray *twitterIDs = [results valueForKey:@"twitter_id"];
    NSMutableArray *facebookIDs = [results valueForKey:@"facebook_id"];
    NSLog(@"Parsed data from SF request");
    
    
    [self downloadPhotos:bioGuide[0] congressman:representative];
    [self downloadPhotos:bioGuide[1] congressman:senatorA];
    [self downloadPhotos:bioGuide[2] congressman:senatorB];
    NSLog(@"Sent all three bioguides to the photoDownload method");
    
    
    // Assign the data to properties
    representative.firstName = firstName[0];
    senatorA.firstName = firstName[1];
    senatorB.firstName = firstName[2];
    
    representative.lastName = lastName[0];
    senatorA.lastName = lastName[1];
    senatorB.lastName = lastName[2];
    
    representative.phone = phone[0];
    senatorA.phone = phone[1];
    senatorB.phone = phone[2];
    
    representative.party = party[0];
    senatorA.party = party[1];
    senatorB.party = party[2];
    
    representative.termEnd = termEnd[0];
    senatorA.termEnd = termEnd[1];
    senatorB.termEnd = termEnd[2];
    
    representative.ctitle = ctitle[0];
    senatorA.ctitle = ctitle[1];
    senatorB.ctitle = ctitle[2];
    
    representative.twitterID = twitterIDs[0];
    senatorA.twitterID = twitterIDs[1];
    senatorB.twitterID = twitterIDs[2];
    
    representative.facebookID = facebookIDs[0];
    senatorA.facebookID = facebookIDs[1];
    senatorB.facebookID = facebookIDs[2];
    NSLog(@"Assigned appropriate attribute to each Congressman");
    
    
    // Add Congressmen to an array for later use
    self.listOfMembers = [[NSMutableArray alloc]init];
    [self.listOfMembers addObject:representative];
    [self.listOfMembers addObject:senatorA];
    [self.listOfMembers addObject:senatorB];
    NSLog(@"Added congressmen to listOfMembers");
    
    self.tableView.hidden = NO;
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}


-(void)downloadPhotos:(NSString*)bioGuide congressman:(Congressman*)congressman{
    
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
