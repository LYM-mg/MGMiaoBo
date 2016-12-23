/*
    @header MGHotViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGHotViewController.h"
#import "HomeWebVC.h"
#import "MGLiveCollectionViewController.h"
#import "MGNavController.h"

#import "MGHotLiveCell.h"
#import "MGHotLive.h"
#import "MGHotADCell.h"
#import "MGHotAD.h"

@interface MGHotViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *hotTableView;
}
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** 直播 */
@property(nonatomic, strong) NSMutableArray *lives;
/** 头部数据广告 */
@property(nonatomic, strong) NSMutableArray *topADS;

/** 记录上一次的偏移量 */
@property (nonatomic, assign) CGFloat lastOffsetY;

@end

@implementation MGHotViewController

static NSString * const KMGHotLiveCell = @"KMGHotLiveCell";
static NSString * const KMGHotADCell = @"KMGHotADCell";

#pragma mark - lazy
- (NSMutableArray *)lives
{
    if (!_lives) {
        _lives = [NSMutableArray array];
    }
    return _lives;
}

- (NSMutableArray *)topADS{
    if (!_topADS) {
        _topADS = [NSMutableArray array];
    }
    return _topADS;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMainView];
}

- (void)setupMainView {
    weakSelf(self);
    /**
     *  tableView
     */
    hotTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    hotTableView.dataSource = self;
    hotTableView.delegate = self;
    hotTableView.backgroundColor = [UIColor grayColor];
    [hotTableView registerNib:[UINib nibWithNibName:NSStringFromClass([MGHotLiveCell class]) bundle:nil] forCellReuseIdentifier:
     KMGHotLiveCell];
    [hotTableView registerClass:[MGHotADCell class] forCellReuseIdentifier:KMGHotADCell];
    [self.view addSubview:hotTableView];
    
    /**
     *  刷新
     */
    self.currentPage = 1;
    hotTableView.mj_header = [MGRefreshGifHeader headerWithRefreshingBlock:^{
        self.lives = [NSMutableArray array];
        self.currentPage = 1;
        // 获取顶部的广告
        [weakself getHotTopAD];
        [weakself getHotLiveList];
    }];
    
    hotTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        weakself.currentPage++;
        [weakself getHotLiveList];
    }];
    hotTableView.mj_footer.automaticallyHidden = YES;
    
    [hotTableView.mj_header beginRefreshing];
    hotTableView.tableFooterView = [[UIView alloc] init];
    hotTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - 数据
- (void)getHotTopAD
{
    [self.topADS removeAllObjects];
    [[MGNetworkTool shareNetworkTool] GET:@"http://live.9158.com/Living/GetAD" parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *result = responseObject[@"data"];
        if ([self isNotEmpty:result]) {
            self.topADS = [MGHotAD mj_objectArrayWithKeyValuesArray:result];
            [hotTableView reloadData];
        }else{
            [self showHint:@"网络异常，请求数据失败"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self showHint:@"网络异常"];
    }];
}

- (void)getHotLiveList
{
    [[MGNetworkTool shareNetworkTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Fans/GetHotLive?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject==nil) return;

        [hotTableView.mj_header endRefreshing];
        [hotTableView.mj_footer endRefreshing];
        NSArray *result = [MGHotLive mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
        if ([self isNotEmpty:result]) {
            [self.lives addObjectsFromArray:result];
            [hotTableView reloadData];
        }else{
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [hotTableView.mj_header endRefreshing];
        [hotTableView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
}


#pragma mark - TableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // +1的1是 -> 图片轮播器
    return self.lives.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 120;
    }
    return 465;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    weakSelf(self);
    if (indexPath.row == 0) {
        MGHotADCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGHotADCell];
        if (self.topADS.count) {
            cell.topADs = self.topADS;
            
            // 图片轮播器点击回调
            [cell setImageClickBlock:^(MGHotAD *topAD) {
                if (topAD.link.length) {
                    HomeWebVC *webVc = [[HomeWebVC alloc] initWithNavigationTitle:topAD.title withUrlStr:topAD.link];
                    [weakself.navigationController pushViewController:webVc animated:YES];
                }
            }];
        }
        return cell;
    }
    
    MGHotLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGHotLiveCell];
    if (self.lives.count) {
        MGHotLive *live = self.lives[indexPath.row-1];
        cell.live = live;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MGLiveCollectionViewController *liveVc = [[MGLiveCollectionViewController alloc] init];
    liveVc.lives = self.lives;
    liveVc.currentIndex = indexPath.row-1;
    [self presentViewController:[[MGNavController alloc] initWithRootViewController:liveVc] animated:YES completion:nil];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        [self test:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        self.lastOffsetY = [self test:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        self.lastOffsetY = [self test:scrollView];
    }
}

- (CGFloat)test:(UIScrollView *)scrollView  {
    CGFloat currentOffsetY = scrollView.contentOffset.y;
    
    CGFloat delta = currentOffsetY - self.lastOffsetY;
    
    if (delta > 30) {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tabBarController.tabBar.hidden = YES;
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.tabBarController.tabBar.hidden = NO;
            [self.navigationController setNavigationBarHidden:NO animated:YES];
        } completion:nil];
    }
    return currentOffsetY;
}
@end

