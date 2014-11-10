//
//  EBPremiumViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumViewController.h"

#import "EBSelectOptionViewController.h"
#import "EBPremiumCalculateViewController.h"

@interface EBPremiumViewController ()
{
    
    __weak IBOutlet UIButton *_carTypeButton;
    __weak IBOutlet UIButton *_carUseNatureButton;
    __weak IBOutlet UIButton *_carTaxFlagButton;
    
    
    
}
@end

@implementation EBPremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"车辆列表" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"保费试算";
    self.navigationItem.titleView = titleLabel;
    
    [AppContext setTempContextValueByKey:kTempKeyCarType value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarUseNature value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarTaxFlag value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarTypeDes value:@"车辆种类"];
    [AppContext setTempContextValueByKey:kTempKeyCarUseNatureDes value:@"车辆使用性质"];
    [AppContext setTempContextValueByKey:kTempKeyCarTaxFlagDes value:@"车船税标志"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_carTypeButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarTypeDes] forState:UIControlStateNormal];
    [_carUseNatureButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarUseNatureDes] forState:UIControlStateNormal];
    [_carTaxFlagButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarTaxFlagDes] forState:UIControlStateNormal];
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
- (IBAction)typeAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车辆类型";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)propertyAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车辆使用性质";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)signAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车船税标志";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)calculateAction:(id)sender {
    
    [self checkInput];
}

- (void)checkInput
{
    if ([[AppContext getTempContextValueByKey:kTempKeyCarType] isEqualToString:@"-1"]) {
        [AppContext alertContent:@"请选择车辆种类"];
        return;
    }
    if ([[AppContext getTempContextValueByKey:kTempKeyCarUseNature] isEqualToString:@"-1"]) {
        [AppContext alertContent:@"请选择车辆使用性质"];
        return;
    }
    if ([[AppContext getTempContextValueByKey:kTempKeyCarTaxFlag] isEqualToString:@"-1"]) {
        [AppContext alertContent:@"请选择车船税标志"];
        return;
    }
    
    [self sendRequest];
}

- (void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserPremiumCalculate"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:_carModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyCarType] forKey:@"vehicle_type"];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyCarUseNature] forKey:@"nature_use"];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyCarTaxFlag] forKey:@"tax_flag"];
    
    [postDict setObject:@"premiumCalculate" forKey:@"select"];
    
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
    NSLog(@"cp-保费试算=%@",dict);
   
    if (![[dict objectForKey:@"ERR_MSG"] isEqualToString:@"成功"]) {
        [AppContext alertContent:[dict objectForKey:@"ERR_MSG"]];
    }
   
    NSArray *array = [dict objectForKey:@"calculateInfo"];
    
    if (array) {
        EBClaimsCaculateModel *model = [[EBClaimsCaculateModel alloc] initWithDic:dict];
        
        // 进入结果显示页面
        EBPremiumCalculateViewController *pVC = [[EBPremiumCalculateViewController alloc] initWithNibName:@"EBPremiumCalculateViewController" bundle:[NSBundle mainBundle]];
        model.taxStatus = [AppContext getTempContextValueByKey:kTempKeyCarTaxFlagDes];
        pVC.cModel = model;
        [self.navigationController pushViewController:pVC animated:YES];
    }
    
}

@end
