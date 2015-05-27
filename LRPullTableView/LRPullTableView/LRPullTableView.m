//
//  LRPullTableView.m
//  LRPullTableView
//
//  Created by 甘 立荣 on 13-2-18.
//  Copyright (c) 2013年 甘 立荣. All rights reserved.
//

#import "LRPullTableView.h"

//定义设备屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//定义设备屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define TIP_COLOR [UIColor colorWithRed:157.0/255.0 green:162.0/255.0 blue:178.0/255.0 alpha:1.0]
#define BaseTableViewActivityTag 10000

@implementation LRPullTableView

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self _initBaseView];
    }
    
    return self;
    
}

//xib创建视图的时候初始化
- (void)awakeFromNib{
    [self _initBaseView];
}

//初始化子视图
- (void)_initBaseView{
    
    _refreshTableHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.bounds.size.height, self.frame.size.width, self.bounds.size.height)];
    
    _refreshTableHeaderView.backgroundColor = [UIColor clearColor];
    _refreshTableHeaderView.delegate = self;
    [self addSubview:_refreshTableHeaderView];
    
    self.dataSource = self;
    self.delegate = self;
    self.refreshHeader = YES;
    
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor clearColor];
    bgView.tag = 50008;
    bgView.frame = CGRectMake(0, (self.frame.size.height - 180)/2, ScreenWidth, 180);
    bgView.hidden = YES;
    [self addSubview:bgView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((ScreenWidth - 150)/2, 0, 150, 150);
    imageView.image = [UIImage imageNamed:@"empty_record.png"];
    [bgView addSubview:imageView];
    
    UILabel *tipTextLabel = [[UILabel alloc] init];
    tipTextLabel.backgroundColor = [UIColor clearColor];
    tipTextLabel.frame = CGRectMake(imageView.frame.origin.x, 120, 150, 30);
    tipTextLabel.numberOfLines = 3;
    tipTextLabel.font = [UIFont systemFontOfSize:12.0f];
    tipTextLabel.tag = 50009;
    tipTextLabel.textColor = TIP_COLOR;
    tipTextLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:tipTextLabel];
    
}

- (void)setIsUpLoadMore:(BOOL)isUpLoadMore{

    _isUpLoadMore = isUpLoadMore;
    
    if (_isUpLoadMore) {
        
        if (!_moreButton) {
            
            _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
            _moreButton.backgroundColor = [UIColor clearColor];
            _moreButton.frame = CGRectMake(0, 0, ScreenWidth, 40);
            _moreButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
            [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
            [_moreButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_moreButton addTarget:self action:@selector(loadMoreData)
                  forControlEvents:UIControlEventTouchUpInside];
            
            UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [activity stopAnimating];
            activity.frame = CGRectMake(90, 10, 20, 20);
            activity.tag = BaseTableViewActivityTag;
            [_moreButton addSubview:activity];
        }
        
        self.tableFooterView = _moreButton;
        
    } else {
    
        [_moreButton removeFromSuperview];
        self.tableFooterView = nil;
    
    }

}

- (void)setRefreshHeader:(BOOL)refreshHeader{
    
    _refreshHeader = refreshHeader;
    if (_refreshHeader) {
        [self addSubview:_refreshTableHeaderView];
    }else{
        if ([_refreshTableHeaderView superview]) {
            [_refreshTableHeaderView removeFromSuperview];
        }
    }
}

//刷新自身
- (void)refreshData{
    
    [_refreshTableHeaderView initLoading:self];
    
}

//点击上拉加载数据
- (void)loadMoreData{
    //NSLog(@"加载更多数据");
    if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
        [self.eventDelegate pullUp:self];
        [self _startLoadMoreData];
    }
    
}

- (void)reloadData{
    [super reloadData];
    [self _stopLoadMoreData];
}

- (void)setTableState:(LRTableViewState)tableState{
    if (_tableState != tableState) {
        _tableState = tableState;
    }

    UIView *bgView = [self viewWithTag:50008];
    UILabel *textLabel = (UILabel *)[bgView viewWithTag:50009];
    if (tableState == LRTableViewStateNormal) {
        bgView.hidden = YES;
    } else if (tableState == LRTableViewStateEmpty && _data.count == 0) {
        bgView.hidden = NO;
        textLabel.text = _emptyText;
    } else if (tableState == LRTableViewStateError && _data.count == 0) {
        bgView.hidden = NO;
        textLabel.text = @"加载失败\n下拉刷新试试吧!";
    }
    [self reloadData];
}

//开始加载更多数据
- (void)_startLoadMoreData{
    
    [_moreButton setTitle:@"正在加载..." forState:UIControlStateNormal];
    _moreButton.enabled = NO;
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)
    [_moreButton viewWithTag:BaseTableViewActivityTag];
    [activity startAnimating];
}


//停止加载更多数据
- (void)_stopLoadMoreData{
    
    if (self.data.count > 0) {
        
        _moreButton.hidden = NO;
        [_moreButton setTitle:@"上拉加载更多..." forState:UIControlStateNormal];
        _moreButton.enabled = YES;
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *) [_moreButton viewWithTag:BaseTableViewActivityTag];
        [activity stopAnimating];
        
        if (!self.isMore && _isUpLoadMore) {
            
            [_moreButton setTitle:@"加载完成" forState:UIControlStateNormal];
            _moreButton.enabled = NO;
            _moreButton.hidden = YES;
            self.isUpLoadMore = NO;
            
        }
        
    } else {
        _moreButton.hidden = YES;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.data.count;
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = _data[indexPath.row];
    return cell;
}

//选中一个cell的时候
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.eventDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.eventDelegate tableView:self didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshTableHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
//滑动时实时调用此方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshTableHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

//手指停止拖拽的时候调用
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshTableHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    if (!self.isMore) {
        return;
    }
	float offset = scrollView.contentOffset.y;
    float contentHeight = scrollView.contentSize.height;
    float sub = contentHeight - offset;
    
    //当offset偏移量滑到底部时,差值是scrollview的高度
    if (scrollView.frame.size.height - sub > 30) {
        [self _startLoadMoreData];
        if ([self.eventDelegate respondsToSelector:@selector(pullUp:)]) {
            [self.eventDelegate pullUp:self];
        }
    }
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
    //[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
    if ([self.eventDelegate respondsToSelector:@selector(pullDown:)]) {
        [self.eventDelegate pullDown:self];
    }
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
