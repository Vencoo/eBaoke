//
//  EBSelectOptionViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-25.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBSelectOptionViewController.h"

@interface EBSelectOptionViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_dataArray;
    
    UIBarButtonItem *_leftButtonItem;

}
@end

@implementation EBSelectOptionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-50) style:UITableViewStyleGrouped];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [NSArray array];

    [self getTableViewData];
    
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _navTitle;
    self.navigationItem.titleView = titleLabel;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 退出
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)getTableViewData
{
    
    if ([_navTitle isEqual:@"车辆类型"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CarItemsList" ofType:@"plist"];
        NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
        _dataArray = [dict objectForKey:@"vehicleType"];
        NSLog(@"_dataArray = %@",_dataArray);
    }
    
    if ([_navTitle isEqual:@"车辆使用性质"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CarItemsList" ofType:@"plist"];
        NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
        _dataArray = [dict objectForKey:@"natureUse"];
        NSLog(@"_dataArray = %@",_dataArray);
    }
    
    if ([_navTitle isEqual:@"车船税标志"]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CarItemsList" ofType:@"plist"];
        NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
        _dataArray = [dict objectForKey:@"taxFlag"];
        NSLog(@"_dataArray = %@",_dataArray);
    }
    [_tableView reloadData];
}


#pragma mark - UITableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"itemDescribe"];
    cell.textLabel.textColor = [UIColor colorWithRed:56.0/255 green:143.0/255 blue:205.0/255 alpha:1.0];
    UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
    [selectionView setBackgroundColor:[UIColor colorWithRed:56.0/255 green:143.0/255 blue:205.0/255 alpha:1.0]];
    cell.selectedBackgroundView = selectionView;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [AppContext setTempContextValueByKey:@"car_type" value:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"CARMARK_CATEGORY_NAME"]];
    
    NSString *selected_plate_type = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"CARMARK_CATEGORY_CODE"];
    
    [[NSUserDefaults standardUserDefaults]setObject:selected_plate_type forKey:@"selected_plate_type"];
    
    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"CarCategorySymbol"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
