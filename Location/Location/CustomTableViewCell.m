//
//  CustomTableViewCell.m
//  Location
//
//  Created by Aditya Narayan on 11/23/14.
//  Copyright (c) 2014 PJ Vea. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "Congressman.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


@implementation CustomTableViewCell


@synthesize name = _name;
@synthesize delegate = _delegate;



    


- (void)awakeFromNib {
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 80, 80)];
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
    self.photoView.clipsToBounds = YES;
    //[self.photoView setBackgroundColor: RGB(105, 141, 157)];

    [self addSubview:self.photoView];
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


// Make sure twitter account is logged into settings
- (IBAction)tweetButtonPressed:(id)sender {
    
    NSLog(@"Tweet button pressed");
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *name = [NSString stringWithFormat:@"@%@", self.congressman.twitterID ];
        [tweetSheetOBJ setInitialText:name];
        
        [self.delegate passTwitterObject:tweetSheetOBJ];

    }
}
@end
