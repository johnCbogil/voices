//
//  LocPermissionViewController.h
//  Voices
//
//  Created by Aditya Narayan on 4/20/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FBShimmering.h"
#import "FBShimmeringView.h"


@interface LocPermissionViewController : UIViewController <CLLocationManagerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *voicesLabel;

@property (strong, nonatomic) IBOutlet UIButton *laterButton;
@property (strong, nonatomic) IBOutlet UIButton *allowButton;
- (IBAction)laterButtonPressed:(id)sender;
- (IBAction)allowButtonPressed:(id)sender;

@property (strong, nonatomic) CLLocationManager *manager;


@end
