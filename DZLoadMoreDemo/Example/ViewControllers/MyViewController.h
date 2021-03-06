//
//  ViewController.h
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 29/06/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ControllerTypeLoadMoreAndRefresh,
    ControllerTypeOnlyLoadMore,
    ControllerTypeOnlyRefresh,
    ControllerTypeInitiallyEmpty
} ControllerType;

@interface MyViewController : UITableViewController

@property (nonatomic, assign) ControllerType myType;

@end

