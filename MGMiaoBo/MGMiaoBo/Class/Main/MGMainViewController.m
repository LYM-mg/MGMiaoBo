/*
    @header MGMainViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/10.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
    Copyright © 2016年 ming. All rights reserved.
 */

#import "MGMainViewController.h"
#import "MGNavController.h"
#import "MGHomeViewController.h"
#import "MGProfileViewController.h"
#import "MGShowTimeViewController.h"
#import "ShowTimeViewController.h"

#import "UIDevice+Extension.h"
#import <AVFoundation/AVFoundation.h>

@interface MGMainViewController ()<UITabBarControllerDelegate>

@end

@implementation MGMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 0.设置代理
    self.delegate = self;
    
    // 1.当系统的Tabbar满足不了需求的时候，用自己的TabBar代替系统的TabBar
    // [self setValue:[[LYMTabBar alloc] init] forKey:@"tabBar"];
    
    // 2.初始化所有的自控制器
    [self setUpAllChildController];
    
}

#pragma mark ========= initialize ===========
+ (void)initialize{
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
    NSDictionary *dict = @{
                           NSForegroundColorAttributeName:[UIColor grayColor]
                           };
    [[UITabBarItem appearance] setTitleTextAttributes:dict forState:UIControlStateNormal];
}

#pragma mark ========= 初始化所有的子控制器 =========
/**
 *  初始化所有的子控制器
 */
- (void)setUpAllChildController{
    // 1.精华界面
    MGHomeViewController *essenceCV = [[MGHomeViewController alloc] init];
    [self setNavOneChildViewController:essenceCV title:@"精华" image:@"toolbar_home"];
    
    // 2.朋友
    MGShowTimeViewController *friendVC = [[MGShowTimeViewController alloc] init];
    [self setNavOneChildViewController:friendVC  title:@"showTime" image:@"toolbar_live"];
    
    // 3.新手大厅
    MGProfileViewController *newVC = [[MGProfileViewController alloc] init];
    [self setNavOneChildViewController:newVC title:@"个人中心" image:@"toolbar_me"];
}

/**
 *  初始化一个子控制器的方法
 */
- (void)setNavOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image {
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage mg_ImageRenderingModeAlwaysOriginal:image];
    NSString *selImage = [NSString stringWithFormat:@"%@_sel",image];
    vc.tabBarItem.selectedImage = [UIImage mg_ImageRenderingModeAlwaysOriginal:selImage];
    
    [self addChildViewController:[[MGNavController alloc] initWithRootViewController:vc]];
}

#pragma mark - UITabBarControllerDelegate
-  (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([tabBarController.childViewControllers indexOfObject:viewController] == tabBarController.childViewControllers.count-2) {
        // 判断是否是模拟器
        if ([[UIDevice deviceVersion] isEqualToString:@"iPhone Simulator"]) {
            [self showInfo:@"请用真机进行测试, 此模块不支持模拟器测试"];
            return NO;
        }
        
        // 判断是否有摄像头
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
            [self showInfo:@"您的设备没有摄像头或者相关的驱动, 不能进行直播"];
            return NO;
        }
        
        // 判断是否有摄像头权限
        AVAuthorizationStatus  authorizationStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (authorizationStatus == AVAuthorizationStatusRestricted|| authorizationStatus == AVAuthorizationStatusDenied) {
            [self showInfo:@"app需要访问您的摄像头。\n请启用摄像头-设置/隐私/摄像头"];
            return NO;
        }
        
        if ([UIImagePickerController
             isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            NSArray *availableMediaTypes = [UIImagePickerController
                                            availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            if (![availableMediaTypes containsObject:(NSString *)kUTTypeMovie]) {
                // 支持视频录制
                return NO;
            }
        }
        
        // 开启麦克风权限
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    return YES;
                } else {
                    [self showInfo:@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风"];
                    return NO;
                }
            }];
        }
        [self showHint:@"此功能还有BUG，暂未开通"];
        ShowTimeViewController *showTimeVc = [UIStoryboard storyboardWithName:NSStringFromClass([ShowTimeViewController class]) bundle:nil].instantiateInitialViewController;
        [viewController presentViewController:showTimeVc animated:YES completion:nil];
        return YES;
    }
    return YES;
}




@end