//
//  EBCarTypeViewController.m
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-17.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarTypeViewController.h"

@interface EBCarTypeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation EBCarTypeViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initBackButton];
    [self initView];
    [self getTableViewData];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)initView
{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"车辆类型";
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-50) style:UITableViewStyleGrouped];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)getTableViewData
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarTypeList" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    _dataArray = [dict objectForKey:@"CarType"];
    NSLog(@"_dataArray = %@",_dataArray);
}

-(void)initBackButton {

    UIBarButtonItem *quitBtn = [[UIBarButtonItem alloc] initWithTitle:@"返回"style:UIBarButtonItemStyleBordered
                                                               target:self action:@selector(backAction:)];
    quitBtn.tintColor =[UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    self.navigationItem.leftBarButtonItem = quitBtn;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITableView delegate dataSource
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
    cell.textLabel.text = [[_dataArray objectAtIndex:indexPath.row]objectForKey:@"CARMARK_CATEGORY_NAME"];
    cell.textLabel.textColor = [UIColor colorWithRed:56.0/255 green:143.0/255 blue:205.0/255 alpha:1.0];
    UIView *selectionView = [[UIView alloc]initWithFrame:cell.bounds];
    [selectionView setBackgroundColor:[UIColor colorWithRed:56.0/255 green:143.0/255 blue:205.0/255 alpha:1.0]];
    cell.selectedBackgroundView = selectionView;
    cell.textLabel.highlightedTextColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberType value:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"CARMARK_CATEGORY_CODE"]];
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes value:[[_dataArray objectAtIndex:indexPath.row]objectForKey:@"CARMARK_CATEGORY_NAME"]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
