/*
    @header MGNavController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGNavController.h"

@implementation MGNavController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navBar_bg_414x70"] forBarMetrics:UIBarMetricsDefault];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count) { // 隐藏tabBar导航栏
        viewController.hidesBottomBarWhenPushed = YES;
        
        // 自定义返回按钮
        UIButton *btn = [[UIButton alloc] init];
        [btn setImage:[UIImage imageNamed:@"back_9x16"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
        
        // 如果自定义返回按钮后, 滑动返回可能失效, 需要添加下面的代码
        __weak typeof(viewController)Weakself = viewController;
        self.interactivePopGestureRecognizer.delegate = (id)Weakself;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
        [self popViewControllerAnimated:YES];
}


@end
