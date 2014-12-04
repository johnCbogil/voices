//
//  Congressman.h
//  Location
//
//  Created by John Bogil on 10/4/14.
//  Copyright (c) 2014 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Congressman : UIViewController

@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *party;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *termEnd;
@property (strong, nonatomic) NSString *ctitle;
@property (strong, nonatomic) NSString *bioGuide;
@property (strong, nonatomic) NSString *facebookID;
@property (strong, nonatomic) NSString *twitterID;
@property (strong, nonatomic) UIImage *photo;


@end
