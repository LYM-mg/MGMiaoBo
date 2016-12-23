/*
    @header MGThirdLoginView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGThirdLoginView.h"

@implementation MGThirdLoginView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UIImageView *sina = [self creatImageView:@"wbLoginicon_60x60" tag:ThirdLoginTypeSina];
    UIImageView *qq = [self creatImageView:@"qqloginicon_60x60" tag:ThirdLoginTypeQQ];
    UIImageView *wechat = [self creatImageView:@"wxloginicon_60x60" tag:ThirdLoginTypeWechat];
    
    [self addSubview:sina];
    [self addSubview:qq];
    [self addSubview:wechat];
    
    [sina mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.height.equalTo(@60);
    }];
    
    [qq mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.right.equalTo(sina.mas_left).offset(-20);
        make.size.equalTo(sina);
    }];
    
    [wechat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(sina);
        make.left.equalTo(sina.mas_right).offset(20);
        make.size.equalTo(sina);
    }];
    
}

/**
 *  快速创建imageView并且绑定tag
 */
- (UIImageView *)creatImageView:(NSString *)imageName tag:(NSUInteger)tag
{
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:imageName];
    imageV.tag = tag;
    imageV.userInteractionEnabled = YES;
    [imageV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click:)]];
    return imageV;
}

#pragma mark - 回调
- (void)click:(UITapGestureRecognizer *)tapRec
{
    if (self.clickLogin) {
        self.clickLogin(tapRec.view.tag);
    }
}


@end
