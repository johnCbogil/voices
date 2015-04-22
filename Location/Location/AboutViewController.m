//
//  AboutViewController.m
//  Voices
//
//  Created by Aditya Narayan on 4/21/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];


    // About page 1 - "voices is"
        self.whatIsVoicesLabel.textColor = [UIColor colorWithRed:255.0 / 255.0
                                                       green:128.0 / 255.0
                                                        blue:5.0 / 255.0
                                                       alpha:1.0];
    self.voicesIsTextView.textColor = [UIColor colorWithRed:83.0 / 255
                                                      green:95.0 / 255.0
                                                       blue:107.0 / 255.0
                                                      alpha:1.0];
    


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
