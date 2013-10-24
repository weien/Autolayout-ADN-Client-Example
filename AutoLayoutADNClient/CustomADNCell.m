//
//  CustomADNCell.m
//  AutoLayoutADNClient
//
//  Created by Weien Wang on 10/11/13.
//  Copyright (c) 2013 Weien Wang. All rights reserved.
//

#import "CustomADNCell.h"
#import "Constants.h"

#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@implementation CustomADNCell
@synthesize posterNameLabel = _posterNameLabel;
@synthesize postTextLabel = _postTextLabel;
@synthesize avatarImageView = _avatarImageView;

- (void)configureForPost:(NSDictionary *)postForCell {
    NSString* posterName = postForCell[@"user"][@"username"];
    self.posterNameLabel.attributedText = [[NSAttributedString alloc] initWithString:posterName];
    [self.posterNameLabel setFont:[UIFont boldSystemFontOfSize:FONT_SIZE + 2]];
    
    NSString* postText = postForCell[@"text"];
    self.postTextLabel.attributedText = [[NSAttributedString alloc] initWithString:postText];
    [self.postTextLabel setFont:[UIFont systemFontOfSize:FONT_SIZE]];
    
    NSURL* avatarURL = [NSURL URLWithString:postForCell[@"user"][@"avatar_image"][@"url"]];
    [self.avatarImageView setImageWithURL:avatarURL]; //use AFNetworking for background/cache support
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.layer.cornerRadius = 12.0f; //mimick iOS 7 app icons
    
    //cell.posterNameLabel.layer.borderWidth = 1;
    //cell.postTextLabel.layer.borderWidth = 1;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
