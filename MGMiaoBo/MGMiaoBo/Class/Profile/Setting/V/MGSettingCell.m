//
//  MGSettingCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGSettingCell.h"
#import "MGSettingItem.h"
#import "MGArrowItem.h"
#import "MGSwitchItem.h"

@interface MGSettingCell ()
@property (nonatomic, strong) UISwitch *swithView;
@end

@implementation MGSettingCell

- (UISwitch *)swithView
{
    if (_swithView == nil) {
        _swithView = [[UISwitch alloc] init];
        _swithView.tintColor = KeyColor;
    }
    return _swithView;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView style:(UITableViewCellStyle)cellStyle
{
    static NSString *KMGSettingCell = @"KMGSettingCell";
    
    MGSettingCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGSettingCell];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:cellStyle reuseIdentifier:KMGSettingCell];
    }
    return cell;
}

/**
 *  重写模型setter方法
 */
- (void)setItem:(MGSettingItem *)item {
    _item = item;
    
    // 设置cell的内容,获取对应的行
    [self setUpData];
    
    
    // 设置辅助视图
    [self setUpAccessoryView];
}

// 设置数据
- (void)setUpData
{
    self.textLabel.text = _item.title;
    self.imageView.image = _item.icon;
    
    self.detailTextLabel.text = _item.subTitle;
}

// 设置右边的辅助视图
- (void)setUpAccessoryView
{
    if ([_item isKindOfClass:[MGArrowItem class]]) { // 箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if ([_item isKindOfClass:[MGSwitchItem class]]){ // 开头
        
        self.accessoryView = self.swithView;
    }else{
        
        self.accessoryView = nil;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
