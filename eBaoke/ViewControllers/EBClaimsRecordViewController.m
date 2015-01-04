//
//  EBClaimsRecordViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsRecordViewController.h"

#import "EBPremiumRecordCell.h"

#import "EBClaimRecordCell.h"

#import "EBClaimsDetailViewController.h"

@interface EBClaimsRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;

    

    EBPremiumDetailModel *_pdModel;

}
@end

@implementation EBClaimsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"理赔列表";
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"保单列表" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    if (self.vcType == 1) {
        [_lfBtn setTitle:@"返回" forState:UIControlStateNormal];
        _lfBtn.frame = CGRectMake(0, 0, 60, 26);
    }
    
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
        
        // 请求数据
        [self sendDetailRequest];
    }else {
        [_tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sendDetailRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CarDetailServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:_pModel.policyType forKey:@"policy_type"];
    
    [postDict setObject:_pModel.policyId forKey:@"policy_id"];
    
    [postDict setObject:@"policy_info" forKey:@"select"];
    
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    _rData = [[NSMutableData alloc] init];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        [AppContext didStartNetworking];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"加载中...";
        
    }else {
        [AppContext alertContent:error];
    }
}

-(void)sendRecordRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserClaimListUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:_pModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:_pdModel.comfirmSequenceNo forKey:@"comfirm_no"];
    
    [postDict setObject:@"claim_list" forKey:@"select"];
    
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    _rData = [[NSMutableData alloc] init];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        [AppContext didStartNetworking];
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"加载中...";
        
    }else {
        [AppContext alertContent:error];
    }
}

#pragma mark - connection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
  
    
    if ([AppContext checkResponse:dict])
    {
        
        NSString *str = [connection description];
        
        if ([str rangeOfString:@"CircCarDetail"].length > 0) {
            // 处理详情
            NSArray *array = [dict objectForKey:@"000:000"];
            
            _pdModel = [[EBPremiumDetailModel alloc] initWithArray:array];
            
            // 再请求列表
            [self sendRecordRequest];
        }
       
        if ([str rangeOfString:@"CricClaimList"].length > 0) {
            // 处理详情
            NSLog(@"pl-info=%@",dict);
            
            NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            [_dataArray removeAllObjects];
            for (NSString *key in keys) {
                
                if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *keyVal = [dict objectForKey:key];
                    
                    EBClaimsRecordModel *model = [[EBClaimsRecordModel alloc]initWithArray:keyVal];
                    [_dataArray addObject:model];
                    
                }
            }
            
            [_tableView reloadData];
        }
    }
    
}

#pragma -mark UITableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_dataArray count] == 0) {
        return 1;
    }
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataArray count] == 0) {
        return tableView.frame.size.height;
    }
    return 98.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if ([_dataArray count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 132)];
        imageV.image = [UIImage imageNamed:@"NoResultFound.png"];
        [cell addSubview:imageV];
        return cell;
    }
    
    UITableViewCell *cell;
    
    if (self.vcType == 1) {
        EBPremiumRecordCell *cell1 = [[[NSBundle mainBundle] loadNibNamed:@"EBPremiumRecordCell" owner:nil options:nil] objectAtIndex:0];
        
        cell1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        EBClaimsRecordModel *cModel = [_dataArray objectAtIndex:indexPath.row];
        cell1.cModel = cModel;
        
        cell = cell1;

    }else {
        EBClaimRecordCell *cell1 = [[[NSBundle mainBundle] loadNibNamed:@"EBClaimRecordCell" owner:nil options:nil] objectAtIndex:0];
        
        cell1.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
        cell1.selectionStyle = UITableViewCellSelectionStyleNone;
        
        EBClaimsRecordModel *cModel = [_dataArray objectAtIndex:indexPath.row];
        cell1.cModel = cModel;
        
        cell = cell1;
    }

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBClaimsRecordModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    if ([model.caseId isEqualToString:@""] || model.caseId == nil) {
        return;
    }
    
    EBClaimsDetailViewController *cVC = [[EBClaimsDetailViewController alloc] initWithNibName:@"EBClaimsDetailViewController" bundle:[NSBundle mainBundle]];
    cVC.cModel = model;
    [self.navigationController pushViewController:cVC animated:YES];
    
}

@end
