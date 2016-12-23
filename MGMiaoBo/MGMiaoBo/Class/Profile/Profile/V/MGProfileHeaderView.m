/*
    @header MGProfileHeaderView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/12.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGProfileHeaderView.h"



@interface MGProfileHeaderView ()
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;


@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userId;
/***/
@property (weak, nonatomic) IBOutlet UILabel *userSignature;

@end

@implementation MGProfileHeaderView

+ (instancetype)headerView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGProfileHeaderView class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    // 获取单例对象
//    UIApplication *application = [UIApplication sharedApplication];
//    // 推送消息(要注册)
//    UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
//    [application registerUserNotificationSettings:setting];
//    application.applicationIconBadgeNumber = 1;
//    
//    // s设置联网状态
//    application.networkActivityIndicatorVisible = YES;
    
    [self.topView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(topViewTapClick:)]];
    [self.leftView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapClick:)]];
    [self.centerView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapClick:)]];
    [self.rightView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bottomViewTapClick:)]];
}

- (void)topViewTapClick:(UITapGestureRecognizer *)tap {
    if (self.topViewClickComplete) {
        self.topViewClickComplete();
    }
}

- (void)bottomViewTapClick:(UITapGestureRecognizer *)tap {
    switch (tap.view.tag) {
        case 100:
        {
            if (self.leftViewClickComplete) {
                self.leftViewClickComplete();
            }
        }
            break;
        case 101:
        {
            if (self.centerViewClickComplete) {
                self.centerViewClickComplete();
            }
        }
            break;
        case 102:
        {
            if (self.rightViewClickComplete) {
                self.rightViewClickComplete();
            }
        }
            break;
        default:
            break;
    }
}

@end
