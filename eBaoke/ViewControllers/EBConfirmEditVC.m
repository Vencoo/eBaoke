//
//  EBConfirmEditVC.m
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBConfirmEditVC.h"

@interface EBConfirmEditVC ()
{
 
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_engineLabel;
    IBOutlet UILabel *_frameLabel;
}

@end

@implementation EBConfirmEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    _nameLabel.text = _carModel.carOwner;
    _engineLabel.text = _carModel.engineNo;
    _frameLabel.text = _carModel.vinCode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender {
    
    [self submitRequest];
}
- (IBAction)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)submitRequest
{
    // 提交新增
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    [postDict setObject:_carModel.carOwner forKey:@"car_owner"];
    
    [postDict setObject:@"add_vehicle" forKey:@"select"];
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    
    [postDict setObject:_carModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:_carModel.vinCode forKey:@"vin_code"];

    [postDict setObject:_carModel.engineNo forKey:@"engine_no"];

    // 检查标志
    [postDict setObject:@"2" forKey:@"process_flag"];

    if (_carModel.isNewCar) {
    } else{
        [postDict setObject:_carModel.plateNo forKey:@"plate_no"];
        [postDict setObject:_carModel.plateType forKey:@"plate_type"];
    }
    
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CricAddVehicleResp"]];
    
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
    NSLog(@"绑定成功%@",dict);
    
    if ([AppContext checkResponse:dict])
    {
        
        if ([[dict allKeys]containsObject:@"errorDesc"]) {
            [AppContext alertContent:[dict objectForKey:@"errorDesc"]];
        }else {
            // 新增成功
            [AppContext alertContent:@"新增成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                if (_addVC) {
                    [_addVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
    }
}

@end
