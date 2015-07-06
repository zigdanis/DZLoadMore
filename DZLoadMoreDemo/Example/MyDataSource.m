//
//  MyDataSource.m
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 02/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "MyDataSource.h"
#import "MyObject.h"
#import "MyCell.h"

@interface MyDataSource ()

@property (nonatomic, strong) NSMutableArray *myItems;

@end

@implementation MyDataSource

- (instancetype)init {
    if (self = [super init]) {
        self.myItems = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Logic

- (void)flushItems {
    [self.myItems removeAllObjects];
}

- (void)appendItems:(NSArray *)items {
    [self.myItems addObjectsFromArray:items];
}

#pragma mark - Delegate/DataSource

- (NSArray *)items {
    return self.myItems;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(MyCell.class)];
        [self configureCell:(MyCell *)cell atIndexPath:indexPath];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (height == NSNotFound) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0f) {
            height = UITableViewAutomaticDimension;
        } else {
            height = [self heightForMyCellAtIndexPath:indexPath forTable:tableView];
        }
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)heightForMyCellAtIndexPath:(NSIndexPath *)indexPath forTable:(UITableView *)table {
    static MyCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [table dequeueReusableCellWithIdentifier:NSStringFromClass(MyCell.class)];
    });
    [self configureCell:sizingCell atIndexPath:indexPath];
    return [self calculatedHeightForConfiguredSizingCell:sizingCell forTable:table];
}

#pragma mark - Helpers

- (void)configureCell:(MyCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MyObject *object = self.myItems[indexPath.row];
    [cell setupWithItem:object];
}

@end
