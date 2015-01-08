//
//  EBCarEditViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarEditViewController.h"

#import "EBCarTypeViewController.h"
#import "EBConfirmEditVC.h"

@interface EBCarEditViewController ()<UITextFieldDelegate>
{
    NSString *_carType;
    
    NSString *_plateNumberType;
    
    NSString *_plateNumberTypeDes;
    
    IBOutlet UIButton *_cateButton;
    
    __weak IBOutlet UITextField *_nameTextField;
    
    __weak IBOutlet UITextField *_plateNumTextField;
    
    __weak IBOutlet UITextField *_engineTextField;
    
    EBCarListModel *carModel;

    UIView *affirmInfoView;
    
    UILabel *name_label;
    UILabel *engineNo_label;
    UILabel *vinCode_label;
    
    // 0Check 1Edit
    int _requestType;

}
@end

@implementation EBCarEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (_carModel1) {
        _nameTextField.text = _carModel1.carOwner;
        _plateNumTextField.text = _carModel1.plateNo;
        _engineTextField.text = _carModel1.engineNo;
    }
    
    carModel = [[EBCarListModel alloc] init];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CarTypeList" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *dataArray = [dict objectForKey:@"CarType"];
    
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes value:@"号牌类型 "];
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberType value:@"-1"];
    if (_carModel1.plateType) {
        for (NSDictionary *dic in dataArray) {
            if ([[dic objectForKey:@"CARMARK_CATEGORY_CODE"] isEqualToString:_carModel1.plateType]) {
                [AppContext setTempContextValueByKey:kTempKeyPlateNumberType
                                               value:[dic objectForKey:@"CARMARK_CATEGORY_CODE"]];
                [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes
                                               value:[dic objectForKey:@"CARMARK_CATEGORY_NAME"]];
                break;
            }
        }
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"编辑车辆";
    self.navigationItem.titleView = titleLabel;
    
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"返回" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    _rgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 26)];
    [_rgBtn addTarget:self action:@selector(rightButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_rgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [_rgBtn setTitle:@"完成" forState:UIControlStateNormal];
    _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rgBtn];
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _plateNumberType = [AppContext getTempContextValueByKey:kTempKeyPlateNumberType];
    
    _plateNumberTypeDes = [AppContext getTempContextValueByKey:kTempKeyPlateNumberTypeDes];
    
    [_cateButton setTitleColor:kColorLightBlue forState:UIControlStateNormal];
    [_cateButton setTitle:_plateNumberTypeDes forState:UIControlStateNormal];
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

- (void)rightButtonItem:(UIBarButtonItem *)buttonItem
{
    
    [self.view endEditing:YES];
    // 完成
    [self checkEdit];
    
}

- (void)checkEdit
{
    if([_nameTextField.text isEqualToString:@""]) {
        [AppContext alertContent:@"请填写车主信息"];
        return;
    }
    if ([_plateNumberType isEqualToString:@"-1"] && _plateNumTextField.text.length>0) {
        [AppContext alertContent:@"请填选择号牌类型"];
        return;
    }
    if (![_plateNumberType isEqualToString:@"-1"] && _plateNumTextField.text.length == 0) {
        [AppContext alertContent:@"请输入车牌号"];
        return;
    }
    
    [self submitRequestCheck];
    
}

- (IBAction)carTypeAction:(id)sender {
    
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];
    
    [self.navigationController pushViewController:ctvc animated:YES];
    
}
#pragma mark - 编辑请求

