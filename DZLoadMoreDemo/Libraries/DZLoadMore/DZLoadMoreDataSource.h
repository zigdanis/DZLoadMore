//
//  LoadMoreTVController.h
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 21/04/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoadingCellActivityTag 151

typedef void(^BOOLCallback)(BOOL success);
typedef void(^CallbackWithBOOLCallback)(BOOLCallback);
typedef void(^CallbackWithItemAndBOOLCallback)(id lastItem, BOOLCallback);

@interface DZLoadMoreDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) BOOL noMoreItems;
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, copy) CallbackWithItemAndBOOLCallback loadMoreItemsBlock;
@property (nonatomic, copy) CallbackWithBOOLCallback refreshContentBlock;

- (void)refreshContent;
+ (UITableViewCell *)emptyCell;
+ (UITableViewCell *)loadingCell;
- (CGFloat)calculatedHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell forTable:(UITableView *)table;

@end
