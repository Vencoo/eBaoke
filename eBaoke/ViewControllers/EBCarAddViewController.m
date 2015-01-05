//
//  EBCarAddViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarAddViewController.h"

#import "EBCarTypeViewController.h"
#import "EBConfirmEditVC.h"

@interface EBCarAddViewController ()<UITextFieldDelegate>
{
    
    
    UIView *_contentView;
    
    UIButton *_isNewCarBtn;
    
    UIImageView *_isNewCheckImageView;
    
    UITextField *_nameTextField;
    
    UITextField *_idTextField;
    
    UITextField *_numberTextField;
    
    UIButton *_cateButton;
    
    BOOL _isNewCar;

    NSString *_plateNumberType;

    NSString *_plateNumberTypeDes;
    
}
@end

@implementation EBCarAddViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes value:@"号牌类型"];
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberType value:@"-1"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新增车辆";
    self.navigationItem.titleView = titleLabel;
    
    _lfBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 90, 26)];
    [_lfBtn addTarget:self action:@selector(leftButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_lfBtn setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_lfBtn setTitle:@"车辆列表" forState:UIControlStateNormal];
    _leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_lfBtn];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    _rgBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 26)];
    [_rgBtn addTarget:self action:@selector(rightButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    [_rgBtn setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [_rgBtn setTitle:@"保存" forState:UIControlStateNormal];
    _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rgBtn];
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
    [self.view addSubview:_contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTaped:)];
    [_contentView addGestureRecognizer:tap];
    
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
    bgView.image = [UIImage imageNamed:@"Register2.png"];
    [_contentView addSubview:bgView];
    
    _isNewCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(29, 80, 15, 15)];
    [_isNewCarBtn setImage:[UIImage imageNamed:@"remeberButton.png"] forState:UIControlStateNormal];
    [_isNewCarBtn addTarget:self action:@selector(isNewCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_isNewCarBtn];
    
    _isNewCheckImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, 80, 15, 15)];
    _isNewCheckImageView.image = [UIImage imageNamed:@"remeberYes.png"];
    _isNewCheckImageView.hidden = YES;
    [_contentView addSubview:_isNewCheckImageView];
    
    UIImageView *isNewCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 82, 60, 11)];
    isNewCarImg.image = [UIImage imageNamed:@"新增车辆-6.png"];
    [_contentView addSubview:isNewCarImg];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 115, 280, 20)];
    _nameTextField.placeholder = @"车主姓名";
    _nameTextField.tag = 101;
    _nameTextField.font = [UIFont systemFontOfSize:13];
    _nameTextField.delegate = self;
    [_contentView addSubview:_nameTextField];
    
    _idTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 155, 280, 20)];
    _idTextField.placeholder = @"身份证号码（15-18位）";
    _idTextField.tag = 102;
    _idTextField.font = [UIFont systemFontOfSize:13];
    _idTextField.delegate = self;
    [_contentView addSubview:_idTextField];
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 195, 280, 20)];
    _numberTextField.placeholder = @"号牌号码";
    _numberTextField.tag = 103;
    _numberTextField.font = [UIFont systemFontOfSize:13];
    _numberTextField.delegate = self;
    [_contentView addSubview:_numberTextField];
    
    _cateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cateButton.frame = CGRectMake(20, 240, 280, 40);
    [_cateButton setBackgroundImage:[UIImage imageNamed:@"cell_backgd.png"] forState:UIControlStateNormal];
    _cateButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _cateButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_cateButton setTitleColor:kColorLightBlue forState:UIControlStateNormal];

    [_cateButton addTarget:self action:@selector(cateAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cateButton];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _contentView.center = CGPointMake(160, 416/2);

    _plateNumberType = [AppContext getTempContextValueByKey:kTempKeyPlateNumberType];
    
    _plateNumberTypeDes = [AppContext getTempContextValueByKey:kTempKeyPlateNumberTypeDes];
    
    [_cateButton setTitle:_plateNumberTypeDes forState:UIControlStateNormal];
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

- (void)rightButtonItem:(UIBarButtonItem *)buttonItem
{
    // 完成
    [self checkSubmit];
    
}

- (void)checkSubmit
{
    if ([_nameTextField.text isEqualToString:@""]) {
        [AppContext alertContent:@"姓名不能为空"];
        return;
    }
    if (!(_idTextField.text.length == 15 || _idTextField.text.length == 18)) {
        [AppContext alertContent:@"身份证为15位或者18位"];
        return;
    }
    
    if (_isNewCar) {
        // 新车 无号牌
        if ([_numberTextField.text isEqualToString:@""]) {
            [AppContext alertContent:@"请填写发动机编号"];
            return;
        }
        
    }else {
        // 非新车 有号牌
        if ([_numberTextField.text isEqualToString:@""]) {
            [AppContext alertContent:@"请填写号牌号码"];
            return;
        }
        
        if ([_plateNumberType isEqualToString:@"-1"] || _plateNumberType ==nil) {
            [AppContext alertContent:@"号牌类型"];
            return;
        }
    }
    
    [self submitRequest];
}

- (void)submitRequest
{
    // 提交验证
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
   
    [postDict setObject:_nameTextField.text forKey:@"car_owner"];
    
    [postDict setObject:@"add_vehicle" forKey:@"select"];
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    
    // 检查标志
    [postDict setObject:@"3" forKey:@"process_flag"];
    
    if (_isNewCar) {
        [postDict setObject:_numberTextField.text forKey:@"engine_no"];
    } else{
        [postDict setObject:_numberTextField.text forKey:@"plate_no"];
        [postDict setObject:_plateNumberType forKey:@"plate_type"];
    }
    
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CricAddVehicleResp"]];
    
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

- (void)bgTaped:(UITapGestureRecognizer *)tap
{
    [_nameTextField resignFirstResponder];
    [_idTextField resignFirstResponder];
    [_numberTextField resignFirstResponder];
    
    _contentView.center = CGPointMake(160, 416/2);
}

- (void)cateAction:(UIButton *)btn
{
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];

    [self.navigationController pushViewController:ctvc animated:YES];
    
}

- (void)isNewCarAction:(UIButton *)btn
{
    _isNewCar = !_isNewCar;
    
    if (_isNewCar) {
        _isNewCheckImageView.hidden = NO;
        _numberTextField.text = @"";
        _numberTextField.placeholder = @"发动机编号";
        _cateButton.hidden = YES;
    }else {
        _isNewCheckImageView.hidden = YES;
        _numberTextField.text = @"";
        _numberTextField.placeholder = @"号牌号码";
        _cateButton.hidden = NO;
    }
}
#pragma mark - connection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
    NSLog(@"bangding1%@",dict);
    
    if ([AppContext checkResponse:dict])
    {
       
        if ([[dict allKeys]containsObject:@"errorDesc"]) {
            [AppContext alertContent:[dict objectForKey:@"errorDesc"]];
        }else {
            
            // 获取确认信息
            EBCarListModel *model = [[EBCarListModel alloc] init];
            model.carOwner = [dict objectForKey:@"car_owner"];
            model.engineNo = [dict objectForKey:@"engine_no"];
            model.vehicleId = [dict objectForKey:@"vehicle_id"];
            model.vinCode = [dict objectForKey:@"vin_code"];
            
            model.isNewCar = _isNewCar;
            
            // 因为不返回车牌号 所以这里记录下
            if (!_isNewCar) {
                model.plateNo = _numberTextField.text;
                model.plateType = _plateNumberType;
            }
            
            EBConfirmEditVC *vc = [[EBConfirmEditVC alloc] initWithNibName:@"EBConfirmEditVC" bundle:[NSBundle mainBundle]];
            vc.carModel = model;
            vc.addVC = self;
            [self presentViewController:vc animated:YES completion:^{
                
            }];
        }
        
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4) {
        
        if (textField.tag == 102) {
            _contentView.center = CGPointMake(160, 416/2-50);
        }
        if (textField.tag == 103) {
            _contentView.center = CGPointMake(160, 416/2-100);
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _contentView.center = CGPointMake(160, 416/2);
    
    return YES;
}

@end
