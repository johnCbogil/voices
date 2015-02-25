//
//  NSURLConnections.m
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "APIRequests.h"

@implementation APIRequests

#pragma mark - Requsts

- (void)googleMapsRequest:(NSString*)searchText
{
    
    
    NSString *string = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&components=country:US&key=AIzaSyBRIJi9cX10r1LJ2wDrcp1uYZCw6kROL9o", searchText];
    
    NSString *cleanUrl = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc] initWithString:cleanUrl];

    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];

    getRequest.HTTPMethod = @"GET";
    
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    
    self.googleMapsConnection = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
}

- (void)sunlightFoundationRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude
{
    self.photoRequestCounter = 0;

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://congress.api.sunlightfoundation.com/legislators/locate?latitude=%.8f&longitude=%.8f&apikey=6c15da72f7f04c91bad04c89c178e01e", latitude, longitude]];
    NSLog(@"SF URL: %@", url);
    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];
    
    getRequest.HTTPMethod = @"GET";
    
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    self.sfConnection = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
    
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

- (void)googleCivRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude
{
    
    self.manager = [[CLLocationManager alloc] init];
    self.geocoder = [[CLGeocoder alloc] init];
    
    self.currentLocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        self.placemark = [placemarks lastObject];
        
        NSString * address = [NSString stringWithFormat:@"%@ %@ %@ %@ %@", self.placemark.subThoroughfare, self.placemark.thoroughfare, self.placemark.postalCode, self.placemark.administrativeArea, self.placemark.country];
        NSString *formattedAddress = [address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.googleapis.com/civicinfo/v2/representatives?address=%@&includeOffices=true&levels=country&roles=legislatorLowerBody&roles=legislatorUpperBody&key=AIzaSyAFmuzxmKaPRHW6DTh3ZEfUySugM_Jj7_s", formattedAddress ]];
        NSLog(@"Google URL: %@", url);
        
        NSMutableURLRequest *googleGetRequest = [NSMutableURLRequest requestWithURL:url];
        googleGetRequest.HTTPMethod = @"GET";
        self.googleCivConnection = [[NSURLConnection alloc] initWithRequest:googleGetRequest delegate:self];
        
    }];

}


#pragma mark - Response/Data Handlers
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if(connection == self.googleMapsConnection){
        
        self.googleMapsResponseData = [[NSMutableData alloc]init];
    }
    else if (connection == self.sfConnection){
        
        self.sfResponseData = [[NSMutableData alloc]init];
    }
    else if (connection == self.googleCivConnection){
        
        self.googleCivResponseData = [[NSMutableData alloc]init];
    }
    else if (connection == self.photoConnection){
        
        self.photoResponseData = [[NSMutableData alloc]init];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if(connection == self.googleMapsConnection){
        
        [self.googleMapsResponseData appendData:data];
    }
    else if (connection == self.sfConnection){
        
        [self.sfResponseData appendData:data];
    }
    else if (connection == self.googleCivConnection){
        
        [self.googleCivResponseData appendData:data];
    }
    else if (connection == self.photoConnection){
        
        [self.photoResponseData appendData:data];
    }
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}



# pragma mark - connectionDidFinishLoading

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == self.googleMapsConnection) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

         NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.googleMapsResponseData options:0 error:nil];
        
        NSMutableDictionary *userSearchAddressData = [decodedData valueForKey:@"results"];
        
        NSString *userSearchLat = [userSearchAddressData valueForKeyPath:@"geometry.location.lat"][0];
        NSString *userSearchLng = [userSearchAddressData valueForKeyPath:@"geometry.location.lng"][0];
        
        
        CLLocationDegrees latitude = [userSearchLat doubleValue];
        CLLocationDegrees longitude = [userSearchLng doubleValue];
        
        
        [self sunlightFoundationRequest:latitude coordinates:longitude];
        
        [self googleCivRequest:latitude coordinates:longitude];

    }
    
    
    else if (connection == self.sfConnection){
        
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
    else if (connection == self.googleCivConnection){
        
        self.googCongressmen = [[NSMutableArray alloc]init];
        
        // Decode the json data
        NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.googleCivResponseData options:0 error:nil];
        
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
            
            // DC check
            if([self.sfCongressmen count] > 1){
                
                NSLog(@"Firing second photo request");
                [self photoRequest:self.bioGuides[1]];
            }
            else
            {
                self.photoRequestCounter = 0;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTableViewNotification" object:nil];

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
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ReloadTableViewNotification" object:nil];
            
            
        }
    }

        
    
}

#pragma mark - More Data Parsing Methods

- (void)formatTermDates:(NSString*)termDate congressman:(Congressman*)congressman
{
    
    
    if([termDate isEqualToString:@"2017-01-03"]){
        
        
        congressman.termEnd = @"4 Nov 2016";
        
    }
    else if ([termDate isEqualToString:@"2019-01-03"]){
        
        congressman.termEnd = @"6 Nov 2018";
        
        
    }
    else if([termDate isEqualToString:@"2021-01-03"]){
        
        congressman.termEnd = @"3 Nov 2020";
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





@end
