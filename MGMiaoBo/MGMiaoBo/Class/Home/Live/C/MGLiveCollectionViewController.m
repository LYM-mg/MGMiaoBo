//
//  MGLiveCollectionViewController.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGLiveCollectionViewController.h"
#import "MGLiveFlowLayout.h"
#import "MGRefreshGifHeader.h"
#import "MGHotLiveViewCell.h"
#import "MGUserView.h"

#import <Masonry/Masonry.h>
#import "HomeWebVC.h"

@interface MGLiveCollectionViewController ()
/** 用户信息 */
@property (nonatomic, weak) MGUserView *userView;
@end

@implementation MGLiveCollectionViewController

static NSString * const KMGHotLiveViewCell = @"KMGHotLiveViewCell";

#pragma mark - lazy
- (MGUserView *)userView{
    if (_userView == nil) {
        MGUserView *userView = [MGUserView userView];
        [self.collectionView addSubview:userView];
        _userView = userView;
        
        [userView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(0);
            make.width.mas_equalTo(MGScreen_Width);
            make.height.mas_equalTo(MGScreen_Height);
        }];
        
        self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        [userView setCloseBlock:^{
           [UIView animateWithDuration:0.9 animations:^{
               self.userView.transform = CGAffineTransformMakeScale(0.01, 0.01);
           } completion:^(BOOL finished) {
               [self.userView removeFromSuperview];
               self.userView = nil;
           }];
        }];
    }
    return _userView;
}

#pragma mark - 控制器的生命周期
- (instancetype)init {
    self = [super initWithCollectionViewLayout:[[MGLiveFlowLayout alloc] init]];
    self.collectionView.delegate = self;
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [self.navigationController.navigationBar setHeight:0.9];
//    [self.navigationController.navigationBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.collectionView.origin = CGPointZero;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [self.navigationController.navigationBar setHeight:44];
//    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentIndex = 1;
    self.navigationItem.title = @"直播";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.pagingEnabled = YES;
    [self.collectionView registerClass:[MGHotLiveViewCell class] forCellWithReuseIdentifier:KMGHotLiveViewCell];
    
    [self setupRefresh];
}

#pragma mark - 刷新
- (void)setupRefresh{
    weakSelf(self);
    MGRefreshGifHeader *header = [MGRefreshGifHeader headerWithRefreshingBlock:^{
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        weakself.currentIndex--;
        if (weakself.currentIndex <= 0) {
            weakself.currentIndex = 0;
        }
        [weakself.collectionView reloadData];
    }];
    header.stateLabel.hidden = NO;
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [header setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_header = header;
    
    
    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingBlock:^{
        [weakself.collectionView.mj_header endRefreshing];
        [weakself.collectionView.mj_footer endRefreshing];
        weakself.currentIndex++;
        if (weakself.currentIndex >= weakself.lives.count - 1) {
            weakself.currentIndex = weakself.lives.count - 1;
        }
        [weakself.collectionView reloadData];
    }];
    footer.stateLabel.hidden = NO;
    [footer setTitle:@"下拉切换另一个主播" forState:MJRefreshStatePulling];
    [footer setTitle:@"下拉切换另一个主播" forState:MJRefreshStateIdle];
    self.collectionView.mj_footer = footer;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickUser:) name:kMGUserClickNotication object:nil];
}

#pragma mark - clickUser
- (void)clickUser:(NSNotification *)notify
{
    if (notify.userInfo[@"user"] != nil) {
        MGUser *user = notify.userInfo[@"user"];
        self.userView.user = user;
        [UIView animateWithDuration:0.5 animations:^{
            self.userView.transform = CGAffineTransformIdentity;
        }];
    }
}

#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return self.lives.count;
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    weakSelf(self);
    
    MGHotLiveViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMGHotLiveViewCell forIndexPath:indexPath];
    cell.parentVc = self;
    cell.live = self.lives[self.currentIndex];
    
    NSUInteger relateIndex = self.currentIndex;
    if (self.currentIndex + 1 == self.lives.count) {
        relateIndex = 0;
    }else{
        relateIndex += 1;
    }
    cell.relateLive = self.lives[relateIndex];
    [cell setClickRelatedLive:^{
        weakself.currentIndex += 1;
        if (weakself.currentIndex == weakself.lives.count) {
            weakself.currentIndex -= 1;
        }
        [weakself.collectionView reloadData];
    }];
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView  didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    self.currentIndex = indexPath.item;
//}

#pragma mark <UICollectionViewDelegate>

- (void)addObserverNotification {
    weakSelf(self);
    
    [[NSNotificationCenter defaultCenter] addObserverForName:kMGGiftViewClickNotication object:self queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [weakself.navigationController pushViewController:[[HomeWebVC alloc] initWithNavigationTitle:@"粉丝奉献榜" withUrlStr:@"http://live.9158.com/Rank/UserWeekRank?useridx=63411791&showtype=2&curuseridx=63417164&Random=7"] animated:YES];
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
