//
//  EBInsuranceViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBInsuranceViewController.h"

@interface EBInsuranceViewController ()
{
    UITableView *_tableView;
    
    UISegmentedControl *_segmentedControl;
    
    MBProgressHUD *HUD;
}
@end

@implementation EBInsuranceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"保单列表", nil);
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:
                         [NSArray arrayWithObjects:
                          @"交强险",
                          @"商业险",
                          nil]];
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.frame = CGRectMake(5, 10, kDeviceWidth-10, 20);
    [_segmentedControl setBackgroundImage:[UIImage imageNamed:@"Segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    _segmentedControl.momentary = NO;
     _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentedControl.tintColor = [UIColor colorWithRed:255.0/255 green:131.0/255 blue:59.0/255 alpha:1.0];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    
    [self sendRequest];
    
    
    // Do any additional setup after loading the view.
}

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CarDetailServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:@"user_id"] forKey:@"user_id"];
    [postDict setObject:@"policy_list" forKey:@"select"];
    [postDict setObject:[AppContext getTempContextValueByKey:@"car_owner"] forKey:@"car_owner"];
    [postDict setObject:[AppContext getTempContextValueByKey:@"vehicle_id"] forKey:@"vehicle_id"] ;
    [postDict setObject:[AppContext getTempContextValueByKey:@"vin_code"] forKey:@"vin_code"] ;
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
    NSLog(@"dict=%@",dict);
    
    
    if ([AppContext checkResponse:dict])
    {
    }
}


#pragma -mark button action
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentAction:(UISegmentedControl*)segmentedControl
{
    
}

@end
