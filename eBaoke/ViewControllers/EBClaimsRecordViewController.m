//
//  EBClaimsRecordViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsRecordViewController.h"

#import "EBPremiumRecordCell.h"
#import "EBClaimsDetailViewController.h"

@interface EBClaimsRecordViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    UIBarButtonItem *_leftButtonItem;

    EBPremiumDetailModel *_pdModel;

}
@end

@implementation EBClaimsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"理赔记录";
    self.navigationItem.titleView = titleLabel;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorColor = [UIColor colorWithRed:221.0/255 green:221.0/255 blue:221.0/255 alpha:1.0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    _dataArray = [[NSMutableArray alloc] init];
    
    // 请求数据
    [self sendDetailRequest];
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
            NSArray *array = [[dict allValues] lastObject];
            NSLog(@"pd-info=%@",dict);
            
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
                    
//                    NSMutableArray *keyVal = [dict objectForKey:key];
//                    
//                    EBCarListModel *model = [[EBCarListModel alloc]initWithArray:keyVal];
//                    [_dataArray addObject:model];
                    
                }
            }
            
            [_tableView reloadData];
        }
    }
    
}

#pragma -mark UITableView delegate dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    EBPremiumRecordCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBPremiumRecordCell" owner:nil options:nil] objectAtIndex:0];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.numberLabel.text = @"2131231";
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBClaimsDetailViewController *cVC = [[EBClaimsDetailViewController alloc] initWithNibName:@"EBClaimsDetailViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:cVC animated:YES];
    
}

@end
