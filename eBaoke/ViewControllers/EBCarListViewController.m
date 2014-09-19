//
//  EBCarListViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarListViewController.h"
#import "Globals.h"
#import "EBCarListCell.h"
#import "EBCarListModel.h"
#import "EBCarDetailViewController.h"

#define kCancelButtonItem 101
#define kEditButtonItem 102

@interface EBCarListViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,carListCellButtonDelegate>
{
    UITableView *_tableView;
    
    MBProgressHUD *HUD;
    
    UIBarButtonItem *_leftButtonItem;
    UIBarButtonItem *_rightButtonItem;
    
    NSMutableArray *_dataArray;
    
}
@end

@implementation EBCarListViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"车辆列表", nil);
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:69 /  255.0 green:155 / 255.0 blue:206 / 255.0 alpha:1.0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sendRequest];
    self.view.backgroundColor = [UIColor grayColor];
    if (IOSVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.modalPresentationCapturesStatusBarAppearance=NO;
        self.navigationController.navigationBar.translucent =NO;
    }
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (IOSVersion>=7.0?-20:0), kDeviceWidth, KDeviceHeight-30) style:UITableViewStyleGrouped];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _rightButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonItem:)];
    _rightButtonItem.tag = kEditButtonItem;
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    _leftButtonItem.tag = kCancelButtonItem;
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
}

#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    switch (buttonItem.tag) {
        case kCancelButtonItem:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        default:
            break;
    }
}

- (void)rightButtonItem:(UIBarButtonItem *)buttonItem
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--1.10	账号/车辆绑定信息查询接口

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CatalogListServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:@"user_id"] forKey:@"user_id"];
    [postDict setObject:@"vehicle_list_query" forKey:@"select"];
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [AppContext didStartNetworking];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"加载中...";
        
    }else {
        [AppContext alertContent:error];
    }
}

#pragma mark - connection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    [AppContext alertContent:NSLocalizedString(@"连接错误,请稍后再试", nil)];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:data encoding:NSUTF8StringEncoding];
    NSLog(@"bangding%@",dict);

    
    if ([AppContext checkResponse:dict])
    {
        NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [_dataArray removeAllObjects];
        for (NSString *key in keys) {
            
                if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    NSMutableArray *keyVal = [dict objectForKey:key];
                    for (int i=0; i<[keyVal count]; i++) {
                        if ([[keyVal objectAtIndex:i]isEqualToString:@""]){
                            [keyVal removeObject:[keyVal objectAtIndex:i]];
                        }
                    }
                    EBCarListModel *model = [[EBCarListModel alloc]initWithArray:keyVal];
                    [_dataArray addObject:model];
                    NSLog(@"_dataArray=%@",_dataArray );
            }
            [_tableView reloadData];
        }
    }
}
#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{

    EBCarListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBCarListCell" owner:nil options:nil] objectAtIndex:0];
    cell.delegate = self;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EBCarListModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.plateLabel.text = model.plateNo;
    cell.ownLabel.text = model.carOwner;
    cell.ebgineLabel.text = model.engineNo;
    cell.VINLabel.text = model.vinCode;
    cell.insuranceButton.tag = indexPath.row;
    cell.PremiumButton.tag = indexPath.row;
    cell.violationButton.tag = indexPath.row;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBCarDetailViewController *detailVC = [[EBCarDetailViewController alloc]init];
    EBCarListModel *model = [_dataArray objectAtIndex:indexPath.row];
    detailVC.titleString = model.plateNo;
    detailVC.vehicleId = model.vehicleId;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma -mark carListCellButtonDelegate
- (void)pushToViewController:(UIViewController *)viewController
{
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
