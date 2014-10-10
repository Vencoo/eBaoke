//
//  EBViolationViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBViolationViewController.h"

#import "EBViolationCell.h"

@interface EBViolationViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
        
    UIBarButtonItem *_leftButtonItem;
        
    NSMutableArray *_dataArray;

}
@end

@implementation EBViolationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dataArray = [[NSMutableArray alloc]init];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, (IOSVersion>=7.0?-20:0), kDeviceWidth, KDeviceHeight-30) style:UITableViewStyleGrouped];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"违章记录";
    self.navigationItem.titleView = titleLabel;
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    [self sendRequest];
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

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 250;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    EBViolationCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBViolationCell" owner:nil options:nil] objectAtIndex:0];
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EBViolationModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [cell setVModel:model];
    
    return cell;
}

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CarDetailServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:_carModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:@"voilation_list" forKey:@"select"];
    
    _rData = [[NSMutableData alloc] init];
    
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
    
    
    if ([AppContext checkResponse:dict])
    {
        
        // 处理详情
        NSLog(@"c-list=%@",dict);
        
        NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        [_dataArray removeAllObjects];
        for (NSString *key in keys) {
            
            if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                
                NSArray *keyVal = [dict objectForKey:key];
                
                EBViolationModel *model = [[EBViolationModel alloc]initWithArray:keyVal];
                [_dataArray addObject:model];
                
            }
        }
        
        [_tableView reloadData];
        
    }

}

@end
