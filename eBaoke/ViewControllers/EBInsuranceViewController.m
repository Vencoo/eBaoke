//
//  EBInsuranceViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBInsuranceViewController.h"
#import "Globals.h"

@interface EBInsuranceViewController ()
{
    UITableView *_tableView;
    
    UISegmentedControl *_segmentedControl;
}
@end

@implementation EBInsuranceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = NSLocalizedString(@"保单列表", nil);
    self.navigationItem.titleView = titleLabel;
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:
                         [NSArray arrayWithObjects:
                          @"交强险",
                          @"商业险",
                          nil]];
    [_segmentedControl addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.frame = CGRectMake(5, 0, kDeviceWidth-10, 30);
    [_segmentedControl setBackgroundImage:[UIImage imageNamed:@"Segment_bg"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
     _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    _segmentedControl.tintColor = [UIColor colorWithRed:255.0/255 green:131.0/255 blue:59.0/255 alpha:1.0];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    
    
    // Do any additional setup after loading the view.
}

#pragma -mark button action
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)segmentAction:(UISegmentedControl*)segmentedControl
{
    
}

@end
