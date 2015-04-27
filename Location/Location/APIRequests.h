//
//  NSURLConnections.h
//  Voices
//
//  Created by Aditya Narayan on 2/19/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Congressman.h"
#import "HomeViewController.h"
#import "Keys.h"

@class HomeViewController;



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
@property int photoRequestCounter;


// CoreLocation Properties
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) CLPlacemark *placemark;
@property (strong, nonatomic) CLLocationManager *manager;
@property (strong, nonatomic) CLLocation *currentLocation;

// Congressmen Properties
@property (strong, nonatomic) Congressman *sfDude;
@property (strong, nonatomic) NSMutableArray *sfCongressmen;
@property (strong, nonatomic) NSMutableArray *googCongressmen;
@property (strong, nonatomic) NSMutableArray *congressmenPhotos;
@property (strong, nonatomic) NSMutableArray *bioGuides;




@property (strong, nonatomic) HomeViewController *HomeViewController;






- (void)determineGPSCoordinates:(NSString*)searchText;
- (void)sunlightFoundationRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude;
- (void)googleCivRequest:(CLLocationDegrees)latitude coordinates:(CLLocationDegrees)longitude;




@end
