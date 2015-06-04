//
//  RCBaseTableViewDelegate.h
//  MiDou
//
//  Created by 甘 立荣 on 14-6-9.
//  Copyright (c) 2014年 www.midou8.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LRPullTableView;

@protocol LRPullTableViewDelegate <NSObject>

@optional

//下拉
- (void)pullDown:(LRPullTableView *)tableView;

//上拉
- (void)pullUp:(LRPullTableView *)tableView;

//选中一个cell
- (void)tableView:(LRPullTableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
