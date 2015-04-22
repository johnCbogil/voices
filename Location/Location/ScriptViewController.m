//
//  ScriptViewController.m
//  Voices
//
//  Created by Aditya Narayan on 4/21/15.
//  Copyright (c) 2015 John Bogil. All rights reserved.
//

#import "ScriptViewController.h"

@interface ScriptViewController ()

@end

@implementation ScriptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIFont *avenirFont = [UIFont fontWithName:@"Avenir" size:16.0];



    // About page 3 - "script"
    self.pageHeaderThree.textColor = [UIColor colorWithRed:(255.0 / 255.0)
                                                     green:(128.0 / 255.0)
                                                      blue:(5.0 / 255.0)
                                                     alpha:1];

    
    NSString *scriptString = @"Hello, my name is [your name] and I would like "
    @"the Congressman to [support/oppose] [something "
    @"that you care about] and I will be voting in " @"November";
    
    NSDictionary *attrsDictionary =
    [NSDictionary dictionaryWithObject:avenirFont forKey:NSFontAttributeName];
    NSMutableAttributedString *scriptAttributedString =
    [[NSMutableAttributedString alloc] initWithString:scriptString
                                           attributes:attrsDictionary];
    
    // grey
    [scriptAttributedString
     addAttribute:NSForegroundColorAttributeName
     value:[UIColor colorWithRed:83.0 / 255
                           green:95.0 / 255.0
                            blue:107.0 / 255.0
                           alpha:1.0]
     range:NSMakeRange(0, scriptAttributedString.length)];
    
    // orange
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor colorWithRed:255.0 / 255.0
                                                         green:128.0 / 255.0
                                                          blue:5.0 / 255.0
                                                         alpha:1.0]
                                   range:NSMakeRange(18, 11)];
    [scriptAttributedString addAttribute:NSForegroundColorAttributeName
                                   value:[UIColor colorWithRed:255.0 / 255.0
                                                         green:128.0 / 255.0
                                                          blue:5.0 / 255.0
                                                         alpha:1.0]
                                   range:NSMakeRange(65, 49)];
    
    // font
    [scriptAttributedString addAttribute:NSFontAttributeName
                                   value:[UIFont fontWithName:@"Avenir" size:19.0]
                                   range:NSMakeRange(0, 100)];
    
//    [self.scriptTextView setAttributedText:scriptAttributedString];
//    self.scriptTextView.textAlignment = 1.0;
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
