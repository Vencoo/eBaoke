//
//  EBInsuranceViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBInsuranceViewController.h"

#import "EBPremiumDetailViewController.h"
#import "EBPremiumCell.h"

@interface EBInsuranceViewController ()<UITableViewDataSource,UITableViewDelegate,premiumCellButtonDelegate>
{
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
    // 交强险
    NSMutableArray *_dataArray1;
    // 商业险
    NSMutableArray *_dataArray2;
    
    UISegmentedControl *_segmentedControl;
    
}
@end

@implementation EBInsuranceViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"保单列表", nil);
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (IOSVersion>=7.0?50:50), kDeviceWidth, KDeviceHeight-20-44-50) style:UITableViewStylePlain];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [[NSMutableArray alloc] init];
    _dataArray1 = [[NSMutableArray alloc] init];
    _dataArray2 = [[NSMutableArray alloc] init];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:
                         [NSArray arrayWithObjects:
                          @"交强险",
                          @"商业险",
                          nil]];
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.frame = CGRectMake(5, 10, kDeviceWidth-10, 30);
    [_segmentedControl setBackgroundImage:[UIImage imageNamed:@"Segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    _segmentedControl.momentary = NO;
     _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentedControl.tintColor = [UIColor colorWithRed:255.0/255 green:131.0/255 blue:59.0/255 alpha:1.0];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    
    [self sendRequest];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CarDetailServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:@"policy_list" forKey:@"select"];
    [postDict setObject:_carModel.carOwner forKey:@"car_owner"];
    [postDict setObject:_carModel.vehicleId forKey:@"vehicle_id"] ;
    [postDict setObject:_carModel.vinCode forKey:@"vin_code"] ;
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
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
    
    [_dataArray1 removeAllObjects];
    [_dataArray2 removeAllObjects];
    
    if ([AppContext checkResponse:dict])
    {
        for (NSArray *array in [dict allValues]) {
            EBPremiumModel *model = [[EBPremiumModel alloc] initWithArray:array];
            if (model.policyType == 1) {
                [_dataArray1 addObject:model];
            }else if (model.policyType == 2) {
                [_dataArray2 addObject:model];
            }
            
        }
        
        [self segmentAction:_segmentedControl];
    }
}


#pragma -mark button action
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentAction:(UISegmentedControl*)segmentedControl
{
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _tableView.alpha = 0.0;
    } completion:^(BOOL finished) {
        _tableView.alpha = 1.0;
        NSInteger index = _segmentedControl.selectedSegmentIndex;
        if (index == 0) {
            _dataArray = _dataArray1;
        }else if (index == 1)
        {
            _dataArray = _dataArray2;
        }
        [_tableView reloadData];
    }];
   
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    EBPremiumCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBPremiumCell" owner:nil options:nil] objectAtIndex:0];

    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EBPremiumModel *model = [_dataArray objectAtIndex:indexPath.row];
    [cell setPModel:model];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EBPremiumModel *pModel;
    NSInteger index = _segmentedControl.selectedSegmentIndex;
    switch (index) {
        case 0:
            pModel = [_dataArray1 objectAtIndex:indexPath.row];
            break;
        case 1:
            pModel = [_dataArray2 objectAtIndex:indexPath.row];
            break;
        default:
            return;
            break;
    }
    // 进入详情页面
    EBPremiumDetailViewController *pVC = [[EBPremiumDetailViewController alloc] initWithNibName:@"EBPremiumDetailViewController" bundle:[NSBundle mainBundle]];
    pVC.pModel = pModel;
    [self.navigationController pushViewController:pVC animated:YES];
    
}

- (void)cellClaimsRecordAction:(EBPremiumCell *)cell
{
    
}


@end
