//
//  ViewController.m
//  Location
//


#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "Congressman.h"
#import "CustomTableViewCell.h"

@interface ViewController () <CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, UISearchBarDelegate, UISearchDisplayDelegate>
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
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}



- (IBAction)buttonPressed:(id)sender{
    
    self.tableView.hidden = NO;
    
    [manager requestWhenInUseAuthorization];
    manager.delegate = self;
    manager.desiredAccuracy = kCLLocationAccuracyBest;
    [manager startUpdatingLocation];
    
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
    NSString *firstName = [(Congressman*)[self.listOfMembers objectAtIndex:indexPath.row]firstName];
    NSString *lastName = [(Congressman*)[self.listOfMembers objectAtIndex:indexPath.row]lastName];
    NSString *party = [(Congressman*)[self.listOfMembers objectAtIndex:indexPath.row]party];
    NSString *termEnd = [(Congressman*) [self.listOfMembers objectAtIndex:indexPath.row]termEnd];
    NSString *ctitle = [(Congressman*) [self.listOfMembers objectAtIndex:indexPath.row]ctitle];
    
    if(cell.textLabel.text == nil)
    {
        cell.textLabel.text = @"";
        cell.detailTextLabel.text = @"";
    }
    else {
        cell.name.text = [NSString stringWithFormat:@"%@. %@ %@" ,ctitle, firstName, lastName];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeueLight" size:6];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"(%@) - Term Ends: %@", party, termEnd];
        
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
    
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error: %@", error);
    NSLog(@"Failed to get location");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    
    CLLocation *currentLocation = newLocation;
    NSLog(@"Latitude: %.8f, Longitude: %.8f\n", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    
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
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
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
    NSMutableArray *headShots = [[NSMutableArray alloc]init];
    NSMutableArray *bioGuide = [results valueForKey:@"bioguide_id"];
    
    [self downloadHeadshots:bioGuide[0]];
    [self downloadHeadshots:bioGuide[1]];
    [self downloadHeadshots:bioGuide[2]];
    
    NSLog(@"%@", bioGuide[1]);
    NSLog(@"SF Data Recieved");
    
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
    
    // Add Congressmen to an array for later use
    self.listOfMembers = [[NSMutableArray alloc]init];
    [self.listOfMembers addObject:representative];
    [self.listOfMembers addObject:senatorA];
    [self.listOfMembers addObject:senatorB];
    
    
    [self.tableView reloadData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
}

-(void)downloadHeadshots:(NSMutableArray*)bioGuide{
    
    
    NSString *urlWithBioGuide = [NSString stringWithFormat:@"http://theunitedstates.io/images/congress/450x550/%@.jpg", bioGuide];
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlWithBioGuide]];

        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *image = [UIImage imageWithData:data];
            [self.headShots addObject:image];
            NSLog(@"%@", image);
            
        });
    });
    
    
}

@end
