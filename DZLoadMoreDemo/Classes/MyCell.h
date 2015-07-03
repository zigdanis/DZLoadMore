//
//  MyCell.h
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 03/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyObject;

@interface MyCell : UITableViewCell

- (void)setupWithItem:(MyObject *)item;

@end
