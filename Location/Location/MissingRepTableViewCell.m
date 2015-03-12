//
//  MissingRepTableViewCell.m
//  Voices
//
//  Created by John Bogil on 3/11/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "MissingRepTableViewCell.h"

@implementation MissingRepTableViewCell

- (void)awakeFromNib {
    
    [self createMissingRepAttributedString];
    
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
    [self.photoView setImage:[UIImage imageNamed:@"johnlennon23.png"]];
    
    
    
    self.photoView.contentMode = UIViewContentModeScaleAspectFill;
    self.photoView.layer.cornerRadius = self.photoView.frame.size.width / 2;
    
    self.photoView.clipsToBounds = YES;
    
    [self.contentView addSubview:self.photoView];
    
    
    
    
    
}

- (void)createMissingRepAttributedString
{
    
    NSMutableAttributedString *missingRepAttributedString = [[NSMutableAttributedString alloc]initWithString:@"Your Representative is missing! Try searching like this: (street, zip)" attributes:nil];
    [missingRepAttributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Avenir" size:19.0] range:NSMakeRange(0, [missingRepAttributedString length])];
    [missingRepAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0 green:128.0/255.0 blue:5.0/255.0 alpha:1.0] range:NSMakeRange(56,14)];
    [missingRepAttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:83.0/255 green:95.0/255.0 blue:107.0/255.0 alpha:1.0] range:NSMakeRange(0,(missingRepAttributedString.length-14))];
    
    
    
    [self.missingRepTextView setAttributedText:missingRepAttributedString];
    self.missingRepTextView.textAlignment = 1.0;

    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
