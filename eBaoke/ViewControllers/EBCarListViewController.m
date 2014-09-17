//
//  EBCarListViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarListViewController.h"

@interface EBCarListViewController ()<UITextFieldDelegate>

@end

@implementation EBCarListViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"车辆列表", nil);
    self.navigationItem.titleView = titleLabel;
    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark--1.10	账号/车辆绑定信息查询接口

-(void)sendRequest
{
//    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CricBindingQueryResp"]];
//    NSString *error;
//    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
//    [postDict setObject:[AppContext getTempContextValueByKey:@"user_id"] forKey:@"user_id"];
//    [postDict setObject:@"binding_query" forKey:@"select"];
//    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
//    [postDict release];
//    if (!error) {
//        NSLog(@"---- content %@", postContent);
//        TTURLRequest* request = [TTURLRequest requestWithURL: kRequestURLPath
//                                                    delegate: self];
//        request.httpMethod = @"POST";
//        request.httpBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
//        
//        // TTURLImageResponse is just one of a set of response types you can use.
//        // Also available are TTURLDataResponse and TTURLXMLResponse.
//        request.response = [[[TTURLDataResponse alloc] init] autorelease];
//        request.cachePolicy =TTURLRequestCachePolicyEtag;
//        [AppContext didStartNetworking];
//        [request send];
//        [self startLoading];
//    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
