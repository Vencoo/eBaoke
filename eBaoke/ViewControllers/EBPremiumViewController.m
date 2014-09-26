//
//  EBPremiumViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumViewController.h"

#import "EBSelectOptionViewController.h"

@interface EBPremiumViewController ()
{
    
    UIBarButtonItem *_leftButtonItem;
    
}
@end

@implementation EBPremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
   
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
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
- (IBAction)typeAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车辆类型";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)propertyAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车辆使用性质";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)signAction:(id)sender {
    EBSelectOptionViewController *sVC = [[EBSelectOptionViewController alloc] init];
    sVC.navTitle = @"车船税标志";
    [self.navigationController pushViewController:sVC animated:YES];
}

- (IBAction)calculateAction:(id)sender {
    
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
