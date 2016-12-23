/*
    @header MGUserView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class MGUser;
@interface MGUserView : UIView

+ (instancetype)userView;
/** 点击关闭 */
@property (nonatomic, copy) void (^closeBlock)();
/** 用户信息 */
@property (nonatomic, strong) MGUser *user;
@end
