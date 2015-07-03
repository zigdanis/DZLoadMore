//
//  LoadMoreTVController.m
//  EatWithMe
//
//  Created by Danis Ziganshin on 21/04/15.
//  Copyright (c) 2015 Giselle Ramirez. All rights reserved.
//

#import "DZLoadMoreDataSource.h"

#define kLoadingCellIdentifier @"LoadingCell"
#define kEmptyCellIdentifier   @"EmptyCell"

@interface DZLoadMoreDataSource ()

@property (nonatomic, assign) BOOL loadingItems;

@end

@implementation DZLoadMoreDataSource

- (void)refreshContent {
    self.loadingItems = YES;
    if (self.refreshContentBlock) {
        self.refreshContentBlock(^(BOOL noMoreItems){
            self.loadingItems = NO;
            self.noMoreItems  = noMoreItems;
        });
    }
}

- (void)loadMore {
    self.loadingItems = YES;
    id lastItem = [self.items lastObject];
    if (self.loadMoreItemsBlock) {
        self.loadMoreItemsBlock(lastItem, ^(BOOL noMoreItems){
            self.loadingItems = NO;
            self.noMoreItems  = noMoreItems;
        });
    }
}

#pragma mark - Getters/Setter

- (BOOL)noMoreItems {
    return _noMoreItems || (self.loadMoreItemsBlock == nil);
}

#pragma mark - UITableView DataSource

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.items.count == 0) {
        return tableView.bounds.size.height;
    } else if (indexPath.row == self.items.count){
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
            return UITableViewAutomaticDimension;
        } else {
            return [self heightForLoadMoreCellforTable:tableView];
        }
    }
    return NSNotFound;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger itemsCount = self.items.count + (self.noMoreItems ? 0 : 1);
    return MAX(itemsCount, 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (self.items.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellIdentifier];
        if (!cell) {
            cell = [self.class emptyCell];
        }
    } else if (indexPath.row == self.items.count && !self.noMoreItems) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLoadingCellIdentifier];
        if (!cell) {
            cell = [self.class loadingCell];
        }
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[cell.contentView viewWithTag:kLoadingCellActivityTag];
        [activity startAnimating];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.items.count-1){
        if (!self.loadingItems && !self.noMoreItems) {
            self.loadingItems = YES;
            [self loadMore];
        }
    }
}

- (NSArray *)items {
    NSLog(@"Warning! This should be overriden in childrens");
    return _items;
}

#pragma mark - Helpers

- (CGFloat)heightForLoadMoreCellforTable:(UITableView *)tableView {
    static UITableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.class loadingCell];
    });
    return [self calculatedHeightForConfiguredSizingCell:sizingCell forTable:tableView];
}

- (CGFloat)calculatedHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell forTable:(UITableView *)table {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

+ (UITableViewCell *)loadingCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kLoadingCellIdentifier];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor             = [UIColor clearColor];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activity startAnimating];
    activity.translatesAutoresizingMaskIntoConstraints = NO;
    activity.tag                                       = kLoadingCellActivityTag;
    [cell.contentView addSubview:activity];
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(activity);
    [cell.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-10-[activity]-10-|" options:0 metrics:nil views:viewsDict]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:activity attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:activity.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    return cell;
}

+ (UITableViewCell *)emptyCell {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEmptyCellIdentifier];
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    emptyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    emptyLabel.text                                      = @"No items";
    emptyLabel.textColor                                 = [UIColor grayColor];
    emptyLabel.alpha                                     = 0.5;
    emptyLabel.font                                      = [UIFont boldSystemFontOfSize:20];
    [cell.contentView addSubview:emptyLabel];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:emptyLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [cell.contentView addConstraint:[NSLayoutConstraint constraintWithItem:emptyLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:emptyLabel.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    return cell;
}

@end

