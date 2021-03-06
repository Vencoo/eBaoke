//
//  EBCarDetailViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarDetailViewController.h"
#import "EBCarDetailModel.h"

@interface EBCarDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
}
@end

@implementation EBCarDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOSVersion>=7.0)
    {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.navigationController.navigationBar.translucent=NO;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = _titleString;
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:69 /  255.0 green:155 / 255.0 blue:206 / 255.0 alpha:1.0];
    
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"车辆列表" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;

    _dataArray = [[NSMutableArray alloc]init];

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64) style:UITableViewStylePlain];
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self sendRequest];
}

-(void)sendRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CarDetailServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    [postDict setObject:@"vehicle_detail" forKey:@"select"];
    
    [postDict setObject:_vehicleId forKey:@"vehicle_id"];
    
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
    NSLog(@"dict=%@",dict);
    if ([AppContext checkResponseDoNotShowError:dict]) {
        NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        [_dataArray removeAllObjects];
        for (NSString *key in keys) {
            
            if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                NSArray *keyVal = [dict objectForKey:key];
                [_dataArray addObject:keyVal];
            }
            [_tableView reloadData];
        }
    }else {
        [_dataArray removeAllObjects];
//        for (int i = 0; i<13; i++) {
//            NSArray *arr = [[NSArray alloc] initWithObjects:@"",@"", nil];
//            [_dataArray addObject:arr];
//        }
        [_tableView reloadData];
    }
}

#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _dataArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if (_dataArray.count == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 132)];
        imageV.image = [UIImage imageNamed:@"NoResultFound.png"];
        [cell addSubview:imageV];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }

    UITableViewCell  *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    NSString *imageStr = [NSString stringWithFormat:@"CarDetail_r%d_c1.png",(int)indexPath.row+1];
    cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imageStr]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0 || indexPath.row==_dataArray.count+1) {
        cell.textLabel.text = @"";
    }
    else
    {
        UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 0, kDeviceWidth-20, 20)];
        textLabel.text = [[_dataArray objectAtIndex:indexPath.row-1]objectAtIndex:1];
        textLabel.backgroundColor = [UIColor clearColor];
        textLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:textLabel];
        
    }
   
    return cell;
}


@end
