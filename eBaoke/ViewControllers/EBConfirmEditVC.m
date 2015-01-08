//
//  EBConfirmEditVC.m
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBConfirmEditVC.h"

#import "EBRegisterViewController.h"

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

    _nameLabel.text = _carModel.carOwner;
    _engineLabel.text = _carModel.engineNo;
    _frameLabel.text = _carModel.vinCode;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)confirmAction:(id)sender {
    if (self.vcType == 1) {
        [self dismissViewControllerAnimated:YES completion:^{
            EBRegisterViewController *vc = (EBRegisterViewController *)_addVC;
            
        }];
        return;
    }
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
    
    if (_isEditAction) {
        [postDict setObject:@"binding_modify" forKey:@"select"];
        
        kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircBindingModifyResp"]];
    }else {
        [postDict setObject:@"add_vehicle" forKey:@"select"];
        
        kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CricAddVehicleResp"]];
    }
    
    [postDict setObject:[AppContext getTempContextValueByKey:kTempKeyUserId] forKey:@"user_id"];
    
    [postDict setObject:_carModel.vehicleId forKey:@"vehicle_id"];
    
    [postDict setObject:_carModel.userCarId forKey:@"usercar_id"];

    [postDict setObject:_carModel.vinCode forKey:@"vin_code"];

    [postDict setObject:_carModel.engineNo forKey:@"engine_no"];

    [postDict setObject:[_carModel.plateNo uppercaseString] forKey:@"plate_no"];
    
    [postDict setObject:_carModel.plateType forKey:@"plate_type"];
    
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
    
    NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
    NSLog(@"绑定成功%@",dict);
    
    if ([AppContext checkResponse:dict])
    {
        
        if ([[dict allKeys]containsObject:@"errorDesc"]) {
            [AppContext alertContent:[dict objectForKey:@"errorDesc"]];
        }else {
            // 新增成功
            [AppContext alertContent:@"操作成功"];
            [self dismissViewControllerAnimated:YES completion:^{
                if (_addVC) {
                    [_addVC.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        
    }
}

@end
