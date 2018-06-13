//
//  MGHotLiveViewCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGHotLiveViewCell.h"
#import "MGBottomToolView.h"
#import "MGLiveAnchorView.h"
#import "MGCatEarView.h"
#import "MGLiveEndView.h"
#import "MGHotLive.h"
#import "MGUser.h"
#import "UIImage+Extension.h"
#import "NSSafeObject.h"

#import <SDWebImageDownloader.h>
#import <BarrageRenderer.h>
#import <Masonry/Masonry.h>

#import "HomeWebVC.h"
#import "MGNavController.h"

@interface MGHotLiveViewCell ()<UIAlertViewDelegate>
{
    BarrageRenderer *_renderer;
    NSTimer * _timer;
    BOOL _isNoFirst;
}
/** 直播播放器 */
@property (nonatomic, strong) IJKFFMoviePlayerController *moviePlayer;
/** 底部的工具栏 */
@property(nonatomic, weak) MGBottomToolView *bottomToolView;
/** 顶部主播相关视图 */
@property(nonatomic, weak) MGLiveAnchorView *anchorView;
/** 同类型直播视图 */
@property(nonatomic, weak) MGCatEarView *catEarView;
/** 直播结束的界面 */
@property (nonatomic, weak) MGLiveEndView *endView;

/** 同一个工会的主播/相关主播 */
@property(nonatomic, weak) UIImageView *otherView;
/** 直播开始前的占位图片 */
@property(nonatomic, weak) UIImageView *placeHolderView;
/** 粒子动画 */
@property(nonatomic, weak) CAEmitterLayer *emitterLayer;

@end

@implementation MGHotLiveViewCell

#pragma mark - lazy
- (UIImageView *)placeHolderView {
    if (!_placeHolderView) {
        UIImageView *placeHolderView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        placeHolderView.image = [UIImage imageNamed:@"profile_user_414x414"];
        [self.contentView addSubview:placeHolderView];
        _placeHolderView = placeHolderView;
        [self.parentVc showGifLoding:nil inView:_placeHolderView];
        // 强制布局
        [_placeHolderView layoutIfNeeded];
    }
    return _placeHolderView;
}

bool _isSelected = NO;
- (MGBottomToolView *)bottomToolView{
    if (!_bottomToolView) {
        MGBottomToolView *bottomToolView = [[MGBottomToolView alloc] init];
        [self.contentView addSubview:bottomToolView];
        _bottomToolView = bottomToolView;
        
        [bottomToolView setClickToolBlock:^(LiveToolType type) {
            switch (type) {
                case LiveToolTypePublicTalk:
                    _isSelected = !_isSelected;
                    _isSelected ? [_renderer start] : [_renderer stop];
                    break;
                case LiveToolTypePrivateTalk:
                    
                    break;
                case LiveToolTypeGift:
                    
                    break;
                case LiveToolTypeRank:
                    
                    break;
                case LiveToolTypeShare:
                    [self share];
                    break;
                case LiveToolTypeClose:
                    [self quit];
                    break;
                default:
                    break;
            }
        }];
        [self.contentView insertSubview:bottomToolView aboveSubview:self.placeHolderView];
        [bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.mas_equalTo(0);
            make.bottom.mas_equalTo(-10);
            make.height.mas_equalTo(40);
        }];
    }
    return _bottomToolView;
}

/**
 *  其他主播用户显示
 */
- (UIImageView *)otherView
{
    if (!_otherView) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"private_icon_70x70"]];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickOther)]];
        [self.moviePlayer.view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.catEarView);
            make.bottom.equalTo(self.catEarView.mas_top).offset(-40);
        }];
        _otherView = imageView;
    }
    return _otherView;
}

/**
 *  直播界面的主播用户详情
 */
- (MGLiveAnchorView *)anchorView
{
    if (!_anchorView) {
        MGLiveAnchorView *anchorView = [MGLiveAnchorView liveAnchorView];
        [anchorView setClickDeviceShow:^(bool isSelected) {
            if (_moviePlayer) {
                _moviePlayer.shouldShowHudView = !isSelected;
            }
        }];
        weakSelf(self);
        [anchorView setClickGiftViewShow:^{
            /// MODEl
//            [weakself.parentVc presentViewController:[[MGNavController alloc] initWithRootVi ewController:[  initWithNavigationTitle:@"粉丝奉献榜" withUrlStr:@"http://live.9158.com/Rank/UserWeekRank?useridx=63411791&showtype=2&curuseridx=63417164&Random=7"]] animated:YES completion:nil];
            /// PUSH
            [weakself.parentVc.navigationController pushViewController:[[HomeWebVC alloc] initWithNavigationTitle:@"粉丝奉献榜" withUrlStr:@"http://live.9158.com/Rank/UserWeekRank?useridx=63411791&showtype=2&curuseridx=63417164&Random=7"] animated:YES];
        }];
        
        [self.contentView insertSubview:anchorView aboveSubview:self.placeHolderView];
        [anchorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.height.equalTo(@120);
            make.top.equalTo(@0);
        }];
        _anchorView = anchorView;
    }
    return _anchorView;
}

