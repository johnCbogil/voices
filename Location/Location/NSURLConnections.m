//
//  NSURLConnections.m
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "NSURLConnections.h"

@implementation NSURLConnections


- (void)googleMapsRequest
{
    
    NSString *homeAddress = @"115 Laurel Drive, 11040";
    
    
    NSString *string = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyBRIJi9cX10r1LJ2wDrcp1uYZCw6kROL9o", homeAddress];
    
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
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
    if(connection == self.googleMapsConnection){
        
        [self.googleMapsResponseData appendData:data];
        
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
        
        NSLog(@"%@", decodedData);
        
        
        
        
        
    }
}





@end
