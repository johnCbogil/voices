
//  CustomTableViewCell.m
//  Location
//
//  Created by John Bogil on 11/23/14.
//  Copyright (c) John Bogil All rights reserved.
//

#import "CustomTableViewCell.h"


@implementation CustomTableViewCell


@synthesize name = _name;



- (void)awakeFromNib {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self.shadowView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 82, 82)];
        [self.shadowView setBackgroundColor:[UIColor whiteColor]];
        self.shadowView.layer.cornerRadius = self.shadowView.frame.size.width / 2;
        self.shadowView.clipsToBounds = NO;
        
        self.shadowView.layer.shadowColor = [UIColor blackColor].CGColor;
        self.shadowView.layer.shadowOffset = CGSizeMake(3, -3);
        self.shadowView.layer.shadowOpacity = .2;
        self.shadowView.layer.shadowRadius = 3;
        
        self.shadowView.layer.shouldRasterize = YES;
        
        
        [self.contentView addSubview:self.shadowView];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 82, 82)];
        
        
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
        
        self.photoView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.photoView];
    });
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


// Make sure twitter account is logged into settings when testing
- (IBAction)tweetButtonPressed:(id)sender {
    
    
    NSLog(@"Tweet button pressed");
    NSLog(@"%@", self.congressman.twitterID);
    
    // Check if the user has twitter installed
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        
        // Check if the twitterID is null
        if(![self.congressman.twitterID isEqual: [NSNull null]]){
            
            // If its !null, use the ID to open twitter
            NSString *twitterID = [NSString stringWithFormat:@"twitter://user?screen_name=%@", self.congressman.twitterID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
        }
        else{
            
            // If it is null, open twitter with a search of the congressman's name
            NSString *twitterID = [NSString stringWithFormat:@"twitter://search?query=%@%@", self.congressman.firstName, self.congressman.lastName ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
        }
    }
    // If the user doesnt have twitter installed
    else{
        
        // Check if the twitter id is null
        if(![self.congressman.twitterID isEqual: [NSNull null]]){
            
            // If its !null, use the id in safari
            NSString *twitterID = [NSString stringWithFormat:@"https://twitter.com/%@", self.congressman.twitterID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
        }
        
        // If its null, perform a twitter search in safari
        else{
            
            NSString *twitterID = [NSString stringWithFormat:@"https://twitter.com/search?q=%@%@%@", self.congressman.firstName, @" ", self.congressman.lastName ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
            
        }
    }
    
    
    
    
    
}
- (IBAction)facebookButtonPressed:(id)sender {
    
    UIAlertView *noFacebookAcct = [[UIAlertView alloc]initWithTitle:@"No Facebook Account" message:@"This Congressman hasn't added their Facebook account to Google's database. Try tweeting at them or giving them a call instead" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    // Check if the facebook is null
    if(![self.congressman.facebookID isEqual: [NSNull null]]){
        
        NSString *urlWithBioGuide = [NSString stringWithFormat:@"http://graph.facebook.com/%@", self.congressman.facebookID];
        
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlWithBioGuide]];
            
            if ( data == nil )
                return;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                // Decode data
                NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                // Extract only the ids from the dict
                NSString *fbid = [decodedData valueForKey:@"id"];
                NSLog(@"%@", fbid);
                
                // Check if the user has the fb app installed
                if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
                    
                    NSString *facebookID = [NSString stringWithFormat:@"fb://profile/%@",fbid];
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:facebookID]];
                    NSLog(@"%@", facebookID);
                    
                }
                // If fb app is not installed, use safari
                else{
                    
                    NSString *facebookID = [NSString stringWithFormat:@"https://www.facebook.com/%@",fbid];
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:facebookID]];
                    NSLog(@"%@", facebookID);                }
            });
        });
    }
    else{
        
        [noFacebookAcct show];
    }
}

@end
