//
//  EBPremiumDetailViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-26.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumDetailViewController.h"

@interface EBPremiumDetailViewController ()
{
    UIBarButtonItem *_leftButtonItem;

    // 保单号码
    __weak IBOutlet UILabel *_policyNoLabel;
    // 保险起期
    __weak IBOutlet UILabel *_startDateLabel;
    // 保险止期
    __weak IBOutlet UILabel *_endDateLabel;
    // 标准保费
    __weak IBOutlet UILabel *_normalFeeLabel;
    // 固定保费
    __weak IBOutlet UILabel *_fixedFeeLabel;
    // 赔偿限额
    __weak IBOutlet UILabel *_indemnityLabel;
    // 使用性质
    __weak IBOutlet UILabel *_useNatureLabel;
    // 机动车车主
    __weak IBOutlet UILabel *_carOwnerLabel;
    // 投保人
    __weak IBOutlet UILabel *_applicantLabel;
    // 被保险人
    __weak IBOutlet UILabel *_insuredLabel;
    // 签单日期
    __weak IBOutlet UILabel *_issueDateLabel;
}
@end

@implementation EBPremiumDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"保单信息";
    self.navigationItem.titleView = titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma -mark Button Action
- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
