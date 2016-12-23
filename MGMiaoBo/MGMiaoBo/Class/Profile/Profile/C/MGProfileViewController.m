/*
    @header MGProfileViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGProfileViewController.h"
#import "MGSettingViewController.h"
#import "MGProfileHeaderView.h"
#import "HomeWebVC.h"

#import "MGRechargeVC.h"
#import "MGMyTaskViewController.h"

#import "MGFansViewController.h"
#import "MGFollowViewController.h"

#define HeadViewH 265
#define HeadViewMinH 64

@interface MGProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

/** tableView */
@property (nonatomic,weak) UITableView *mineTableView;

/** 数据源数组 */
@property (nonatomic,strong) NSArray *mineDataArr;

/** 最初的偏移量 */
@property (nonatomic,assign) CGFloat orignOffsetY;

/** 导航栏标题 */
@property (nonatomic,weak) UILabel *titleLabel;

/** 头部 */
@property (nonatomic,weak) MGProfileHeaderView *headerView;

@end

@implementation MGProfileViewController
static NSString *const KMGMineCell = @"KMGMineCell";

- (NSArray *)mineDataArr {
    if (_mineDataArr == nil) {
        _mineDataArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MineData.plist" ofType:nil]];
    }
    return _mineDataArr;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [self.navigationController.navigationBar setBackgroundColor:KeyColor];
    UIImage *image = [UIImage imageWithColor:KeyColor size:CGSizeMake(MGScreen_Width, HeadViewMinH)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBarTintColor:KeyColor];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人中心";
    
    [self setup];
}

- (void)setup {
    [self setupMainView];
    _orignOffsetY = -(HeadViewH);
    // 设置额外滚动的区域
//    self.mineTableView.contentInset = UIEdgeInsetsMake(HeadViewH, 0, 0, 0);
    // 不需要自动插入边距
    self.automaticallyAdjustsScrollViewInsets = NO;
}

/**
 *  初始化主界面
 */
- (void)setupMainView {
    weakSelf(self);
    MGProfileHeaderView *headerView = [MGProfileHeaderView headerView];
    self.headerView = headerView;
    [headerView setTopViewClickComplete:^{
        [weakself.navigationController pushViewController:[UIStoryboard storyboardWithName:@"UserInfo" bundle:nil].instantiateInitialViewController animated:YES];
    }];
    [headerView setLeftViewClickComplete:^{
        [weakself.navigationController pushViewController:[[MGFollowViewController alloc] init] animated:YES];
    }];
    [headerView setCenterViewClickComplete:^{
        [weakself.navigationController pushViewController:[[MGFansViewController alloc] init] animated:YES];
    }];
    [headerView setRightViewClickComplete:^{
        
    }];
    
    
    
    UITableView *mineTableView = ({
        UITableView *mineTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        mineTableView.dataSource = self;
        mineTableView.delegate = self;
        [self.view addSubview:mineTableView];
        mineTableView.contentInset = UIEdgeInsetsMake(0, 0, 8*DefaultMargin, 0);
        [mineTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:KMGMineCell];
        mineTableView.tableHeaderView = headerView;
        mineTableView;
    });
    self.mineTableView = mineTableView;
}

#pragma mark - scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;
    
    // 计算下当前最新的偏移量与最初的偏移量的差值
    CGFloat dealt = offsetY - _orignOffsetY;
//    NSLog(@"%f-%f=%f",offsetY,_orignOffsetY,dealt);
    CGFloat pp = HeadViewH - dealt;
    self.headerView.containViewHCon.constant = HeadViewH+pp;
    if (pp <= 1.0) {
        self.headerView.containViewHCon.constant = HeadViewH;
    }
    
    // 处理导航栏的透明度
    if (offsetY<0) {
        offsetY = 0;
    }
    CGFloat alpha = (offsetY) / (HeadViewH-HeadViewMinH-90);
    if (alpha >= 1.0) {
        alpha = 0.99;
    }
    
    [self.navigationController setNavigationBarHidden:(alpha == 0) animated:YES];
    // 设置背景颜色
    UIColor *color = MGRGBAColor(216, 41, 116, alpha);
    UIImage *image = [UIImage imageWithColor:color size:CGSizeMake(MGScreen_Width, HeadViewMinH)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
}


#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return DefaultMargin*1.5; // 默认10
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return DefaultMargin;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.mineDataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = self.mineDataArr[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGMineCell];
    NSArray *tempArr = self.mineDataArr[indexPath.section];
    cell.imageView.image = [UIImage imageNamed:tempArr[indexPath.row][@"icon"]];
    cell.textLabel.text = tempArr[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            if (0 == indexPath.row) {
                [self.navigationController pushViewController:[[MGRechargeVC alloc] init] animated:YES];
            }else if (1 == indexPath.row) {
                [self.navigationController pushViewController:[[MGRechargeVC alloc] init] animated:YES];
            }else if (2 == indexPath.row) {
                [self.navigationController pushViewController:[[MGMyTaskViewController alloc] init] animated:YES];
            }
            break;
            
        case 1:
        {
            NSString *urlStr = nil;
            NSString *title = nil;
            if (0 == indexPath.row) {
                urlStr = @"https://live.9158.com/Pay/ExChange?useridx=63417164&chkcode=bec82e95877a865e6c880f307b4c5a06&Random=2";
                title = @"兑换";
            }else if (1 == indexPath.row) {
                urlStr = @"http://live.9158.com/GameCenter/Gameindex?curuseridx=63417164&usertoken=A92PE3GZ6UY3UEU&logintype=qq&devtype=2&Random=4";
                title = @"游戏中心";
            }else if (2 == indexPath.row) {
                urlStr = @"http://weiqianjin.cn/?qid=101";
                title = @"首页";
            }
            [self.navigationController pushViewController:[[HomeWebVC alloc] initWithNavigationTitle:title withUrlStr:urlStr] animated:YES];
        }
            break;
            
        case 2:
            [self.navigationController pushViewController:[[MGSettingViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
}

@end
