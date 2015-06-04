//
//  LRPullTableView.h
//  LRPullTableView
//
//  Created by 甘 立荣 on 13-2-18.
//  Copyright (c) 2013年 甘 立荣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "LRPullTableViewDelegate.h"

@class LRPullTableView;

typedef NS_ENUM(NSInteger, LRTableViewState) {
    LRTableViewStateNormal = 0,
    LRTableViewStateEmpty,
    LRTableViewStateError
};

@interface LRPullTableView : UITableView <EGORefreshTableHeaderDelegate,UITableViewDataSource,UITableViewDelegate>
{
    EGORefreshTableHeaderView *_refreshTableHeaderView;
    BOOL _reloading;
    UIButton *_moreButton;
}

//是否需要下拉刷新列表
@property(nonatomic,assign)BOOL refreshHeader;

@property(nonatomic,assign)LRTableViewState tableState;

@property (nonatomic, copy) NSString *emptyText;

//为tableView创建数据
@property(nonatomic,strong) NSArray *data;

//创建代理
@property(nonatomic,weak)id<LRPullTableViewDelegate> eventDelegate;

//是否还有更多
@property(nonatomic,assign)BOOL isMore;

//是否上拉刷新
@property (nonatomic, assign) BOOL isUpLoadMore;

- (void)doneLoadingTableViewData;

//刷新自身
- (void)refreshData;


@end
