//
//  CustomTableViewCell.h
//  Location
//
//  Created by John Bogil on 11/23/14.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Congressman.h"

@interface CustomTableViewCell : UITableViewCell


// Actions
- (IBAction)tweetButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;


// UI Objects
@property (strong, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;
@property (nonatomic, strong) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detail;
@property (strong, nonatomic)  UIImageView *photoView;
@property (strong, nonatomic) UIImageView *shadowView;
@property (strong, nonatomic) IBOutlet UIImageView *congressmanView;




@property (nonatomic, weak) Congressman *congressman;




@end


