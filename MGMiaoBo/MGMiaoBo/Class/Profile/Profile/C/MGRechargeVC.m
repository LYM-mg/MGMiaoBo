/*
    @header MGRechargeVC.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/20.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGRechargeVC.h"
#import "MGRechargeHeadView.h"
#import "HomeWebVC.h"
#import "MGRechargeCell.h"

@interface MGRechargeVC ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property (nonatomic,weak) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSArray *dataArr;

@end

@implementation MGRechargeVC
#pragma mark - lazy
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Recharge.plist" ofType:nil]];
    }
    return _dataArr;
}

#pragma mark - life
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMainView];
}

- (void)setUpMainView {
    weakSelf(self);
    self.navigationItem.title = @"充值";
    
    MGRechargeHeadView *headerView = [MGRechargeHeadView rechargeHeadView];
    [self.view addSubview:headerView];
//    headerView.frame = CGRectMake(0, 0, MGScreen_Width, 71);
    [headerView setMemberComplete:^{
        [weakself.navigationController pushViewController:[[HomeWebVC alloc] initWithNavigationTitle:@"我的头衔" withUrlStr:@"http://live.9158.com/Privilege?useridx=63417164&Random=7"] animated:YES];
    }];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), MGScreen_Width, self.view.height - headerView.height)];
    tableView.height = MGScreen_Height - tableView.origin.y;
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.view addSubview:tableView];
    _tableView = tableView;
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGRechargeCell *cell = [MGRechargeCell cellWithTableView:tableView];
    
    cell.dict =  self.dataArr[indexPath.row];
   
    return cell;
}


@end
