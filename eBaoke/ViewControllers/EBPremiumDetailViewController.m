//
//  EBPremiumDetailViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-26.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumDetailViewController.h"

@interface EBPremiumDetailViewController ()
{
    
    EBPremiumDetailModel *_pdModel;

    // 保单号码
    __weak IBOutlet UILabel *_policyNoLabel;
    // 保险起期
    __weak IBOutlet UILabel *_startDateLabel;
    // 保险止期
    __weak IBOutlet UILabel *_endDateLabel;
    // 标准保费
    __weak IBOutlet UILabel *_normalFeeLabel;
    // 固定保费
    __weak IBOutlet UILabel *_fixedFeeLabel;
    // 赔偿限额
    __weak IBOutlet UILabel *_indemnityLabel;
    // 使用性质
    __weak IBOutlet UILabel *_useNatureLabel;
    // 机动车车主
    __weak IBOutlet UILabel *_carOwnerLabel;
    // 投保人
    __weak IBOutlet UILabel *_applicantLabel;
    // 被保险人
    __weak IBOutlet UILabel *_insuredLabel;
    // 签单日期
    __weak IBOutlet UILabel *_issueDateLabel;
}
@end

@implementation EBPremiumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"保单列表" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"保单信息";
    self.navigationItem.titleView = titleLabel;
    
    [self sendRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)sendRequest
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

#pragma mark - connection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
    NSLog(@"p-info=%@",dict);
    
    if ([AppContext checkResponse:dict])
    {
        NSArray *array = [dict objectForKey:@"000:000"];

        _pdModel = [[EBPremiumDetailModel alloc] initWithArray:array];
        
        [self reflashDatas];
    }
    
}

- (void)reflashDatas
{
    _policyNoLabel.text = _pdModel.policyNo;
    _startDateLabel.text = _pdModel.startDate;
    _endDateLabel.text = _pdModel.endDate;
    _normalFeeLabel.text = _pdModel.standardPremium;
    _fixedFeeLabel.text = _pdModel.basedPremium;
    _indemnityLabel.text = _pdModel.limitAmount;
    _useNatureLabel.text = _pdModel.useType;
    _carOwnerLabel.text = _pdModel.carOwner;
    _applicantLabel.text = _pdModel.policyHolder;
    _insuredLabel.text = _pdModel.insured;
    _issueDateLabel.text = _pdModel.signDate;
    
}

#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
