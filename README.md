# DZLoadMore
Infinity scrolling for Loading More items on UITableView with build-in Pull-to-Refresh functionality.

I've getting tyred of adding load more and pull-to-refresh functionality to every project that I'm working on. So I decided to move my code to one single class with 2 nice blocks that will handle loading and refreshing items in the tableview. Also this will help me to stop implementing table's datasource and delegate in single UIViewController subclass.

##Screenshots
<img src=http://i.imgur.com/zQEjGhFl.png> 
<img src=http://i.imgur.com/nbWyMH2l.png>

##Usage

1. Subclass `DZLoadMore` class
2. Implement `-(NSArray *)items` method. You should return your UITableView's model items array on this method.
3. Add UITableView data source protocol methods as below:
```objective-c
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        // Your tableView:cellForRowAtIndexPath: implementation
    }
    ...
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (height == NSNotFound) {
        // Your tableView:heightForRowAtIndexPath: implementation
    }
    return height;
} ``` 
4. In your ViewController subclass: setup and set your UITableView's dataSource property with your newly created class's object.
```objective-c
self.dataSource = [[MyDataSource alloc] init];
self.tableView.dataSource = self.dataSource;```
5. If you need **load more** functionality: set `loadMoreItemsBlock` property for your dataSource.
```objective-c
__weak typeof(self) weakSelf = self;
self.dataSource.loadMoreItemsBlock = ^(id lastItem, BOOLCallback block) {
    MyObject *object = (MyObject *)lastItem;
    // Asyncronously load new items from your backend. You should provide fininsh block that should have BOOL value indicating if server doesn't have any more items to load
    [weakSelf loadItemsFromItem:object finishBlock:^(BOOL noMoreItems) {
        block(noMoreItems); // You should invoke this block after you've updated your dataSource with new values
        [weakSelf.tableView reloadData];
    }];
};```
6. If you need **pull-to-refresh** functionality: set `refreshContentBlock` property for your dataSource and setup your UITableViewController's `refreshControl` property with your dataSource as target and `-refreshContent` selector.
```objective-c
self.refreshControl = [[UIRefreshControl alloc] init];
[self.refreshControl addTarget:self.dataSource action:@selector(refreshContent) forControlEvents:UIControlEventValueChanged];
__weak typeof(self) weakSelf = self;
self.dataSource.refreshContentBlock = ^(BOOLCallback block) {
    // Asyncronously load new items from your backend. You should provide fininsh block that should have BOOL value indicating if server doesn't have any more items to load
    [weakSelf loadItemsFromItem:nil finishBlock:^(BOOL noMoreItems) {
        [weakSelf.refreshControl endRefreshing]; // Your UITableViewController responsible for invoking -endRefreshing method or UIRefreshControl
        block(noMoreItems); // You should invoke this block after you've updated your dataSource with new values
        [weakSelf.tableView reloadData];
    }];
};```

## Installation

```sh
pod 'ZDLoadMore'```

##License

MIT
