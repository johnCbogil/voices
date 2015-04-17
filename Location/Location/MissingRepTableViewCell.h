//
//  MissingRepTableViewCell.h
//  Voices
//
//  Created by John Bogil on 3/11/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MissingRepTableViewCell : UITableViewCell


@property (strong, nonatomic)  UIImageView *photoView;
@property (strong, nonatomic) UIImageView *shadowView;
@property (strong, nonatomic) IBOutlet UITextView *missingRepTextView;


@end
