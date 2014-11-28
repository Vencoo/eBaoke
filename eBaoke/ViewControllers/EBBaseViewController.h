//
//  EBBaseViewController.h
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Globals.h"

@interface EBBaseViewController : UIViewController
{
    MBProgressHUD *HUD;

    NSMutableData *_rData;
    
    // 导航右上角按钮
    UIButton *_rgBtn;
    
    // 导航左上角按钮
    UIButton *_lfBtn;
    
    UIBarButtonItem *_leftButtonItem;
    
    UIBarButtonItem *_rightButtonItem;
}

@property (nonatomic, assign) int vcType;

@end
