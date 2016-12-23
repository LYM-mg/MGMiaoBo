/*
    @header MGCatEarView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

@class MGHotLive;

@interface MGCatEarView : UIView

/** 主播/主播 */
@property(nonatomic, strong) MGHotLive *live;

/** 快速从XIB创建 */
+ (instancetype)catEarView;

@end
