//
//  CustomTableViewCell.h
//  Location
//
//  Created by Aditya Narayan on 11/23/14.
//  Copyright (c) 2014 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "PassTwitterObject.h"
#import "Congressman.h"
#import <QuartzCore/QuartzCore.h>


@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, weak) Congressman *congressman;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detail;

@property (strong, nonatomic)  UIImageView *photoView;
@property (strong, nonatomic) UIImageView *shadowView;

- (IBAction)tweetButtonPressed:(id)sender;
- (IBAction)facebookButtonPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *tweetButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookButton;



@property (nonatomic, retain) id<loadTwitterViewProtocol> delegate;

@property (strong, nonatomic) IBOutlet UIImageView *congressmanView;




@end


