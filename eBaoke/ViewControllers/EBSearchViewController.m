//
//  EBSearchViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBSearchViewController.h"

#import "EBCarListCell.h"
#import "EBCarDetailViewController.h"
#import "EBInsuranceViewController.h"
#import "EBPremiumViewController.h"
#import "EBViolationViewController.h"
#import "EBCarTypeViewController.h"

@interface EBSearchViewController ()<UITableViewDelegate,UITableViewDataSource,carListCellButtonDelegate,UITextFieldDelegate>
{
    
    __weak IBOutlet UITableView *_tableView;
    
    __weak IBOutlet UIView *_searchView;
    
    __weak IBOutlet UIView *_searchSubView;
    
    __weak IBOutlet UITextField *_plateNoTextField;
    
    __weak IBOutlet UIButton *_openButton;
    
    __weak IBOutlet UIButton *_plateTypeButton;
    
    __weak IBOutlet UITextField *_vinNoTextField;
    
    __weak IBOutlet UITextField *_carOwnerTextField;
    
    UIBarButtonItem *_leftButtonItem;
    UIBarButtonItem *_rightButtonItem;

    NSMutableArray *_dataArray;
    
    BOOL _isOpen;
    
    UILabel *_rightNavInfoLabel;
}
@end

@implementation EBSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
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
    
    self.view.backgroundColor = [UIColor grayColor];
    if (IOSVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.modalPresentationCapturesStatusBarAppearance=NO;
        self.navigationController.navigationBar.translucent =NO;
    }
    
    _dataArray = [[NSMutableArray alloc]init];
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"注销" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;

    _rightNavInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _rightNavInfoLabel.text = @"0个结果";
    _rightNavInfoLabel.textAlignment = NSTextAlignmentRight;
    _rightNavInfoLabel.textColor = [UIColor whiteColor];
    
    _rightButtonItem =[[UIBarButtonItem alloc]initWithCustomView:_rightNavInfoLabel];
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Background"]];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.frame = CGRectMake(0, 50, kDeviceWidth, KDeviceHeight-114);
    
    _searchSubView.frame = CGRectMake(0, 48, 320, 0);
    
    _searchSubView.layer.masksToBounds = YES;
    
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes value:@"号牌类型"];
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberType value:@"-1"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [_plateTypeButton setTitle:[AppContext getTempContextValueByKey:kTempKeyPlateNumberTypeDes] forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (IBAction)openAction:(id)sender {
    
    _isOpen = !_isOpen;
    
    [self checkOpen];
    
}

- (IBAction)plateTypeAction:(id)sender {
    
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];
    
    [self.navigationController pushViewController:ctvc animated:YES];
}

#pragma mark - Button Action

- (void)checkOpen
{
    if (_isOpen) {
        [UIView animateWithDuration:0.4 animations:^{
            _searchSubView.frame = CGRectMake(0, 48, 320, 140);
            _tableView.frame = CGRectMake(0, 50+140, kDeviceWidth, KDeviceHeight-114-140);

        } completion:^(BOOL finished) {
            [_openButton setImage:[UIImage imageNamed:@"Search-Option-advanced.png"] forState:UIControlStateNormal];
            
        }];
    }else {
        [UIView animateWithDuration:0.4 animations:^{
            _searchSubView.frame = CGRectMake(0, 48, 320, 0);
            _tableView.frame = CGRectMake(0, 50, kDeviceWidth, KDeviceHeight-114);

        } completion:^(BOOL finished) {
            [_openButton setImage:[UIImage imageNamed:@"Search-Option-simple.png"] forState:UIControlStateNormal];
        }];
    }
}

- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 注销按钮
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark -  1.10

-(void)getCarListRequest
{
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CatalogListServiceUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    [postDict setObject:@"vehicle_list_query" forKey:@"select"];
    
    if ([[AppContext getTempContextValueByKey:kTempKeyPlateNumberType] isEqualToString:@"-1"] || [[AppContext getTempContextValueByKey:kTempKeyPlateNumberType] isEqualToString:@"1000"]) {
       
    }else {
         [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyPlateNumberType] forKey:@"plate_type"];
    }
    
    [postDict setObject:_plateNoTextField.text forKey:@"plate_no"];
    
    [postDict setObject:_vinNoTextField.text forKey:@"vin_no"];
    
    [postDict setObject:_carOwnerTextField.text forKey:@"owner_name"];
    
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
        NSLog(@"数据接收成功URL=:%@",[connection.currentRequest.URL description]);
        
        NSString *str = [connection description];
        
        if ([str rangeOfString:@"CircCatalogList"].length > 0) {
            // 处理列表
            NSLog(@"1.10列表接口数据：%@",dict);
            // 获取列表 处理数据
            NSArray *keys = [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)];
            [_dataArray removeAllObjects];
            for (NSString *key in keys) {
                
                if ([[dict objectForKey:key] isKindOfClass:[NSArray class]]) {
                    
                    NSArray *keyVal = [dict objectForKey:key];
                    
                    EBCarListModel *model = [[EBCarListModel alloc]initWithArray1_10:keyVal];
                    [_dataArray addObject:model];
                    
                }
            }
            
            _rightNavInfoLabel.text = [NSString stringWithFormat:@"%d个结果",[_dataArray count]];
            [_tableView reloadData];
        }
    }
    
}


#pragma mark - UITableView delegate
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
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    if ([_dataArray count] == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, tableView.frame.size.height)];
//        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 50, 320, 132)];
//        imageV.image = [UIImage imageNamed:@"NoResultFound.png"];
//        [cell addSubview:imageV];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
        return cell;
    }
    
    EBCarListCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EBCarListCell" owner:nil options:nil] objectAtIndex:0];
    cell.delegate = self;
    cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    EBCarListModel *model = [_dataArray objectAtIndex:indexPath.row];
    
    [cell setCarModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    EBCarDetailViewController *detailVC = [[EBCarDetailViewController alloc]init];
    EBCarListModel *model = [_dataArray objectAtIndex:indexPath.row];
    detailVC.titleString = model.plateNo;
    detailVC.vehicleId = model.vehicleId;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma -mark carListCellDelegate

- (void)cellInsuranceAction:(EBCarListCell *)cell
{
    EBInsuranceViewController *insuranceVC = [[EBInsuranceViewController alloc]init];
    
    insuranceVC.carModel = cell.carModel;
    
    [self.navigationController pushViewController:insuranceVC animated:YES];
}

- (void)cellPremiumBAction:(EBCarListCell *)cell
{
    EBPremiumViewController *pVC = [[EBPremiumViewController alloc] initWithNibName:@"EBPremiumViewController" bundle:[NSBundle mainBundle]];
    
    pVC.carModel = cell.carModel;
    
    [self.navigationController pushViewController:pVC animated:YES];
}

- (void)cellViolationAction:(EBCarListCell *)cell
{
    EBViolationViewController *vVC = [[EBViolationViewController alloc] init];
    
    vVC.carModel = cell.carModel;
    
    [self.navigationController pushViewController:vVC animated:YES];
}

- (void)cellDeleteAction:(EBCarListCell *)cell
{
    // 查找不调用删除
}

#pragma mark - UItextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //搜索符合条件的内容
    [self checkInput];
    
    [textField resignFirstResponder];
    return YES;
}

- (void)checkInput
{
    // 满足有一项输入就可以搜索
    
    if (_plateNoTextField.text.length > 0 || _vinNoTextField.text.length >0 || _carOwnerTextField.text.length > 0) {
        [self getCarListRequest];
    }else {
        [AppContext alertContent:@"请至少输入一项有效数据"];
    }
    
}

@end
