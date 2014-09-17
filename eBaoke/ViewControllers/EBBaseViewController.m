//
//  EBBaseViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseViewController.h"

@interface EBBaseViewController ()

@end

@implementation EBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:55/255.0 green:157.0/255.0 blue:215.0/255.0 alpha:1];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//状态栏颜色为白色样式
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden
{
    return NO;
}

@end
