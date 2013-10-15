//
//  ViewController.m
//  AutoLayoutADNClient
//
//  Created by Weien Wang on 10/11/13.
//  Copyright (c) 2013 Weien Wang. All rights reserved.
//

#import "ADNClientViewController.h"
#import "CustomADNCell.h"

@interface ADNClientViewController ()
@end

@implementation ADNClientViewController
@synthesize ADNDataSource = _ADNDataSource;
@synthesize ADNTableView = _ADNTableView;
@synthesize refreshControl = _refreshControl;

- (void) viewDidLoad {
    [super viewDidLoad];
    [self getTimeline];
    [self setupRefreshController];
}

- (void) refreshTableView {
    if (!self.refreshControl) {
        [self setupRefreshController];
    }
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing..."];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self getTimeline];
}

- (void) setupRefreshController {
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"];
    [self.refreshControl addTarget:self action:@selector(refreshTableView) forControlEvents:UIControlEventValueChanged];
    [self.ADNTableView addSubview:self.refreshControl];
}

- (void) getTimeline {
    NSURL* dataURL = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
    dispatch_async(dispatch_queue_create("downloadADNData", NULL), ^{
        NSError* downloadError = nil;
        NSData* data = [NSData dataWithContentsOfURL:dataURL options:NSDataReadingMappedAlways error:&downloadError];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError* parseError = nil;
            id parsedData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
            
            //NSLog(@"parsedData is %@", parsedData);
            
            if ([parsedData isKindOfClass:[NSDictionary class]]) {
                self.ADNDataSource = parsedData[@"data"]; //already in reveres chron. order http://developers.app.net/docs/resources/post/#sorting-posts
                [self.ADNTableView reloadData];
            }
            
            NSDateFormatter *formattedDate = [[NSDateFormatter alloc] init];
            [formattedDate setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formattedDate stringFromDate:[NSDate date]]];
            self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
            [self.refreshControl endRefreshing];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    });
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.ADNDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ADNCell";
    CustomADNCell *cell = [self.ADNTableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomADNCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    NSDictionary* postForCell = self.ADNDataSource[[indexPath row]];    
    [cell configureForPost:postForCell];

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

 - (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     //thanks to http://stackoverflow.com/a/18746930/2284713 for this approach
     CustomADNCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ADNCell"];
     NSDictionary *postForCell = self.ADNDataSource[[indexPath row]];
     NSString* text = postForCell[@"text"];
     cell.postTextLabel.text = text;
     cell.postTextLabel.preferredMaxLayoutWidth = 230.0f;
     
     [cell.contentView setNeedsLayout];
     [cell.contentView layoutIfNeeded];
     
     CGFloat heightForText = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1.0f; //add a point to avoid rounding systemLayoutSizeFittingSize: errors
     
     CGFloat height = MAX(heightForText, 80);
     
     return height;
 }

@end
