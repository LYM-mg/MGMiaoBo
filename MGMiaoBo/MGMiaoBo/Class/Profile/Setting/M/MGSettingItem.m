//
//  MGSettingItem.m
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGSettingItem.h"

@implementation MGSettingItem

+ (instancetype)itemWithIcon:(UIImage *)icon title:(NSString *)title
{
    MGSettingItem *item = [[self alloc] init];
    
    item.title = title;
    item.icon = icon;
    
    return item;
}

+ (instancetype)itemWithtitle:(NSString *)title {
    MGSettingItem *item = [[self alloc] init];
    item.title = title;
    return item;
}
@end
