//
//  EBClaimsDetailViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsDetailViewController.h"

@interface EBClaimsDetailViewController ()
{
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UILabel *_statusLabel;
    
    __weak IBOutlet UILabel *_happenTimeLabel;
    
    __weak IBOutlet UILabel *_closedTimeLabel;
    
    __weak IBOutlet UILabel *_reparationAmountLabel;
    
    __weak IBOutlet UILabel *_driverNameLabel;
    
    __weak IBOutlet UILabel *_resDivisionLabel;
    
    __weak IBOutlet UILabel *_refusePayReasonLabel;
    
    __weak IBOutlet UILabel *_happenLocationLabel;
    
    __weak IBOutlet UITextView *_courseTextView;
    
    __weak IBOutlet UILabel *_reportDateLabel;
    
    __weak IBOutlet UILabel *_caseStartTimeLabel;
    
    UIBarButtonItem *_leftButtonItem;

    EBClaimsDetailModel *_cdModel;
}

@end

@implementation EBClaimsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"理赔明细";
    self.navigationItem.titleView = titleLabel;
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"理赔列表" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    [self sendRequest];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    _scrollView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64);
    _scrollView.layer.masksToBounds = YES;
    _scrollView.contentSize = CGSizeMake(320, 560);
    _scrollView.scrollEnabled = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserClaimDetailUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:_cModel.caseId forKey:@"case_id"];
    
    [postDict setObject:_cModel.caseType forKey:@"case_type"];
    
    [postDict setObject:@"claim_detail" forKey:@"select"];
    
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
    NSLog(@"cp-detail=%@",dict);
    
    if ([AppContext checkResponse:dict])
    {
        NSArray *array = [dict objectForKey:@"000:000"];
        
        _cdModel = [[EBClaimsDetailModel alloc] initWithArray:array];
        
        [self reflashDatas];
        
    }
    
}

- (void)reflashDatas
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CaseStatus" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    
    _statusLabel.text = [dict objectForKey:_cdModel.caseStatus];

    _happenTimeLabel.text = _cdModel.happenTime;
    _closedTimeLabel.text = _cdModel.closedTime;
    _reparationAmountLabel.text = _cdModel.reparationAmount;
    _driverNameLabel.text = _cdModel.driverName;
    _resDivisionLabel.text = _cdModel.resDivision;
    _refusePayReasonLabel.text = _cdModel.refusePayReason;
    _happenLocationLabel.text = _cdModel.happenLocation;
    _courseTextView.text = _cdModel.course;
    _reportDateLabel.text = _cdModel.reportDate;
    _caseStartTimeLabel.text = _cdModel.caseStartTime;
    
}

@end
