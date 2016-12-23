/*
    @header MGRechargeHeadView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/20.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface MGRechargeHeadView : UIView

+ (instancetype)rechargeHeadView;


/** 点击会员处理 */
@property (nonatomic,copy) void (^memberComplete)();

@end
