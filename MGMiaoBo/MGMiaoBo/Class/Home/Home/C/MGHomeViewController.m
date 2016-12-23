/*
    @header MGHomeViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGHomeViewController.h"
#import "MGHotViewController.h"
#import "MGNewViewController.h"
#import "MGCareViewController.h"
#import "HomeWebVC.h"

#import "MGSelectedView.h"

@interface MGHomeViewController ()<UIScrollViewDelegate>
/** 热播 */
@property(nonatomic, weak) MGHotViewController *hotVc;
/** 最新主播 */
@property(nonatomic, weak) MGNewViewController *starVc;
/** 关注主播 */
@property(nonatomic, weak) MGCareViewController *careVc;


/** titlesView */
@property (nonatomic,weak) UIView *titlesView;
/** contentScrollView */
@property (nonatomic,weak) UIScrollView *contentScrollView;
/** 按钮数组 */
@property (nonatomic,strong) NSMutableArray *titleButtons;
/** 选中按钮 */
@property (nonatomic,weak) UIButton *seltitleButton;
/** 标题栏 */
@property (nonatomic,weak) UIView *underLineView;
@end

#pragma mark ========= 常量 ============
CGFloat const titlesViewH = 44;
static CGFloat const maxTitleScale = 1.3;

@implementation MGHomeViewController
#pragma mark ========= 懒加载 ============
- (NSMutableArray *)titleButtons{
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}


#pragma mark - 生命周期
- (void)loadView
{
    UIScrollView *contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    contentScrollView.width = MGScreen_Width;
    contentScrollView.height = MGScreen_Height - contentScrollView.origin.y;
    contentScrollView.backgroundColor = [UIColor whiteColor];
    self.contentScrollView = contentScrollView;
    self.view = contentScrollView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 不需要额外的滚动区域
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 1.初始化标题titlesView
    [self setupTitlesView];
    
    // 2.初始化标题ContentlscrollView
    [self setupContentlscrollView];
    
    // 3.初始化所有的子控制器
    [self setupAllChildViewController];
    
    // 4.添加所有标题按钮
    [self setupAllTitleButton];
    
    // 5.基本设置navItem
    [self setupNavItem];
    
    // 监听点击"去看最热主播"
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toSeeHotZone) name:kMGToSeeHotZoneNotification object:nil];
}

- (void)toSeeHotZone {
    [self titleBtnClick:self.titlesView.subviews[0]];
}

#pragma mark - ========= 初始化标题titlesView ============
// 1.初始化标题titlesView
- (void)setupTitlesView{
    UIView *titlesView = [[UIView alloc] initWithFrame:self.navigationController.navigationBar.bounds];
    titlesView.x = 45;
    titlesView.width = MGScreen_Width - 45 * 2;
    self.navigationItem.titleView = titlesView;
    self.titlesView = titlesView;
}

// 添加所有标题按钮
- (void)setupAllTitleButton{
    CGFloat buttonW = self.titlesView.width/self.childViewControllers.count;
    CGFloat buttonH = titlesViewH;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    NSInteger count = self.childViewControllers.count;
    for (int i = 0; i<count; i++) {
        UIButton *titleBtn = [[UIButton alloc] init];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        // 绑定tag
        titleBtn.tag = i;
        // 设置尺寸
        buttonX = i * buttonW;
        titleBtn.frame = CGRectMake( buttonX, buttonY, buttonW, buttonH);
        // 设置文字
        [titleBtn setTitle:self.childViewControllers[i].title forState:UIControlStateNormal];
        
        [titleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        // 监听
        [titleBtn addTarget:self action:@selector(titleBtnClick:) forControlEvents:UIControlEventTouchDown];
        [self.titlesView addSubview:titleBtn];
        [self.titleButtons addObject:titleBtn];
        // 默认第一个为选中按钮
        if (i == 0) {
            [self btnClick:titleBtn];
        }
    }
    
    // 添加 下划线
    [self setUpUnderLineView];
    
    // 设置contentScrollView的滚动范围
    self.contentScrollView.contentSize = CGSizeMake(count * MGScreen_Width, 0);
}

/**
 *  创建 underLineView(下划线)
 */
- (void)setUpUnderLineView{
    // 取得第一个按钮
    UIButton *firstButton = self.titlesView.subviews.firstObject;
    
    // 标题栏
    UIView *underLineView = [[UIView alloc] init];
    underLineView.backgroundColor = [firstButton titleColorForState:UIControlStateSelected];
    underLineView.height = 2;
    underLineView.y = self.titlesView.height - underLineView.height - 1;
    
    // 让第一个按钮为选中状态
    [self titleBtnClick:firstButton];
    //    firstButton.selected = YES;
    //    self.selTitleButton = firstButton;
    
    
    // 下划线的宽度 == 按钮的文字的宽度
    //    [firstButton.titleLabel sizeToFit];
    //
        // 先计算宽度后计算中心点
    [firstButton.titleLabel sizeToFit];
    underLineView.width = firstButton.titleLabel.width + DefaultMargin;
    underLineView.centerX = firstButton.centerX;
    
    _underLineView = underLineView;
    [self.titlesView addSubview:underLineView];
}


// 监听按钮点击 切换文字颜色
- (void)titleBtnClick:(UIButton *)btn{
    [self btnClick:btn];
    // 点击按钮，加载对应的View
    NSInteger j = btn.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 1.标题栏选中状态
        [btn.titleLabel sizeToFit];
        _underLineView.width = btn.titleLabel.width + DefaultMargin;
        _underLineView.centerX = btn.centerX;
        
        CGPoint offset = self.contentScrollView.contentOffset;
        offset.x = j * self.contentScrollView.width;
        self.contentScrollView.contentOffset = offset;
    }completion:^(BOOL finished) {
        // 计算每一个View的位置
        [self setupOneChildViewController:j];
    }];
}


