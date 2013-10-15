//
//  ViewController.h
//  AutoLayoutADNClient
//
//  Created by Weien Wang on 10/11/13.
//  Copyright (c) 2013 Weien Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADNClientViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *ADNTableView;
@property (strong, nonatomic) NSArray *ADNDataSource;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end
