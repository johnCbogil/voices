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

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, weak) Congressman * congressman;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *detail;

@property (strong, nonatomic)  UIImageView *photo;

- (IBAction)tweetButtonPressed:(id)sender;


@property (nonatomic, retain) id<loadTwitterViewProtocol> delegate;





@end


