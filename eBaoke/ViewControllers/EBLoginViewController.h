//
//  EBLoginViewController.h
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//
/**********
 登陆
 **********/
#import "EBBaseViewController.h"

@interface EBLoginViewController : EBBaseViewController<UITextFieldDelegate>

@property(nonatomic)  UIImageView *loginBackgroud;

@property(nonatomic)  UITextField *userName;
@property(nonatomic)  UITextField *userPassword;
@property(nonatomic)  UISwitch    *rememberMe;
@property(nonatomic)  UIButton    *loginButton;
@property(nonatomic)  UIButton    *registerButton;

@end
