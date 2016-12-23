/*
    @header MGCareViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGCareViewController.h"

@interface MGCareViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *topImageView;
@property (weak, nonatomic) IBOutlet UILabel *careLabel;
@property (weak, nonatomic) IBOutlet UIButton *toSeeHotBtn;

@end

@implementation MGCareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.toSeeHotBtn.layer.borderWidth = 1;
    self.toSeeHotBtn.layer.borderColor = MGRGBColor(255, 43, 162).CGColor;
    self.toSeeHotBtn.layer.cornerRadius = self.toSeeHotBtn.height * 0.5;
    [self.toSeeHotBtn.layer masksToBounds];
    self.toSeeHotBtn.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 去看看当前热门直播
- (IBAction)toSeeHotZone:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:kMGToSeeHotZoneNotification object:nil];
    sender.backgroundColor = MGRGBAColor(255, 43, 162, 0.4);
}

- (IBAction)toSeeHotZoneTouchUpOutside:(id)sender {
    self.toSeeHotBtn.backgroundColor = MGRGBAColor(255, 255, 255, 255);
}

@end
