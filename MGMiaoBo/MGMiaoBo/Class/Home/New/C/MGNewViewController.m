/*
    @header MGNewViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGNewViewController.h"
#import "MGNavController.h"
#import "MGNewFlowLayout.h"
#import "MGAnchorCell.h"
#import "MGUser.h"

#import "MGRefreshGifHeader.h"
#import "MGLiveCollectionViewController.h"
#import "MGHotLive.h"

@interface MGNewViewController ()
/** 最新主播列表 */
@property(nonatomic, strong) NSMutableArray *anchors;
/** 当前页 */
@property(nonatomic, assign) NSUInteger currentPage;
/** NSTimer */
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation MGNewViewController

static NSString * const KMGAnchorCell = @"KMGAnchorCell";

#pragma mark - lazy
- (NSMutableArray *)anchors{
    if (!_anchors) {
        _anchors = [NSMutableArray array];
    }
    return _anchors;
}

#pragma mark - init
- (instancetype)init {
    return [super initWithCollectionViewLayout:[[MGNewFlowLayout alloc] init]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 首先自动刷新一次
    [self autoRefresh];
    // 然后开启每3分钟自动更新
    _timer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(autoRefresh) userInfo:nil repeats:YES];
}
- (void)autoRefresh
{
//    NSLog(@"刷新最新主播界面");
    [self.collectionView.mj_header beginRefreshing];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    self.navigationController.hidesBarsOnSwipe = YES;
}

- (void)setup {
    self.view.backgroundColor = [UIColor grayColor];
    // 默认当前页从1开始的
    self.currentPage = 1;
    
    [self.collectionView registerClass:[MGAnchorCell class] forCellWithReuseIdentifier:KMGAnchorCell];
    
    if ([UIDevice currentDevice].systemVersion.doubleValue >= 9.0) {
        // 创建长按手势
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongGesture:)];
        [self.collectionView addGestureRecognizer:longPressGesture];
    }

    // 设置header和footer
    self.collectionView.mj_header = [MGRefreshGifHeader headerWithRefreshingBlock:^{
        self.currentPage = 1;
        self.anchors = [NSMutableArray array];
        [self getAnchorsList];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        self.currentPage++;
        [self getAnchorsList];
    }];
    self.collectionView.mj_footer.hidden = YES;
    self.collectionView.mj_footer.automaticallyHidden = YES;
    [self.collectionView.mj_header beginRefreshing];
}

#pragma mark -  获取数据
- (void)getAnchorsList
{
    [[MGNetworkTool shareNetworkTool] GET:[NSString stringWithFormat:@"http://live.9158.com/Room/GetNewRoomOnline?page=%ld", self.currentPage] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        NSString *statuMsg = responseObject[@"msg"];
        if ([statuMsg isEqualToString:@"fail"]) { /// “下拉数据已经加载完毕, 没有更多数据了”
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            [self showHint:@"暂时没有更多最新数据"];
            // 恢复当前页
            self.currentPage--;
        }else{  /// “上拉”
//            [responseObject[@"data"][@"list"] writeToFile:@"/Users/apple/Desktop/user.plist" atomically:YES];
            NSArray *result = [MGUser mj_objectArrayWithKeyValuesArray:responseObject[@"data"][@"list"]];
            if (result.count) {
                self.collectionView.mj_footer.hidden = NO;
                [self.anchors addObjectsFromArray:result];
                [self.collectionView reloadData];
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        self.currentPage--;
        [self showHint:@"网络异常"];
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.anchors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MGAnchorCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMGAnchorCell forIndexPath:indexPath];
    cell.user = self.anchors[indexPath.item];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    MGLiveCollectionViewController *liveVc = [[MGLiveCollectionViewController alloc] init];
    NSMutableArray *array = [NSMutableArray array];
    for (MGUser *user in self.anchors) {
        MGHotLive *live = [[MGHotLive alloc] init];
        live.bigpic = user.photo;
        live.myname = user.nickname;
        live.smallpic = user.photo;
        live.gps = user.position;
        live.useridx = user.useridx;
        live.allnum = arc4random_uniform(2000);
        live.flv = user.flv;
        [array addObject:live];
    }
    liveVc.lives = array;
    liveVc.currentIndex = indexPath.item;
    [self presentViewController:[[MGNavController alloc] initWithRootViewController:liveVc] animated:YES completion:nil];
}

/// 动画
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//        cell.transform = CGAffineTransformMakeScale(0.2, 0.2);
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:2 options:UIViewAnimationOptionRepeat animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            cell.transform = CGAffineTransformIdentity;
        }];
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell {
    cell.transform = CGAffineTransformMakeScale(0.3, 0.3);
}

#pragma mark -实现下面这两个方法
// 返回YES允许其item移动
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    // 1、取出源item数据
    id objc = [self.anchors objectAtIndex:sourceIndexPath.item];
    // 2、从资源数组中移除该数据
    [self.anchors removeObject:objc];
    // 3、将数据插入到资源数组中的目标位置上
    [self.anchors insertObject:objc atIndex:destinationIndexPath.item];
}

#pragma mark - longPress手势
- (void)handleLongGesture:(UILongPressGestureRecognizer *)lpGesture{
    switch(lpGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *selectedIndexPath =  [self.collectionView indexPathForItemAtPoint:[lpGesture locationInView:lpGesture.view]];
            /** 在MGCollectionController中发现一处崩溃的地方。 长按cells间空白的地方，拖动程序就会崩溃
             *
             *  解法1：
             */
            // 当移动空白处时，indexPath是空的，移除nil的index时就会崩溃。直接返回
            if (selectedIndexPath == nil){
                return;
            }
        
            [self.collectionView beginInteractiveMovementForItemAtIndexPath:selectedIndexPath];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            [self.collectionView updateInteractiveMovementTargetPosition:[lpGesture locationInView:self.collectionView]];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.collectionView endInteractiveMovement];
        }
        default:
            [self.collectionView cancelInteractiveMovement];
    }
}


@end
