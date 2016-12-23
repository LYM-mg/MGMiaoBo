/*
    @header MGBottomToolView.h
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/11.
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveToolType) {
    LiveToolTypePublicTalk,
    LiveToolTypePrivateTalk,
    LiveToolTypeGift,
    LiveToolTypeRank,
    LiveToolTypeShare,
    LiveToolTypeClose
};

@interface MGBottomToolView : UIView
/** 点击工具栏  */
@property(nonatomic, copy)void (^clickToolBlock)(LiveToolType type);
@end
