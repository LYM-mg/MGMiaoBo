/*
    @header MGSelectedView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HomeType) {
    HomeTypeHot, // 热门
    HomeTypeNew, // 最新
    HomeTypeCare // 关注
};

@interface MGSelectedView : UIView
/** 选中了 */
@property(nonatomic, copy)void (^selectedBlock)(HomeType type);
/** 下划线 */
@property (nonatomic, weak, readonly)UIView *underLine;
/** 设置滑动选中的按钮 */
@property(nonatomic, assign) HomeType selectedType;
@end
