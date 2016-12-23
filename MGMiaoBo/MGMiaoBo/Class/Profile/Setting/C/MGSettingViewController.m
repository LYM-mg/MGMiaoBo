/*
    @header MGSettingViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/12.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGSettingViewController.h"

@interface MGSettingViewController ()

@end

@implementation MGSettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 配置tableView的模型
    // tableView分组样式
    // tableView有多少组,由groups数组决定,记录tableView有多少组
    // tableView每一组对应组模型(MGGroupItem)
    // 组模型用来描述当前组的一些信息,头部标题,尾部标题,每一组有多少行,每一组有多少行,行模型数组(items)
    // 行模型数组中有多少个行模型,当前组就有多少个cell,每一个cell对应的行模型
    
    // 添加第0组模型
    [self setUpGroup0];
    
    // 添加第1组模型
    [self setUpGroup1];
    
    // 添加第2组模型
    [self setUpGroup2];
    
    // 添加第2组模型
    [self setUpGroup3];
}

// 第0组
- (void)setUpGroup0
{
    // 创建组模型
    MGGroupItem *group = [[MGGroupItem alloc] init];
    group.footerTitle = @"开启后，你关注的主播开播时你会收到通知";
    // 创建行模型
    MGSettingItem *item = [MGSwitchItem itemWithIcon:[UIImage imageNamed:@"RedeemCode"] title:@"开播提醒"];
    item.operationBlock = ^(NSIndexPath *indexPath){
        // 这边设置打开开关后的操作
    };
    // 创建行模型数组
    group.items = @[item];
    
    // 把组模型保存到groups数组
    [self.groups addObject:group];
    
}

// 添加第1组
- (void)setUpGroup1
{
    // 创建行模型
    MGSettingItem *item1 = [MGSwitchItem itemWithIcon:[UIImage imageNamed:@"MorePush"] title:@"公聊消息过滤"];
    
    // 创建组模型
    MGGroupItem *group = [[MGGroupItem alloc] init];
    group.footerTitle = @"开启后，显示你与挡圈主播和你的公聊消息";
    // 行模型数组
    group.items = @[item1];
    [self.groups addObject:group];
    
}

// 添加第2组
- (void)setUpGroup2 {
    MGArrowItem *item1 = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"清理缓存"];
    weakSelf(self);
    [item1 setOperationBlock:^(NSIndexPath *indexPath) {
        [SVProgressHUD showWithStatus:@"正在删除.."];
        // 清空缓存,就是把Cache文件夹直接删掉
        // 删除比较耗时
        [self removeCachesWithCompletion:^{
            weakself.total = 0.0;
            
            [weakself.tableView reloadData];
            
            [SVProgressHUD dismiss];
        }];
    }];
    
    // 创建组模型
    MGGroupItem *group = [[MGGroupItem alloc] init];
    // 行模型数组
    group.items = @[item1];
    [self.groups addObject:group];
}

// 添加第3组
- (void)setUpGroup3 {
    weakSelf(self);
    // 创建行模型
    MGSettingItem *item = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"赏个好评"];
    // 保存跳转控制器类名字符串
    [item setOperationBlock:^(NSIndexPath *indexPath) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/LYM-mg/MGLoveFreshBeen"]];
    }];
    
    MGArrowItem *item1 = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"检查新版本"];
    item1.operationBlock = ^(NSIndexPath *indexPath){
        [weakself showInfo:@"没有最新的版本"];
    };
    
    
    MGArrowItem *item2 = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"拨打电话联系客服"];
    [item2 setOperationBlock:^(NSIndexPath *indexPath) {
        [weakself takePhone];
    }];

    MGArrowItem *item3 = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"在线联系客服"];
    item3.descVcClass = NSClassFromString(@"HomeWebVC");
    
    
    MGArrowItem *item4 = [MGArrowItem itemWithIcon:[UIImage imageNamed:@"MoreUpdate"] title:@"关于喵播"];
    item4.descVcClass = [MGAboutMiaoboController class];

    
    // 创建组模型数组
    MGGroupItem *group = [[MGGroupItem alloc] init];
    group.items = @[item,item1,item2,item3,item4];
    group.headerTitle = @"明明带你";
    [self.groups addObject:group];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

/**
 *  拨打客服电话☎️
 */
- (void)takePhone {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"确定要拨打电话" message:@"1292043630" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *phoneAction = [UIAlertAction actionWithTitle:@"拨打" style:UIAlertActionStyleDestructive  handler:^(UIAlertAction * _Nonnull action) {
        /// 1.第一种打电话(拨打完电话回不到原来的应用，会停留在通讯录里，而且是直接拨打，不弹出提示)
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneAction]]];
        
        /// 2.第二种打电话(打完电话后还会回到原来的程序，也会弹出提示，推荐这种)
        UIWebView *callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"tel:13750525922"]]];
        [self.view addSubview:callWebview];
        
        /// 3.第三种打电话(这种方法也会回去到原来的程序里（注意这里的telprompt），也会弹出提示)
        //            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"186xxxx6979"];
        //            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertVC addAction:phoneAction];
    [alertVC addAction:cancelAction];
    [self.navigationController presentViewController:alertVC animated:YES completion:nil];
}

- (void)clearCaches {
    [self showHint:@"正在清除缓存"];
    [[[NSOperationQueue alloc] init] addOperationWithBlock:^{
        NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(
                                                                   NSCachesDirectory,
                                                                   NSUserDomainMask,
                                                                   YES);
        NSString *documentFolderPath = [searchPaths objectAtIndex:0];
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:documentFolderPath];
        for (NSString *p in files) {
            NSError *error;
            NSString *Path = [documentFolderPath stringByAppendingPathComponent:p];
            if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
                [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
            }
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showHint:@"缓存已清除"];
            });
        }];
    }];
}

@end

