//
//  EBClaimsDetailViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsDetailViewController.h"

@interface EBClaimsDetailViewController ()
{
    __weak IBOutlet UIScrollView *_scrollView;
    
    __weak IBOutlet UILabel *_statusLabel;
    
    __weak IBOutlet UILabel *_happenTimeLabel;
    
    __weak IBOutlet UILabel *_closedTimeLabel;
    
    __weak IBOutlet UILabel *_reparationAmountLabel;
    
    __weak IBOutlet UILabel *_driverNameLabel;
    
    __weak IBOutlet UILabel *_resDivisionLabel;
    
    __weak IBOutlet UILabel *_refusePayReasonLabel;
    
    __weak IBOutlet UILabel *_happenLocationLabel;
    
    __weak IBOutlet UILabel *_courseLabel;
    
    __weak IBOutlet UILabel *_reportDateLabel;
    
    __weak IBOutlet UILabel *_caseStartTimeLabel;
    
    
    UIBarButtonItem *_leftButtonItem;

}

@end

@implementation EBClaimsDetailViewController

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
 
    _scrollView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight-64);
    _scrollView.layer.masksToBounds = YES;
    _scrollView.contentSize = CGSizeMake(320, 540);
    _scrollView.scrollEnabled = YES;
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


@end
