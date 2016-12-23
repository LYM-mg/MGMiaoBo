//
//  MGSettingItem.h
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGSettingItem : NSObject


@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *subTitle;

@property (nonatomic, strong) UIImage *icon;

// 保存每一行cell做的事情
@property (nonatomic, strong) void(^operationBlock)(NSIndexPath *indexPath);

// 描述cell的样式,箭头,开关
//@property (nonatomic, assign) XMGSettingItemType type;

+ (instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title;
+ (instancetype)itemWithtitle:(NSString *)title;

@end
