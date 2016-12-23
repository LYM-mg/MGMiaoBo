//
//  MGMyTaskCell.m
//  MGMiaoBo
//
//  Created by ming on 16/9/22.
//  Copyright © 2016年 ming. All rights reserved.
/*
 mineTask_icon_sign_60x60_
 task_image_cat_83x86_
 task_image_guide_305x445_
 */

#import "MGMyTaskCell.h"

@interface MGMyTaskCell ()
@property (weak, nonatomic) IBOutlet UIImageView *leftImageV;
@property (weak, nonatomic) IBOutlet UILabel *leftTitle;
@property (weak, nonatomic) IBOutlet UILabel *leftSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *rightTitle;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation MGMyTaskCell

- (void)awakeFromNib {
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)setDict:(NSDictionary *)dict {
    _dict = dict;
    self.leftImageV.image = [UIImage imageNamed:dict[@"icon"]];
    self.leftTitle.text = dict[@"leftTitle"];
    self.leftSubTitle.text = dict[@"leftSubtitle"];
    self.rightTitle.text = dict[@"rightTitle"];
    [self.rightBtn setTitle:dict[@"rightbtnTitle"] forState:UIControlStateNormal];
}

// 右边按钮的点击
- (IBAction)rightBtnClick:(UIButton *)sender {
    
}
@end
