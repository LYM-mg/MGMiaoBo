/*
    @header MGFansViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/24.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGFansViewController.h"

@interface MGFansViewController ()

@end

@implementation MGFansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"粉丝";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, MGScreen_Width, self.view.height*0.6)];
    backGroundImageView.image = [UIImage imageNamed:@"no_fans_250x193"];
    [self.view addSubview:backGroundImageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backGroundImageView.frame)+2*DefaultMargin, MGScreen_Width - 40, 30)];
    tipLabel.text = @"当前还没粉丝关注你";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = KeyColor;
    [self.view addSubview:tipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
