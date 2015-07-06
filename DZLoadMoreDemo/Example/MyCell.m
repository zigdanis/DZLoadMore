//
//  MyCell.m
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 03/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "MyCell.h"
#import "MyObject.h"

@interface MyCell ()

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;

@end

@implementation MyCell

- (void)setupWithItem:(MyObject *)item {
    self.titleLabel.text = [NSString stringWithFormat:@"Item %li", (long)item.order];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    self.detailTextLabel.text = [dateFormatter stringFromDate:item.date];
}

@end
