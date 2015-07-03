//
//  MyObject.m
//  DZLoadMoreDemo
//
//  Created by Danis Ziganshin on 02/07/15.
//  Copyright (c) 2015 Danis Ziganshin. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

+ (NSArray *)arrayOfItemsFromItem:(MyObject *)item amount:(NSInteger)amount {
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i=item.order+1; i<=item.order+amount; i++) {
        MyObject *object = [[MyObject alloc] init];
        object.order = i;
        NSTimeInterval randomInterval = arc4random() % (24*60*60) - (12*60*60);
        NSDate *randomDate = [[NSDate date] dateByAddingTimeInterval:randomInterval];
        object.date = randomDate;
        [array addObject:object];
    }
    return array;
}

@end
