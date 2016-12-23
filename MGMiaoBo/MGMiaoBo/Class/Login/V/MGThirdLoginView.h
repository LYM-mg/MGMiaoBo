/*
    @header MGThirdLoginView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ThirdLoginType) {
    ThirdLoginTypeSina,
    ThirdLoginTypeQQ,
    ThirdLoginTypeWechat
};

@interface MGThirdLoginView : UIView

/** 点击图片的回调 */
@property (nonatomic, copy) void (^clickLogin)(ThirdLoginType type);

@end

