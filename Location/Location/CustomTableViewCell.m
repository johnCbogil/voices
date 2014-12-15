//
//  CustomTableViewCell.m
//  Location
//
//  Created by Aditya Narayan on 11/23/14.
//  Copyright (c) 2014 PJ Vea. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "Congressman.h"

@implementation CustomTableViewCell


@synthesize name = _name;
@synthesize delegate = _delegate;



    


- (void)awakeFromNib {

    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 85, 85)];

    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
    self.photoView.clipsToBounds = YES;
    //[self.circleView setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:self.photoView];

    

    NSLog(@"Added imageView to cell");
}





-(void)drawRect:(CGRect)rect{
    

    
    
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
