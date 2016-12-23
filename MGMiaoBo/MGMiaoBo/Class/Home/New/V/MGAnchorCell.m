//
//  MGAnchorCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/10.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGAnchorCell.h"
#import <Masonry.h>
#import "MGUser.h"
#import <UIImageView+WebCache.h>

@interface MGAnchorCell ()
/** 背景图片 */
@property (weak, nonatomic)  UIImageView *coverImageView;
/** 是否新人 */
@property (weak, nonatomic)  UIImageView *fresnImageView;
/** 地区 */
@property (weak, nonatomic)  UIButton *locationBtn;
/** 主播名字 */
@property (weak, nonatomic)  UILabel *nickNameLabel;
/** 等级 */
@property (weak, nonatomic)  UIImageView *star;
@end

@implementation MGAnchorCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - 私有方法 ,创建UI
- (void)setupUI {
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:coverImageView];
    self.coverImageView = coverImageView;
    
    UIButton *locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [locationBtn setTintColor:[UIColor whiteColor]];
    locationBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [locationBtn setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:locationBtn];
    self.locationBtn = locationBtn;
    
    UIImageView *fresnImageView = [[UIImageView alloc] init];
    fresnImageView.image = [UIImage imageNamed:@"flag_new_33x17_"];
    fresnImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:fresnImageView];
    self.fresnImageView = fresnImageView;
    
    UIImageView *star = [[UIImageView alloc] init];
    star.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:star];
    self.star = star;
    
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:nickNameLabel];
    self.nickNameLabel = nickNameLabel;
    
    [locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(self.contentView).offset(1);
        make.size.mas_equalTo(CGSizeMake(66, 20));
    }];
    [fresnImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(1);
        make.right.mas_equalTo(self.contentView).offset(-1);
        make.size.mas_equalTo(CGSizeMake(25, 20));
    }];
    [nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-1);
        make.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(25);
    }];
    [star mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.nickNameLabel.mas_bottom).offset(-1);
        make.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(25, 20));
    }];
}

- (void)setUser:(MGUser *)user{
    _user = user;
    // 设置封面头像
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:user.photo] placeholderImage:[UIImage imageNamed:@"placeholder_head"]];
    // 是否是新主播
    self.fresnImageView.hidden = !user.newStar;
    // 地址
    [self.locationBtn setTitle:(user.position ? user.position:@"你的位置") forState:UIControlStateNormal];
    // 主播名
    self.nickNameLabel.text = (user.nickname ? user.nickname:@"喵喵");
    
    // 等级
    self.star.hidden = (user.starlevel == 0);
    if (user.starlevel == 1) {
        self.star.image = [UIImage imageNamed:@"girl_star1_40x19"];
    }else if (user.starlevel == 2){
        self.star.image = [UIImage imageNamed:@"girl_star2_40x19"];
    } else if(user.starlevel == 3){
        self.star.image = [UIImage imageNamed:@"girl_star3_40x19"];
    }  else if(user.starlevel == 4){
        self.star.image = [UIImage imageNamed:@"girl_star4_40x19"];
    }  else if(user.starlevel == 5){
        self.star.image = [UIImage imageNamed:@"girl_star5_40x19"];
    }
}

@end
