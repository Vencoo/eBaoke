//
//  EBBaseViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseViewController.h"
#import "Globals.h"

@interface EBBaseViewController ()

@end

@implementation EBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:55/255.0 green:157.0/255.0 blue:215.0/255.0 alpha:1];

    self.navigationController.navigationBar.hidden = NO;
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:69 /  255.0 green:155 / 255.0 blue:206 / 255.0 alpha:1.0];
  
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
