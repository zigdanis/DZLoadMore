//
//  MyObject.h
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 02/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyObject : NSObject

@property (nonatomic, assign) NSInteger order;
@property (nonatomic, strong) NSDate *date;

+ (NSArray *)arrayOfItemsFromItem:(MyObject *)item amount:(NSInteger)amount;

@end
