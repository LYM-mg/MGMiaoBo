//
//  MGRechargeCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/22.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGRechargeCell.h"

@interface MGRechargeCell ()
/** btn */
@property (nonatomic,weak) UIButton *rightBtn;
@end

@implementation MGRechargeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    MGRechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIDDD"];
    if (cell == nil) {
       cell = [[MGRechargeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellIDDD"];
        UIButton *btn = [[UIButton alloc] init];
        cell.imageView.image = [UIImage imageNamed:@"coin_20x20_"];
        cell.accessoryView = btn;
        btn.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:btn.frame cornerRadius:3].CGPath;
        [btn setTitleColor:KeyColor forState:UIControlStateNormal];
        btn.layer.cornerRadius = 3;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = KeyColor.CGColor;
        cell.rightBtn = btn;
    }
    return cell;
}



- (void)setDict:(NSDictionary *)dict{
    _dict = dict;
    self.textLabel.text = dict[@"title"];
    [_rightBtn setTitle:dict[@"rightTitle"] forState:UIControlStateNormal];
    [_rightBtn sizeToFit];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
