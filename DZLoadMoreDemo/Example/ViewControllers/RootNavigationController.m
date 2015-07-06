//
//  RootNavigationController.m
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 03/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "RootNavigationController.h"
#import "MyViewController.h"

@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

#pragma mark - Table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:NSStringFromClass(MyViewController.class) sender:indexPath];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MyViewController *viewController = (MyViewController *)segue.destinationViewController;
    NSIndexPath *indexPath = (NSIndexPath *)sender;
    switch (indexPath.row) {
        case 0:
            viewController.myType = ControllerTypeLoadMoreAndRefresh;
            break;
        case 1:
            viewController.myType = ControllerTypeOnlyLoadMore;
            break;
        case 2:
            viewController.myType = ControllerTypeOnlyRefresh;
            break;
        case 3:
            viewController.myType = ControllerTypeInitiallyEmpty;
        default:
            break;
    }
}

@end