- (void)submitRequestCheck
{
    _requestType = 0;
    // 提交验证
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CricBindingQueryResp"]];
    
    [postDict setObject:@"binding_query" forKey:@"select"];
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    
    // 检查标志
    [postDict setObject:@"3" forKey:@"process_flag"];
    
    [postDict setObject:_nameTextField.text forKey:@"car_owner"];

    [postDict setObject:_engineTextField.text forKey:@"engine_no"];
    [postDict setObject:_plateNumTextField.text forKey:@"plate_no"];
    [postDict setObject:_plateNumberType forKey:@"plate_type"];
    
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    
    NSLog(@"%@",postContent);
    NSLog(@"---- kRequestURLPath %@", kRequestURLPath);
    _rData = [[NSMutableData alloc] init];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        NSURL *url = [NSURL URLWithString:kRequestURLPath];
        
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


- (void)submitRequestEdit
{
    _requestType = 1;
    // 提交Edit
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    [postDict setObject:carModel.carOwner forKey:@"car_owner"];
    
    // 新增
    
    [postDict setObject:@"binding_modify" forKey:@"select"];
        
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircBindingModifyResp"]];
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    
    [postDict setObject:carModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:carModel.userCarId forKey:@"usercar_id"];
    
    [postDict setObject:carModel.vinCode forKey:@"vin_code"];
    
    [postDict setObject:carModel.engineNo forKey:@"engine_no"];
    
    [postDict setObject:[carModel.plateNo uppercaseString] forKey:@"plate_no"];
    
    [postDict setObject:carModel.plateType forKey:@"plate_type"];
    
    // 确认标志
    [postDict setObject:@"2" forKey:@"process_flag"];
    
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    
    NSLog(@"%@",postDict);
    NSLog(@"%@",postContent);
    NSLog(@"---- kRequestURLPath %@", kRequestURLPath);
    _rData = [[NSMutableData alloc] init];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        NSURL *url = [NSURL URLWithString:kRequestURLPath];
        
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
    
    if (_requestType == 0) {
        NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
        
        if ([AppContext checkResponse:dict])
        {
            NSLog(@"数据接收成功URL=:%@",[connection.currentRequest.URL description]);
            
            NSString *str = [connection description];
            
            if ([str rangeOfString:@"BindingQuery"].length > 0) {
                // 处理列表
                NSLog(@"确认数据：%@",dict);
                
                //NSArray *array = [[dict allValues] firstObject];
                
                for (NSArray *array in [dict allValues]) {
                    if ([array isKindOfClass:[NSArray class]]) {
                        NSString *vId = [array objectAtIndex:0];
                        if ([vId isEqualToString:_carModel1.userCarId]) {

                            carModel = [[EBCarListModel alloc] initWithArray:array];
                            carModel.plateNo = _plateNumTextField.text;
                            carModel.plateType = _plateNumberType;
                            carModel.vehicleId = _carModel1.vehicleId;
                            
                            [self showAffirmInfoView];
                            name_label.text = carModel.carOwner;
                            vinCode_label.text = carModel.vinCode;
                            engineNo_label.text = carModel.engineNo;
                            
                            return;
                        }
                    }
                }
                [AppContext alertContent:@"错误数据无法提交"];
            }
        }
    }
    
    if (_requestType == 1) {
        NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
        NSLog(@"绑定成功%@",dict);
        
        if ([AppContext checkResponse:dict])
        {
            
            if ([[dict allKeys]containsObject:@"errorDesc"]) {
                [AppContext alertContent:[dict objectForKey:@"errorDesc"]];
            }else {
                // 新增成功
                [AppContext alertContent:@"编辑成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }

    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    return YES;
}

- (void)showAffirmInfoView {
    
    affirmInfoView = [[UIView alloc]initWithFrame:SCREEN_RECT];
    affirmInfoView.backgroundColor = [UIColor clearColor];
    
    [KEYWINDOW addSubview:affirmInfoView];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, affirmInfoView.frame.size.width, affirmInfoView.frame.size.height)];
    bg_view.backgroundColor = [UIColor blackColor];
    bg_view.alpha = 0.3;
    [affirmInfoView addSubview:bg_view];
    
    UIView *info_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 265, 288)];
    [affirmInfoView addSubview:info_view];
    info_view.center = affirmInfoView.center;
    
    UIImageView *bg_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 265, 288)];
    bg_image_view.image = [UIImage imageNamed:@"车辆绑定信息确认-2"];
    [info_view addSubview:bg_image_view];
    
    UIImageView *topimage = [[UIImageView alloc]initWithFrame:CGRectMake((265-110)/2, 25, 110, 18)];
    topimage.image = [UIImage imageNamed:@"车辆绑定信息确认-8"];
    [info_view addSubview:topimage];
    
    UIImageView *ownerInfo = [[UIImageView alloc]initWithFrame:CGRectMake(13, 60, 73, 119)];
    ownerInfo.image = [UIImage imageNamed:@"车辆绑定信息确认-3"];
    [info_view addSubview:ownerInfo];
    
    name_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMinY(ownerInfo.frame), 150, 17)];
    name_label.font = [UIFont systemFontOfSize:15];
    name_label.textColor = [UIColor grayColor];
    [info_view addSubview:name_label];
    
    engineNo_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMaxY(name_label.frame)+33, 150, 17)];
    engineNo_label.font = [UIFont systemFontOfSize:15];
    engineNo_label.textColor = [UIColor grayColor];
    [info_view addSubview:engineNo_label];
    
    vinCode_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMaxY(engineNo_label.frame)+36, 150, 17)];
    vinCode_label.font = [UIFont systemFontOfSize:15];
    vinCode_label.textColor = [UIColor grayColor];
    [info_view addSubview:vinCode_label];
    
    
    UIButton *affirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(ownerInfo.frame)+40, 63, 25)];
    [affirmButton setImage:[UIImage imageNamed:@"车辆绑定信息确认-17"] forState:UIControlStateNormal];
    [affirmButton addTarget:self action:@selector(affirmAction) forControlEvents:UIControlEventTouchDown];
    [info_view addSubview:affirmButton];
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(info_view.frame)-63-60, CGRectGetMaxY(ownerInfo.frame)+40, 63, 25)];
    [cancelButton setImage:[UIImage imageNamed:@"车辆绑定信息确认-7"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchDown];
    [info_view addSubview:cancelButton];
}

- (void)affirmAction {
    [affirmInfoView removeFromSuperview];
    
    [self submitRequestEdit];
}

- (void)cancelAction {
    
    [affirmInfoView removeFromSuperview];
}

@end
