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

@interface EBCarEditViewController ()
{
    
    UIBarButtonItem *_leftButtonItem;
    
    UIBarButtonItem *_rightButtonItem;
    
    NSString *_carType;
    
    NSString *_plateNumberType;
    
    NSString *_plateNumberTypeDes;
    
    IBOutlet UIButton *_cateButton;
    
    __weak IBOutlet UITextField *_nameTextField;
    
    __weak IBOutlet UITextField *_plateNumTextField;
    
    __weak IBOutlet UITextField *_engineTextField;
    
    EBCarListModel *_getCarModel;

}
@end

@implementation EBCarEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberTypeDes value:@"号牌类型"];
    [AppContext setTempContextValueByKey:kTempKeyPlateNumberType value:@"-1"];
    
    if (_carModel) {
        _nameTextField.text = _carModel.carOwner;
        _plateNumTextField.text = _carModel.plateNo;
        _engineTextField.text = _carModel.engineNo;
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"编辑车辆";
    self.navigationItem.titleView = titleLabel;
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    _rightButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonItem:)];
    self.navigationItem.rightBarButtonItem = _rightButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightButtonItem:(UIBarButtonItem *)buttonItem
{
    // 完成
    [self checkEdit];
    
}

- (void)checkEdit
{
    if([_nameTextField.text isEqualToString:@""]) {
        [AppContext alertContent:@"请填写车主信息"];
        return;
    }
    
    [self submitRequest];
    
}

- (IBAction)carTypeAction:(id)sender {
    
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];
    
    [self.navigationController pushViewController:ctvc animated:YES];
    
}
#pragma mark - 编辑请求

- (void)submitRequest
{
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
                    if ([vId isEqualToString:_carModel.userCarId]) {
                        _getCarModel = [[EBCarListModel alloc] initWithArray:array];
                        _getCarModel.vehicleId = _carModel.vehicleId;
                        // 进入确认界面
                        EBConfirmEditVC *vc = [[EBConfirmEditVC alloc] initWithNibName:@"EBConfirmEditVC" bundle:[NSBundle mainBundle]];
                        vc.carModel = _getCarModel;
                        vc.isEditAction = YES;
                        vc.addVC = self;
                        [self presentViewController:vc animated:YES completion:^{
                            
                        }];
                        
                        return;
                    }
                }
            }
            [AppContext alertContent:@"错误数据无法提交"];
        }
       
    }else {
        [AppContext alertContent:@"返回数据错误"];
    }
}

@end
