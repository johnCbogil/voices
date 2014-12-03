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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)tweetButtonPressed:(id)sender {
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                  composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *name = [NSString stringWithFormat:@"@%@", self.congressman.twitterID ];
        [tweetSheetOBJ setInitialText:name];        
        [self.delegate passTwitterObject:tweetSheetOBJ];

    }
    
    
    
    
}
@end
