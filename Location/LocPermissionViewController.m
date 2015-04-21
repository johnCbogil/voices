//
//  LocPermissionViewController.m
//  Voices
//
//  Created by Aditya Narayan on 4/20/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "LocPermissionViewController.h"

@interface LocPermissionViewController ()

@end

@implementation LocPermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] initWithFrame:self.voicesLabel.bounds];
    
    [self.voicesLabel addSubview:shimmeringView];
    
    self.voicesLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    
    self.voicesLabel.textAlignment = NSTextAlignmentCenter;
    
    self.voicesLabel.text = NSLocalizedString(@"Voices", nil);
    [self.voicesLabel setFont:[UIFont fontWithName:@"Avenir" size:80]];
    self.voicesLabel.textColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                 green:(128.0 / 255.0)
                                                  blue:(5.0 / 255.0)
                                                 alpha:1.0];
    
    shimmeringView.contentView = self.voicesLabel;
    shimmeringView.shimmering = YES;
    shimmeringView.shimmeringSpeed = 115;
    
    self.allowButton.layer.cornerRadius = 5;
    self.laterButton.layer.cornerRadius = 5;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (IBAction)laterButtonPressed:(id)sender {
    
    
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"] animated:YES completion:nil];

    
    
}

- (IBAction)allowButtonPressed:(id)sender {
    
    self.manager = [[CLLocationManager alloc]init];
    self.manager.delegate = self;
    
    
    [self.manager requestWhenInUseAuthorization];
    
    

    
    
}


- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        NSLog(@"location authorization denied");
    }
    else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        
        
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"] animated:YES completion:nil];
        
    }
    
}

@end
