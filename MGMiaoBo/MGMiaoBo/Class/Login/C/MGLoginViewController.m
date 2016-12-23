/*
    @header MGLoginViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGLoginViewController.h"
#import "MGMainViewController.h"
#import "MGThirdLoginView.h"

@interface MGLoginViewController ()
/** player */
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 第三方登录 */
@property (nonatomic, weak) MGThirdLoginView *thirdView;
/** 快速通道 */
@property (nonatomic, weak) UIButton *quickBtn;
/** 封面图片 */
@property (nonatomic, weak) UIImageView *backImageView;

@end

@implementation MGLoginViewController

#pragma mark - lazy
- (IJKFFMoviePlayerController *)player {
    if (!_player) {
        // 随机播放一组视频
        NSString *path = arc4random_uniform(10) % 2 ? @"login_video" : @"loginmovie";
        _player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@".mp4"] withOptions:[IJKFFOptions optionsByDefault]];
        // 设计player
        _player.view.frame = self.view.bounds;
        // 填充fill
        _player.scalingMode = IJKMPMovieScalingModeAspectFill;
        
        [self.view addSubview:_player.view];
        _player.shouldAutoplay = NO;
        // 准备播放
        [_player prepareToPlay];
    }
    return _player;
}

- (MGThirdLoginView *)thirdView {
    if (!_thirdView) {
        MGThirdLoginView *third = [[MGThirdLoginView alloc] initWithFrame:CGRectMake(0, 0, 200, 400)];
        third.hidden = YES;
        [self.view addSubview:third];
        [third setClickLogin:^(ThirdLoginType type) {
            [self loginSuccess:type];
        }];
        _thirdView = third;
    }
    return _thirdView;
}

- (UIButton *)quickBtn
{
    if (!_quickBtn) {
        UIButton *btn = [[UIButton alloc] init];
        btn.backgroundColor = [UIColor clearColor];
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = [UIColor orangeColor].CGColor;
        [btn setTitle:@"快速登录通道" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor]  forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(quickLoginSuccess) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.hidden = YES;
        _quickBtn = btn;
    }
    return _quickBtn;
}

- (UIImageView *)backImageView
{
    if (!_backImageView) {
        UIImageView *cover = [[UIImageView alloc] initWithFrame:self.view.bounds];
        cover.image = [UIImage imageNamed:@"LaunchImage"];
        [self.player.view addSubview:cover];
        _backImageView = cover;
    }
    return _backImageView;
}

#pragma mark - 控制器的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setup];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player shutdown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.player.view removeFromSuperview];
    self.player = nil;
    
}


- (void)setup
{
    [self initObserver];
    
    self.backImageView.hidden = NO;
    
    [self.quickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.bottom.equalTo(@-50);
        make.height.equalTo(@40);
    }];
    
    [self.thirdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@60);
        make.bottom.equalTo(self.quickBtn.mas_top).offset(-40);
    }];
}

- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}


- (void)stateDidChange
{
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
            self.backImageView.frame = self.view.bounds;
            [self.view insertSubview:self.backImageView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.thirdView.hidden = NO;
                self.quickBtn.hidden = NO;
            });
        }
    }
}

- (void)didFinish
{
    // 播放完之后, 继续重播
    [self.player play];
}


#pragma mark - 私有方法

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 登录成功
- (void)loginSuccess:(ThirdLoginType)type {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MGMainViewController alloc] init];
         [self.player stop];
         [self.player.view removeFromSuperview];
         self.player = nil;
//        [self presentViewController:[[MGMainViewController alloc] init] animated:NO completion:^{
//            [self.player stop];
//            [self.player.view removeFromSuperview];
//            self.player = nil;
//        }];
    });
}

// 快速登录
- (void)quickLoginSuccess {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[MGMainViewController alloc] init];
        [self.player stop];
        [self.player.view removeFromSuperview];
        self.player = nil;
    });
}

@end
