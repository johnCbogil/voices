//
//  NSURLConnections.h
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIRequests : NSObject <NSURLConnectionDataDelegate>


// GoogleMaps API Properties
@property (nonatomic, strong) NSURLConnection *googleMapsConnection;
@property (nonatomic, strong) NSMutableData *googleMapsResponseData;

// SF API Properties
@property (strong, nonatomic) NSMutableData *sfResponseData;
@property (strong, nonatomic) NSURLConnection *sfConnection;


// GoogleCiv API Properties
@property (strong, nonatomic) NSMutableData *googleCivResponseData;
@property (strong, nonatomic) NSURLConnection *googleCivConnection;


// Congress.gov API Properties
@property (strong, nonatomic) NSMutableData *photoResponseData;
@property (strong, nonatomic) NSURLConnection *photoConnection;















- (void)googleMapsRequest:(NSString*)searchText;


@end