/**
 *  下一个直播界面的主播的小窗口
 */
- (MGCatEarView *)catEarView
{
    if (!_catEarView) {
        MGCatEarView *catEarView = [MGCatEarView catEarView];
        [self.moviePlayer.view addSubview:catEarView];
        [catEarView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)]];
        [catEarView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickCatEar)]];
        [catEarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-30);
            make.centerY.equalTo(self.moviePlayer.view);
            make.width.height.equalTo(@98);
        }];
        _catEarView = catEarView;
    }
    return _catEarView;
}

/**
 *  🐱，🐈，图片
 */
- (CAEmitterLayer *)emitterLayer
{
    if (!_emitterLayer) {
        CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
        // 发射器在xy平面的中心位置
        emitterLayer.emitterPosition = CGPointMake(self.moviePlayer.view.frame.size.width-45,self.moviePlayer.view.frame.size.height-50);
        // 发射器的尺寸大小
        emitterLayer.emitterSize = CGSizeMake(20, 20);
        // 渲染模式
        emitterLayer.renderMode = kCAEmitterLayerUnordered;
        // 开启三维效果
        _emitterLayer.preservesDepth = YES;
        NSMutableArray *array = [NSMutableArray array];
        // 创建粒子
        for (int i = 0; i<10; i++) {
            // 发射单元
            CAEmitterCell *stepCell = [CAEmitterCell emitterCell];
            // 粒子的创建速率，默认为1/s
            stepCell.birthRate = 1;
            // 粒子存活时间
            stepCell.lifetime = arc4random_uniform(4) + 1;
            // 粒子的生存时间容差
            stepCell.lifetimeRange = 1.5;
            // 颜色
            // fire.color=[[UIColor colorWithRed:0.8 green:0.4 blue:0.2 alpha:0.1]CGColor];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"good%d_30x30", i]];
            // 粒子显示的内容
            stepCell.contents = (id)[image CGImage];
            // 粒子的名字
            //            [fire setName:@"step%d", i];
            // 粒子的运动速度
            stepCell.velocity = arc4random_uniform(100) + 100;
            // 粒子速度的容差
            stepCell.velocityRange = 80;
            // 粒子在xy平面的发射角度
            stepCell.emissionLongitude = M_PI+M_PI_2;;
            // 粒子发射角度的容差
            stepCell.emissionRange = M_PI_2/3;
            // 缩放比例
            stepCell.scale = 0.5;
            [array addObject:stepCell];
        }
        
        emitterLayer.emitterCells = array;
        [self.moviePlayer.view.layer insertSublayer:emitterLayer below:self.catEarView.layer];
        _emitterLayer = emitterLayer;
    }
    return _emitterLayer;
}

/** ❌结束的界面 */
- (MGLiveEndView *)endView
{
    if (!_endView) {
        MGLiveEndView *endView = [MGLiveEndView liveEndView];
        [self.contentView addSubview:endView];
        [endView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
        [endView setQuitRoomBtnBlock:^{
            [self.parentVc dismissViewControllerAnimated:YES completion:nil];
        }];
        [endView setLookOtherRoomBtnBlock:^{
            [self clickCatEar];
        }];
        _endView = endView;
    }
    return _endView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bottomToolView.hidden = NO;
        
        _renderer = [[BarrageRenderer alloc] init];
        _renderer.canvasMargin = UIEdgeInsetsMake(_anchorView.height+DefaultMargin, 60, 10, 10);
        [self.contentView addSubview:_renderer.view];
        
        NSSafeObject *safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    }
    return self;
}

- (void)setLive:(MGHotLive *)live{
    if (_isNoFirst) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        
        if (_renderer) {
            [_renderer stop];
            _renderer = nil;
        }
    }
    _live = live;
    self.anchorView.live = live;
    [self plarFLV:live.flv placeHolderUrl:live.bigpic];
}

- (void)setRelateLive:(MGHotLive *)relateLive
{
    _relateLive = relateLive;
    // 设置相关主播
    if (relateLive) {
        self.catEarView.live = relateLive;
    }else{
        self.catEarView.hidden = YES;
    }
}

