//
//  EBViolationViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBViolationViewController.h"

#import "EBViolationCell.h"

@interface EBViolationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    
    MBProgressHUD *HUD;
    
    UIBarButtonItem *_leftButtonItem;
        
    NSMutableArray *_dataArray;
}
@end

@implementation EBViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (IOSVersion>=7.0?-20:0), kDeviceWidth, KDeviceHeight-30) style:UITableViewStyleGrouped];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 退出
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    EBViolationCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBViolationCell" owner:nil options:nil] objectAtIndex:0];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //EBCarListModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    //[cell setCarModel:model];
    
    return cell;
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
