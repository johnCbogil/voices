//
//  CustomTableViewCell.m
//  Location
//
//  Created by John Bogil on 11/23/14.
//  Copyright (c) John Bogil All rights reserved.
//

#import "CustomTableViewCell.h"


@implementation CustomTableViewCell


@synthesize name = _name;
@synthesize delegate = _delegate;






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
        
        
        [self addSubview:self.shadowView];
        
        self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 82, 82)];
        
        
        self.photoView.contentMode = UIViewContentModeScaleAspectFill;
        self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
        
        self.photoView.clipsToBounds = YES;
        
        [self addSubview:self.photoView];
    });
                   


    
 

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


// Make sure twitter account is logged into settings when testing
- (IBAction)tweetButtonPressed:(id)sender {
    
    NSLog(@"Tweet button pressed");
    NSLog(@"%@", self.congressman.twitterID);
//    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
//    {
//        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
//        
//        NSString *name = [NSString stringWithFormat:@"@%@", self.congressman.twitterID ];
//        [tweetSheetOBJ setInitialText:name];
//        
//        [self.delegate passTwitterObject:tweetSheetOBJ];
//        
//    }
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://"]]) {
        
        if(![self.congressman.twitterID isEqual: [NSNull null]]){
            
            NSString *twitterID = [NSString stringWithFormat:@"twitter://user?screen_name=%@", self.congressman.twitterID ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
        }
        else{
           
            NSString *twitterID = [NSString stringWithFormat:@"twitter://search?query=%@%@", self.congressman.firstName, self.congressman.lastName ];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:twitterID]];
        }
    }
    else{

    }


}
- (IBAction)facebookButtonPressed:(id)sender {
    
    
    NSString *urlWithBioGuide = [NSString stringWithFormat:@"http://graph.facebook.com/%@", self.congressman.facebookID];

    dispatch_async(dispatch_get_global_queue(0,0), ^{
        
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: urlWithBioGuide]];
        
        if ( data == nil )
            return;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Decode data
            NSMutableDictionary *decodedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            // Extract only the officials from the dict
            NSString *fbid = [decodedData valueForKey:@"id"];
            NSLog(@"%@", fbid);
            
            
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
                
                
                
                NSString *facebookID = [NSString stringWithFormat:@"fb://profile/%@",fbid];
                [[UIApplication sharedApplication]openURL:[NSURL URLWithString:facebookID]];
                NSLog(@"%@", facebookID);
            }
        });
    });

    
    
    
    
    
//    
//    // will be YES if the string only has number characters in it
//    if([self.congressman.facebookID rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound){
//        
//        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
//            
//            
//            
//            NSString *facebookID = [NSString stringWithFormat:@"fb://profile/%@",self.congressman.facebookID];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:facebookID]];
//            NSLog(@"%@", facebookID);
//            
//        }
//        
//        
//    }
//    else{
//        
//        NSString *facebookID = [NSString stringWithFormat:@"https://m.facebook.com/%@", self.congressman.facebookID];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:facebookID]];
//
//        NSLog(@"open webview or safari");
//    }
//    
//    
//    NSLog(@"Facebook button pressed");
//    
//
//}
}

@end
