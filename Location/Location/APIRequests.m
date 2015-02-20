//
//  NSURLConnections.m
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "APIRequests.h"

@implementation APIRequests


- (void)googleMapsRequest:(NSString*)searchText
{
    
    //NSString *homeAddress = @"115 Laurel Drive, 11040";
    
    
    NSString *string = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyBRIJi9cX10r1LJ2wDrcp1uYZCw6kROL9o", searchText];
    
    NSString *cleanUrl = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [[NSURL alloc] initWithString:cleanUrl];

    NSMutableURLRequest *getRequest = [NSMutableURLRequest requestWithURL:url];

    getRequest.HTTPMethod = @"GET";
    
    [getRequest setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [getRequest setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

    
    self.googleMapsConnection = [[NSURLConnection alloc] initWithRequest:getRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    
}



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



- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
    if (connection == self.googleMapsConnection) {
        
        
         NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:self.googleMapsResponseData options:0 error:nil];
        
        NSMutableDictionary *usrSearchAddressData = [decodedData valueForKey:@"results"];
        
        NSMutableArray *usrSearchLat = [usrSearchAddressData valueForKeyPath:@"geometry.location.lat"];
        NSMutableArray *usrSearchLng = [usrSearchAddressData valueForKeyPath:@"geometry.location.lng"];
        
        NSLog(@"%@", usrSearchLat);
        NSLog(@"%@", usrSearchLng);


    }
    
    
    else if (connection == self.sfConnection){
        
    }
    else if (connection == self.googleCivConnection){
        
    }
    else if (connection == self.photoConnection){
        
    }
}





@end
