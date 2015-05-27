//
//  ViewController.m
//  LRPullTableView
//
//  Created by 甘立荣 on 15/5/27.
//  Copyright (c) 2015年 甘立荣. All rights reserved.
//

#import "ViewController.h"
#import "LRPullTableView.h"

//定义设备屏幕的高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//定义设备屏幕的宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    LRPullTableView *tableView = [[LRPullTableView alloc] init];
    tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    tableView.data = [UIFont familyNames];
    tableView.eventDelegate = self;
    tableView.isMore = YES;
    tableView.isUpLoadMore = YES;
    [self.view addSubview:tableView];
}

//下拉
- (void)pullDown:(LRPullTableView *)tableView {

    [tableView performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0f];
    
}

//上拉
- (void)pullUp:(LRPullTableView *)tableView {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
