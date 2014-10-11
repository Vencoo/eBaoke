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
    
    __weak IBOutlet UIButton *_carTypeButton;
    __weak IBOutlet UIButton *_carUseNatureButton;
    __weak IBOutlet UIButton *_carTaxFlagButton;
    
    
    UIBarButtonItem *_leftButtonItem;
    
}
@end

@implementation EBPremiumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"保费试算";
    self.navigationItem.titleView = titleLabel;
    
    [AppContext setTempContextValueByKey:kTempKeyCarType value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarUseNature value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarTaxFlag value:@"-1"];
    [AppContext setTempContextValueByKey:kTempKeyCarTypeDes value:@"车辆种类"];
    [AppContext setTempContextValueByKey:kTempKeyCarUseNatureDes value:@"车辆使用性质"];
    [AppContext setTempContextValueByKey:kTempKeyCarTaxFlagDes value:@"车船税标志"];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_carTypeButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarTypeDes] forState:UIControlStateNormal];
    [_carUseNatureButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarUseNatureDes] forState:UIControlStateNormal];
    [_carTaxFlagButton setTitle:[AppContext getTempContextValueByKey:kTempKeyCarTaxFlagDes] forState:UIControlStateNormal];
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
    //6
    //非营运 个人
    //纳税
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
