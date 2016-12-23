/*
    @header MGFollowViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/24.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGFollowViewController.h"

@interface MGFollowViewController ()

@end

@implementation MGFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"关注";
    
    UIImageView *backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, MGScreen_Width, self.view.height*0.6)];
    backGroundImageView.image = [UIImage imageNamed:@"no_follow_320x316_"];
    [self.view addSubview:backGroundImageView];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(backGroundImageView.frame)+2*DefaultMargin, MGScreen_Width - 40, 30)];
    tipLabel.text = @"你没关注任何主播";
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = KeyColor;
    [self.view addSubview:tipLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
