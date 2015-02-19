//
//  NSURLConnections.h
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLConnections : NSObject <NSURLConnectionDataDelegate>

@property (nonatomic, strong) NSURLConnection *googleMapsConnection;
@property (nonatomic, strong) NSMutableData *googleMapsResponseData;


- (void)googleMapsRequest;


@end
