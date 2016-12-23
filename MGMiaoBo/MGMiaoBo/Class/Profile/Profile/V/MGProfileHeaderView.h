/*
    @header MGProfileHeaderView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/12.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@interface MGProfileHeaderView : UIView

/** 容器视图的高度 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containViewHCon;
/** top点击回调 */
@property (nonatomic,copy) void (^topViewClickComplete)();
/** leftView点击回调 */
@property (nonatomic,copy) void (^leftViewClickComplete)();
/** centerView点击回调 */
@property (nonatomic,copy) void (^centerViewClickComplete)();
/** rightView点击回调 */
@property (nonatomic,copy) void (^rightViewClickComplete)();
+ (instancetype)headerView;

@end
