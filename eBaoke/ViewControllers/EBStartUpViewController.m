//
//  EBStartUpViewController.m
//  eBaoke
//
//  Created by Vencoo on 14-10-14.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBStartUpViewController.h"
#import "EBLoginViewController.h"

@interface EBStartUpViewController ()
{
    UIImageView *_carImg;
    
    CGFloat _startX;
    CGFloat _endX;
}
@end

@implementation EBStartUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, (IOSVersion>=7.0?KDeviceHeight:KDeviceHeight-20))];
    bgImg.image = [UIImage imageNamed:@"新增页面.png"];
    [self.view addSubview:bgImg];
    
    _carImg = [[UIImageView alloc] initWithFrame:CGRectMake(320, 380, 120, 40)];
    _carImg.image = [UIImage imageNamed:@"车辆列表-1.png"];
    [self.view addSubview:_carImg];
    
    for (int i=0; i<4; i++) {
        UIImageView *image =[[UIImageView alloc]init];
        if (i<2) {
            [image setFrame:CGRectMake(14*(i+1)+i*140, 80, 140, 139)];
        }else
        {
            [image setFrame:CGRectMake(14*(i-1)+(i-2)*140, 149+80, 140, 139)];
        }
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"新增页面%d.png",i+2]]];
        [self.view addSubview:image];
    }
    
    UIPanGestureRecognizer *swipe =[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipes:)];
    [self.view addGestureRecognizer:swipe];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Action
-(void)handleSwipes:(UIPanGestureRecognizer*)send
{
    if (send.state==UIGestureRecognizerStateBegan) {
        _startX =[send locationInView:send.view].x;
    }
    
    if (send.state!=UIGestureRecognizerStateEnded&&send.state!=UIGestureRecognizerStateFailed)
    {
        CGPoint point =[send locationInView:send.view];
        
        _carImg.frame = CGRectMake(point.x, 380, 120, 40);
    }
    
    if (send.state==UIGestureRecognizerStateEnded) {
        _endX =[send locationInView:send.view].x;
        
        if (_endX<=_startX) {
            [UIView animateWithDuration:0.5 animations:^{
                [_carImg setFrame:CGRectMake(-200, 380, 120, 40)];
            }completion:^(BOOL finished) {
             
                EBLoginViewController *login =[[EBLoginViewController alloc]init];
                   UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:login];
                [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar@2x.png"] forBarMetrics:UIBarMetricsDefault];
                [self presentViewController:navC animated:YES completion:^{
                    
                }];
               
            }];
        }else {
            [UIView animateWithDuration:0.5 animations:^{
                _carImg.frame = CGRectMake(320, 380, 120, 40);

            }completion:^(BOOL finished) {
               
                
            }];
        }
    }
}

@end
