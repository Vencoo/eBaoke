//
//  EBCarEditViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarEditViewController.h"

#import "EBCarTypeViewController.h"

@interface EBCarEditViewController ()
{
    
    UIBarButtonItem *_leftButtonItem;
    
    UIBarButtonItem *_rightButtonItem;
    
    NSString *_carType;
    
    IBOutlet UIButton *_cateButton;
    
}
@end

@implementation EBCarEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [AppContext setTempContextValueByKey:@"car_type" value:@"号牌类型"];
    
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
    
    _carType = [AppContext getTempContextValueByKey:@"car_type"];
    
    [_cateButton setTitle:_carType forState:UIControlStateNormal];
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
    // 退出
    //[self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)carTypeAction:(id)sender {
    
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];
    
    [self.navigationController pushViewController:ctvc animated:YES];
    
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
