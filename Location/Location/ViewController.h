//
//  ViewController.h
//  Location
//
//  Created by PJ Vea on 12/19/13.
//  Copyright (c) 2013 PJ Vea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableData *responseData;

@property (strong, nonatomic) NSMutableArray *listOfMembers;

@property (strong, nonatomic) IBOutlet UINavigationBar *navigationBar;

-(IBAction)buttonPressed:(id)sender;




@end
