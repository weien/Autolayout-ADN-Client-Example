//
//  CustomADNCell.h
//  AutoLayoutADNClient
//
//  Created by Weien Wang on 10/11/13.
//  Copyright (c) 2013 Weien Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomADNCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *posterNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *postTextLabel;
@property (strong, nonatomic) IBOutlet UIImageView *avatarImageView;

- (void) configureForPost:(NSDictionary*)postForCell;

@end