#pragma mark - private method
- (void)plarFLV:(NSString *)flv placeHolderUrl:(NSString *)placeHolderUrl
{
    if (_moviePlayer) {
        if (_moviePlayer) {
            [self.contentView insertSubview:self.placeHolderView aboveSubview:_moviePlayer.view];
        }
        if (_catEarView) {
            [_catEarView removeFromSuperview];
            _catEarView = nil;
        }
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    
    // 如果切换主播, 取消之前的动画
    if (_emitterLayer) {
        [_emitterLayer removeFromSuperlayer];
        _emitterLayer = nil;
    }
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:placeHolderUrl] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.parentVc showGifLoding:nil inView:self.placeHolderView];
            self.placeHolderView.image = [UIImage blurImage:image blur:0.8];
        });
    }];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:15 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
//    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:options];
//    
     IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:flv withOptions:nil];
    moviePlayer.view.frame = self.contentView.bounds;
    // 填充fill
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    // 设置自动播放(必须设置为NO, 防止自动播放, 才能更好的控制直播的状态)
    moviePlayer.shouldAutoplay = NO;
    // 默认不显示
    moviePlayer.shouldShowHudView = NO;
    
    [self.contentView insertSubview:moviePlayer.view atIndex:0];
    
    [moviePlayer prepareToPlay];
    
    self.moviePlayer = moviePlayer;
    
    [self.moviePlayer play];
    
    // 设置监听
    [self initObserver];
    
    // 显示工会其他主播和类似主播
    [moviePlayer.view bringSubviewToFront:self.otherView];
    
    // 开始来访动画
    [self.emitterLayer setHidden:NO];
}


- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.moviePlayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.moviePlayer];
}

- (void)clickOther
{
    NSLog(@"相关的主播");
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint transP = [pan translationInView:self.catEarView];
        self.catEarView.transform = CGAffineTransformTranslate(self.catEarView.transform, transP.x, transP.y);
        [pan setTranslation:CGPointZero inView:self.catEarView];
    }
}
/**
 *  查看其他主播
 */
- (void)clickCatEar
{
    if (self.clickRelatedLive) {
        self.clickRelatedLive();
    }
}

#pragma mark - notify method
- (void)stateDidChange
{
    if ((self.moviePlayer.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.moviePlayer.isPlaying) {
            [self.moviePlayer play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (_placeHolderView) {
                    [_placeHolderView removeFromSuperview];
                    _placeHolderView = nil;
                    [self.moviePlayer.view addSubview:_renderer.view];
                }
                [self.parentVc hideGufLoding];
            });
        }else{
            // 如果是网络状态不好, 断开后恢复, 也需要去掉加载
            if (self.parentVc.gifView.isAnimating) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.parentVc hideGufLoding];
                });
                
            }
        }
    }else if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled){ // 网速不佳, 自动暂停状态
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
    }
}

- (void)didFinish
{
    NSLog(@"加载状态...%ld %ld %s", self.moviePlayer.loadState, self.moviePlayer.playbackState, __func__);
    // 因为网速或者其他原因导致直播stop了, 也要显示GIF
    if (self.moviePlayer.loadState & IJKMPMovieLoadStateStalled && !self.parentVc.gifView) {
        [self.parentVc showGifLoding:nil inView:self.moviePlayer.view];
        return;
    }
    //    方法：
    //      1、重新获取直播地址，服务端控制是否有地址返回。
    //      2、用户http请求该地址，若请求成功表示直播未结束，否则结束
    __weak typeof(self)weakSelf = self;
    [[MGNetworkTool shareNetworkTool] GET:self.live.flv parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求成功%@, 等待继续播放", responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败, 加载失败界面, 关闭播放器%@", error);
        [weakSelf.moviePlayer shutdown];
        [weakSelf.moviePlayer.view removeFromSuperview];
        weakSelf.moviePlayer = nil;
        weakSelf.endView.hidden = NO;
    }];
}

- (void)quit
{
    [self endView];
    if (_catEarView) {
        [_catEarView removeFromSuperview];
        _catEarView = nil;
    }
    
    if (_moviePlayer) {
        [self.moviePlayer shutdown];
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
    [_renderer stop];
    [_renderer.view removeFromSuperview];
    _renderer = nil;
}

- (void)autoSendBarrage
{
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 50) { // 限制屏幕上的弹幕量
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionB2T]];
    }
}

#pragma mark - 弹幕描述符生产方法
long _index = 0;
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction
{
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc] init];
    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
    descriptor.params[@"text"] = self.danMuText[arc4random_uniform((uint32_t)self.danMuText.count)];
    descriptor.params[@"textColor"] = MGRGBColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256));
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
        [alertView show];
    };
    return descriptor;
}

- (NSArray *)danMuText
{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"danmu.plist" ofType:nil]];
}

#pragma mark - share
- (void)share {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享到哪里" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"WeChat",@"QQ",@"Sina" , nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.jianshu.com/users/57b58a39b70e/latest_articles"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LYM-mg"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/2778589865"]];
            break;
        default:
            break;
    }
}

@end


