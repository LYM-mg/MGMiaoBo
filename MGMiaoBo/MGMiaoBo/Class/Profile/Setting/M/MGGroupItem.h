//
//  MGGroupItem.h
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGGroupItem : NSObject


/** 记录下组头部标题 */
@property (nonatomic, strong) NSString *headerTitle;

/**  记录下组尾部标题 */
@property (nonatomic, strong) NSString *footerTitle;

// 记录下当前组有多少行
// items:XMGSettingItem
// 行模型数组
@property (nonatomic, strong) NSArray *items;

@end
