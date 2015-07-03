//
//  ViewController.m
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 29/06/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "MyViewController.h"
#import "MyDataSource.h"
#import "MyObject.h"

#define kDefaultBatchForLoadMoreItems 20
#define kMaxNumberOfItems             100

@interface MyViewController ()

@property (nonatomic, strong) MyDataSource *dataSource;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTableDataSource];
    [self setupNavBarTitle];
}

#pragma mark - Setup

- (void)setupTableDataSource {
    self.dataSource = [[MyDataSource alloc] init];
    
    self.tableView.delegate        = self.dataSource;
    self.tableView.dataSource      = self.dataSource;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    if (self.myType == ControllerTypeLoadMoreAndRefresh ||
        self.myType == ControllerTypeOnlyLoadMore ||
        self.myType == ControllerTypeInitiallyEmpty) {
        [self setupLoadMoreBlock];
    }
    if (self.myType == ControllerTypeLoadMoreAndRefresh ||
        self.myType == ControllerTypeOnlyRefresh ||
        self.myType == ControllerTypeInitiallyEmpty) {
        [self setupRefreshBlock];
    }
    if (self.myType != ControllerTypeInitiallyEmpty) {
        [self setupInitalItems];
    }
}

- (void)setupNavBarTitle {
    switch (self.myType) {
        case ControllerTypeLoadMoreAndRefresh:
            self.navigationItem.title = @"Load More and Refresh";
            break;
        case ControllerTypeOnlyRefresh:
            self.navigationItem.title = @"Only Refresh";
            break;
        case ControllerTypeOnlyLoadMore:
            self.navigationItem.title = @"Only Load More";
            break;
        case ControllerTypeInitiallyEmpty:
            self.navigationItem.title = @"Initially Empty";
            break;
        default:
            break;
    }
}

- (void)setupLoadMoreBlock {
    __weak typeof(self) weakSelf = self;
    self.dataSource.loadMoreItemsBlock = ^(id lastItem, BOOLCallback block) {
        MyObject *object = (MyObject *)object;
        [weakSelf loadItemsFromItem:lastItem reloading:NO finishBlock:^(BOOL noMoreItems) {
            if (block) {
                block(noMoreItems);
            }
            [weakSelf.tableView reloadData];
        }];
    };
}

- (void)setupRefreshBlock {
    __weak typeof(self) weakSelf = self;
    self.dataSource.refreshContentBlock = ^(BOOLCallback block) {
        [weakSelf loadItemsFromItem:nil reloading:YES finishBlock:^(BOOL noMoreItems) {
            [weakSelf.refreshControl endRefreshing];
            if (block) {
                block(noMoreItems);
            }
            [weakSelf.tableView reloadData];
        }];
    };
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self.dataSource action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
}

- (void)setupInitalItems {
    NSArray *items = [MyObject arrayOfItemsFromItem:nil amount:30];
    [self.dataSource appendItems:items];
}

#pragma mark - Logic

- (void)loadItemsFromItem:(MyObject *)lastItem reloading:(BOOL)reloading finishBlock:(BOOLCallback)finishBlock {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *items = nil;
        if (lastItem.order < kMaxNumberOfItems) {
            items = [MyObject arrayOfItemsFromItem:lastItem amount:kDefaultBatchForLoadMoreItems];
        }
        if (reloading) {
            [self.dataSource flushItems];
        }
        [self.dataSource appendItems:items];
        BOOL noMoreItems = items.count < kDefaultBatchForLoadMoreItems;
        if (finishBlock) {
            finishBlock(noMoreItems);
        }
    });
}

@end
