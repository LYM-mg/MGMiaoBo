//
//  MGBaseSettingViewController.m
//  MGMiaoBo
//
//  Created by ming on 16/9/12.
//  Copyright © 2016年 ming. All rights reserved.
//

#import "MGBaseSettingViewController.h"

@interface MGBaseSettingViewController ()

@end

@implementation MGBaseSettingViewController

- (NSMutableArray *)groups {
    if (_groups == nil) {
        _groups = [NSMutableArray array];
    }
    return _groups;
}

- (instancetype)init
{
    return [self initWithStyle:UITableViewStyleGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取cachePath文件缓存
    [self getFileSizeWithFileName:self.cachesPath completion:^(NSInteger total) {
        
        _total = total;
        
        // 计算完成就会调用
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];
        
    }];
}

- (void)viewWillDisappear:(BOOL)animated{
    [SVProgressHUD dismiss];
}

// 计算size
- (NSString *)getSize{
    float unit = 1000.0;
    NSString *text = @"缓存大小";
    NSString *str = nil;
    if (_total > unit * unit * unit) {
        str = [NSString stringWithFormat:@"%.1fGB",_total/unit / unit / unit];
    }else if (_total > unit * unit){
        str = [NSString stringWithFormat:@"%.1fMB",_total/unit / unit];
    }else if (_total > unit){
        str = [NSString stringWithFormat:@"%.1fKB",_total/unit];
    }else{
        str = [NSString stringWithFormat:@"%.1zdB",_total];
    }
    return [NSString stringWithFormat:@"%@(%@)",text,str];
}


#pragma mark - 数据源方法
// 返回有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.groups.count;
}

// 返回每一组有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 获取当前的组模型
    MGGroupItem *group = self.groups[section];
    
    return group.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    MGSettingCell *cell = [MGSettingCell cellWithTableView:tableView style:UITableViewCellStyleValue1];
    
    // 获取对应的组模型
    MGGroupItem *group = self.groups[indexPath.section];
    
    // 获取对应的行模型
    MGSettingItem *item = group.items[indexPath.row];
    
    // 2.给cell传递模型
    cell.item = item;
    
    if (indexPath.section == 2) {
        cell.detailTextLabel.text = [self getSize];
    }
    
    return cell;
}

// 返回每一组的头部标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // 获取组模型
    MGGroupItem *group = self.groups[section];
    
    return group.headerTitle;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    // 获取组模型
    MGGroupItem *group = self.groups[section];
    
    return group.footerTitle;
}

// 选中cell的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取出对应的组模型
    MGGroupItem *group = self.groups[indexPath.section];
    
    // 取出对应的行模型
    MGSettingItem *item = group.items[indexPath.row];
    
    if (item.operationBlock) {
        
        item.operationBlock(indexPath);
        
        return;
    }
    
    // 判断下是否需要跳转
    if ([item isKindOfClass:[MGArrowItem class]]) {
        
        // 箭头类型,才需要跳转
        
        MGArrowItem *arrowItem = (MGArrowItem *)item;
        
        if (arrowItem.descVcClass == nil) return;
        
        if ([arrowItem.descVcClass isSubclassOfClass:[HomeWebVC class]]) {
            // 创建跳转控制器
            HomeWebVC *vc = [[HomeWebVC alloc] initWithNavigationTitle:@"联系客服" withUrlStr:@"http://cs.9158.com/client_phone.aspx?type=button&uid=all&all&siteid=117&style=default&cid=&name=&sex=0&Random=1"];
            vc.view.backgroundColor = MGRandomRGBColor;
            [self.navigationController pushViewController:vc animated:YES];
        }else {
            // 创建跳转控制器
            UIViewController *vc = [[arrowItem.descVcClass alloc] init];
            vc.view.backgroundColor = MGRandomRGBColor;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

@end
