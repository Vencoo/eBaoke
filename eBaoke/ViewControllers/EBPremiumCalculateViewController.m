//
//  EBPremiumCalculateViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumCalculateViewController.h"

#import "EBViolationViewController.h"
#import "EBClaimsRecordViewController.h"

@interface EBPremiumCalculateViewController ()
{
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UILabel *_lab_0_0;
    
    __weak IBOutlet UILabel *_lab_1_0;
    __weak IBOutlet UILabel *_lab_1_1;
    __weak IBOutlet UILabel *_lab_1_2;
    __weak IBOutlet UILabel *_lab_1_3;
    
    __weak IBOutlet UILabel *_lab_2_0;
    
    __weak IBOutlet UILabel *_lab_3_0;
    __weak IBOutlet UILabel *_lab_3_1;
    __weak IBOutlet UILabel *_lab_3_2;
    
    __weak IBOutlet UILabel *_lab_4_0;
    
    __weak IBOutlet UILabel *_lab_5_0;
    
    __weak IBOutlet UILabel *_lab_6_0;
    
    __weak IBOutlet UILabel *_lab_7_0;
    
    __weak IBOutlet UILabel *_lab_8_0;
    
    __weak IBOutlet UILabel *_lab_9_0;
    
    __weak IBOutlet UILabel *_lab_10_0;
    
    __weak IBOutlet UILabel *_lab_11_0;
    
    __weak IBOutlet UILabel *_lab_12_0;
    
    UIBarButtonItem *_leftButtonItem;
    
    
}
@end

@implementation EBPremiumCalculateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"理赔明细";
    self.navigationItem.titleView = titleLabel;
    
    _leftButtonItem =[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonItem:)];
    self.navigationItem.leftBarButtonItem = _leftButtonItem;

    [self reflashDatas];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    _scrollView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64);
    _scrollView.layer.masksToBounds = YES;
    _scrollView.contentSize = CGSizeMake(320, 860);
    _scrollView.scrollEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Ation

- (IBAction)violationRecordAction:(id)sender {
    // 查看违章记录
    if ([_cModel.violationArray count] == 0) {
        return;
    }
    EBViolationViewController *vc = [[EBViolationViewController alloc] init];
    vc.dataArray = _cModel.violationArray;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (IBAction)claimsRecordAction:(id)sender {
    // 查看理赔记录
    if ([_cModel.cliamArray count] == 0) {
        return;
    }
    EBClaimsRecordViewController *vc = [[EBClaimsRecordViewController alloc] init];
    vc.dataArray = _cModel.cliamArray;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)leftButtonItem:(UIBarButtonItem *)buttonItem
{
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)reflashDatas
{
    if (_cModel) {
        _lab_0_0.text = _cModel.policyQueryNo;
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"CarItemsList" ofType:@"plist"];
        NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
        NSArray *array1 = [dict objectForKey:@"vehicleType"];
        for (NSDictionary *dic in array1) {
            if ([[dic objectForKey:@"itemKey"] isEqualToString:_cModel.vehicleType]) {
                _lab_1_0.text = [dic objectForKey:@"itemDescribe"];
                break;
            }
        }
        NSArray *array2 = [dict objectForKey:@"natureUse"];
        for (NSDictionary *dic in array2) {
            if ([[dic objectForKey:@"itemKey"] isEqualToString:_cModel.natureUse]) {
                _lab_1_1.text = [dic objectForKey:@"itemDescribe"];
                break;
            }
        }
        
        _lab_1_2.text = _cModel.trafficLimitLiability;
        _lab_1_3.text = [NSString stringWithFormat:@"%@ 至 %@",_cModel.startDate,_cModel.endDate];
        _lab_2_0.text = _cModel.basePremium;
        _lab_3_0.text = _cModel.plateNo;
        _lab_3_1.text = _cModel.engineNo;
        _lab_3_2.text = _cModel.vinCode;
        _lab_4_0.text = [NSString stringWithFormat:@"%d",[_cModel.violationArray count]];//违章次数
        _lab_5_0.text = [NSString stringWithFormat:@"%.0f",[_cModel.trafficAdjustModulus floatValue]*100];
        _lab_6_0.text = [NSString stringWithFormat:@"%d",[_cModel.cliamArray count]];//理赔记录次数
        _lab_7_0.text = [NSString stringWithFormat:@"%.0f",[_cModel.accidentAdjustModulus floatValue]*100];
        _lab_8_0.text = _cModel.premiumFormula;
        _lab_9_0.text = _cModel.limitPremium;
        _lab_10_0.text = _cModel.taxStatus;
        _lab_11_0.text = _cModel.travelTax;
        _lab_12_0.text = _cModel.payAmount;
    }
}
@end
