/*
    @header MGMyTaskViewController.m
 
    @abstract MGMiaoBo 关于源代码文件的一些基本描述
 
    @author Created by ming on 16/9/22.
 
    @简书：http://www.jianshu.com/users/57b58a39b70e/latest_articles
    @github：https://github.com/LYM-mg
 
   Copyright © 2016年 ming. All rights reserved.
 */

#import "MGMyTaskViewController.h"
#import "MGMyTaskCell.h"

static NSString *KMGMyTaskCell = @"KMGMyTaskCell";

@interface MGMyTaskViewController ()<UITableViewDataSource,UITableViewDelegate>
/** tableView */
@property (nonatomic,weak) UITableView *tableView;
/** 数据源 */
@property (nonatomic,strong) NSArray *dataArr;
@end

@implementation MGMyTaskViewController

#pragma mark - lazy
- (NSArray *)dataArr {
    if (_dataArr == nil) {
        _dataArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MyTask.plist" ofType:nil]];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpMainView];
}

- (void)setUpMainView {
    self.navigationItem.title = @"我的任务";
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, MGScreen_Width,self.view.height) style:UITableViewStyleGrouped];
    tableView.height = MGScreen_Height - tableView.origin.y;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = 90;
    [self.view addSubview:tableView];
    [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MGMyTaskCell class]) bundle:nil] forCellReuseIdentifier:KMGMyTaskCell];
    _tableView = tableView;
}

#pragma mark - Navigation
#pragma mark - <UITableViewDataSource,UITableViewDelegate>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *tempArr = self.dataArr[section];
    return tempArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MGMyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:KMGMyTaskCell];
    
    NSArray *tempArr = self.dataArr[indexPath.section];
    cell.dict = tempArr[indexPath.row];
   
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (1 == section) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MGScreen_Width, 36)];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8, 0, 0)];
        label.text = @"日常任务";
        label.textColor = [UIColor grayColor];
        [label sizeToFit];
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (1 == section)
        return 36;
    return 0;
}

@end
