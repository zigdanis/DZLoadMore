//
//  MyDataSource.h
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 02/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "DZLoadMoreDataSource.h"

@interface MyDataSource : DZLoadMoreDataSource

- (void)flushItems;
- (void)appendItems:(NSArray *)items;

@end
