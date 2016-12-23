/*
    @header MGCatEarView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGCatEarView.h"
#import "MGHotLive.h"

@interface MGCatEarView ()
@property (weak, nonatomic) IBOutlet UIView *playView;
/** 直播的播放器 */
@property (nonatomic,strong) IJKFFMoviePlayerController *moviePlayer;
@end

@implementation MGCatEarView

/** 快速从XIB创建 */
+ (instancetype)catEarView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGCatEarView class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.playView.layer.cornerRadius = self.playView.height * 0.5;
    self.playView.layer.masksToBounds = YES;
}

/**
 *  重写模型，根据流地址去播放视频
 */
- (void)setLive:(MGHotLive *)live {
    _live = live;
    
    // 设置只播放视频，不播放声音
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionValue:@"1" forKey:@"an"];
    
    // 开启硬解码
    [options setPlayerOptionValue:@"1" forKey:@"videotoolbox"];
    IJKFFMoviePlayerController *moviePlayer = [[IJKFFMoviePlayerController alloc] initWithContentURLString:live.flv withOptions:options];
    moviePlayer.view.frame = self.playView.bounds;
    
    // 设置填充模式
    moviePlayer.scalingMode = IJKMPMovieScalingModeAspectFill;
    
    // 设置自动播放
    moviePlayer.shouldAutoplay = YES;
    [moviePlayer prepareToPlay];
    [self.playView addSubview:moviePlayer.view];
    self.moviePlayer = moviePlayer;
}

- (void)removeFromSuperview {
    if (_moviePlayer) {
        [_moviePlayer shutdown];
        [_moviePlayer.view removeFromSuperview];
        _moviePlayer = nil;
    }
    [super removeFromSuperview];
}


@end
