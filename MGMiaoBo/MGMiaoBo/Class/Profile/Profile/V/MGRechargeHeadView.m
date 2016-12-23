/*
    @header MGRechargeHeadView.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/20.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */


#import "MGRechargeHeadView.h"

@interface MGRechargeHeadView ()
/** 会员办理  */
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;

@end


@implementation MGRechargeHeadView

+ (instancetype)rechargeHeadView {
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MGRechargeHeadView class]) owner:nil options:nil].lastObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)]];
}

- (IBAction)memberBtn:(UIButton *)sender {
    if (self.memberComplete) {
        self.memberComplete();
    }
}

- (void)tap:(UITapGestureRecognizer *)tap {
    if (self.memberComplete) {
        self.memberComplete();
    }
}

@end