- (void)btnClick:(UIButton *)btn{
    // 三部曲
    [self.seltitleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // 之前选中的恢复原样
    self.seltitleButton.transform = CGAffineTransformIdentity;
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    // 当前选中的放大
    btn.transform = CGAffineTransformMakeScale(maxTitleScale, maxTitleScale);
    self.seltitleButton = btn;
}

#pragma mark - ========= 初始化标题子控制器 ============
- (void)setupOneChildViewController:(NSInteger)j{
    // 获取对应控制器
    UIViewController *vc = self.childViewControllers[j];
    
    CGFloat x = j * MGScreen_Width;
    CGFloat y = 0;
    CGFloat width = MGScreen_Width;
    CGFloat height = self.contentScrollView.frame.size.height;
    
    vc.view.frame = CGRectMake(x, y, width, height);
    [self.contentScrollView addSubview:vc.view];
    
    // 点击按钮就跳转到当前的控制器
    self.contentScrollView.contentOffset = CGPointMake(j * MGScreen_Width, 0);
}

#pragma mark - ========= 初始化标题ContentlscrollView ============
// 2.初始化标题ContentlscrollView
- (void)setupContentlscrollView{
    // 开启分页功能
    self.contentScrollView.pagingEnabled = YES;
    // 隐藏水平条
    self.contentScrollView.showsHorizontalScrollIndicator = NO;
    // 设置代理
    self.contentScrollView.delegate = self;
}

#pragma mark - ========= UIScrollViewDelegate ============
/**
 *   监听滑动，切换界面。还有切换按钮
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    // 1.取得角标
    int index = (int)scrollView.contentOffset.x/MGScreen_Width;
    // 2.切换View
//    [self setupOneChildViewController:index];
    // 3.切换到选中的按钮
    [self titleBtnClick:self.titleButtons[index]];
}

/**
 *  监听滑动，来个渐变过程
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetX = scrollView.contentOffset.x;
    // 1.取得角标
    int indexL = (int)offsetX/MGScreen_Width;
    int indexR = indexL + 1;
    
    // 2.取得左边的按钮
    UIButton *leftButton = self.titleButtons[indexL];
    
    UIButton *rightButton = nil;
    if (indexR < self.titleButtons.count) {
        // 取得左边的按钮
        rightButton = self.titleButtons[indexR];
    }
    
    
    // 2.让按钮缩放,计算缩放比例
    CGFloat scaleR = (offsetX/MGScreen_Width - indexL);
    CGFloat scaleL = 1 - scaleR;
    CGFloat transformScale = maxTitleScale - 1;
    
    // 2.1 让左边按钮缩放
    leftButton.transform = CGAffineTransformMakeScale(transformScale * scaleL + 1, transformScale * scaleL + 1);
    
    // 2.2 让右边按钮缩放
    rightButton.transform = CGAffineTransformMakeScale(transformScale * scaleR + 1, transformScale * scaleR + 1);
    
    // 3.让按钮颜色渐变
    //     RGB
    // 黑色:0 0 0
    // 白色:1 1 1
    // 红色:1 0 0
    // 黑色 -> 红色 R:0 -> 1
    // 红色 -> 黑色 R:1 -> 0
    UIColor *leftColor = [UIColor colorWithRed:scaleL green:0 blue:0 alpha:1];
    UIColor *rightColor = [UIColor colorWithRed:0 green:scaleR blue:0 alpha:1];
    // 3.1 让左边按钮的颜色
    [leftButton setTitleColor:leftColor forState:UIControlStateNormal];
    // 3.2 让左边按钮的颜色
    [rightButton setTitleColor:rightColor forState:UIControlStateNormal];
}

#pragma mark - ========= 初始化所有的子控制器 ============
// 3.初始化所有的子控制器
- (void)setupAllChildViewController{
    // 头条
    MGHotViewController *toptVC = [[MGHotViewController alloc] init];
    toptVC.title = @"热门";
    [self addChildViewController:toptVC];
    
    // 热点
    MGNewViewController *hotVC = [[MGNewViewController alloc] init];
    hotVC.title = @"最新";
    [self addChildViewController:hotVC];
    
    // 关注
    MGCareViewController *videoVC = [UIStoryboard storyboardWithName:NSStringFromClass([MGCareViewController class]) bundle:nil].instantiateInitialViewController;
    videoVC.title = @"关注";
    [self addChildViewController:videoVC];
}


#pragma mark - setupNavItem
- (void)setupNavItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search_15x14"] style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"head_crown_24x24"] style:UIBarButtonItemStyleDone target:self action:@selector(rankCrown)];
}

- (void)rankCrown {
    HomeWebVC *webVc = [[HomeWebVC alloc] initWithNavigationTitle:@"排行" withUrlStr:@"http://live.9158.com/Rank/WeekRank?Random=10"];
    [self.navigationController pushViewController:webVc animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
