//
//  EBLoginViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBLoginViewController.h"
#import "EBRegisterViewController.h"
#import "MBProgressHUD.h"
#import "EBCarListViewController.h"
#import "EBSearchViewController.h"

#define loginButton 1
#define registerButton 2


@interface EBLoginViewController ()
{
    UIScrollView *_scrollView;
    
}
@end

@implementation EBLoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeNavBar];
    
    if (IOSVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.navigationController.navigationBar.translucent=NO;
    }
    
    _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(kDeviceWidth, KDeviceHeight);
    [_scrollView setScrollEnabled:NO];
    [self.view addSubview:_scrollView];

    
    _loginBackgroud = [[UIImageView alloc]initWithFrame:self.view.bounds];
    _loginBackgroud.userInteractionEnabled = YES;
    _loginBackgroud.image = [UIImage imageNamed:@"Login2.png"];
    [_scrollView addSubview:_loginBackgroud];
    
    _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerButton.frame = CGRectMake(kDeviceWidth-100, KDeviceHeight-130, 82, 37);
    [_registerButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    _registerButton.tag = registerButton;
    [_loginBackgroud addSubview:_registerButton];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginButton.frame = CGRectMake(10, _registerButton.top-80, kDeviceWidth-20, 37);
    _loginButton.tag = loginButton;
    [_loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"LoginBtn.png"] forState:UIControlStateNormal];
    [_loginButton setBackgroundImage:[UIImage imageNamed:@"LoginBtnPressed.png"] forState:UIControlStateHighlighted];
    [_loginBackgroud addSubview:_loginButton];
    
    _userName = [[UITextField alloc]initWithFrame:CGRectMake(37, _loginButton.top-165, kDeviceWidth-74, 31)];
    _userName.delegate = self;
    _userName.returnKeyType = UIReturnKeyDone;
    _userName.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _userName.placeholder = @"用户名/手机/邮箱";
    [_loginBackgroud addSubview:_userName];
    
    _userPassword = [[UITextField alloc]initWithFrame:CGRectMake(37, _userName.bottom+15, kDeviceWidth-74, 31)];
    _userPassword.delegate = self;
    _userPassword.returnKeyType = UIReturnKeyDone;
    _userPassword.placeholder = @"密码";
    _userPassword.secureTextEntry = YES;
    [_loginBackgroud addSubview:_userPassword];
    
    _rememberMe = [[UISwitch alloc]initWithFrame:CGRectMake(120, _userPassword.bottom+15, 100, 40)];
    [_rememberMe addTarget:self action:@selector(rememberMeSwitch:) forControlEvents:UIControlEventValueChanged];
    [_loginBackgroud addSubview:_rememberMe];
    
    UITapGestureRecognizer *tapGestureR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
    tapGestureR.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureR];
    
    if (![AppContext getPreferenceByKey:kRememberUser needMerge:NO]) {
        [AppContext setPreferenceByKey:kRememberUser value:kBoolYesFlag];
    }
    
    [_rememberMe setOn:[kBoolYesFlag isEqualToString:[AppContext getPreferenceByKey:kRememberUser needMerge:NO]]];
    
    if ([kBoolYesFlag isEqualToString:[AppContext getPreferenceByKey:kRememberUser needMerge:NO]]) {
        _userName.text = [AppContext getPreferenceByKey:kUsername needMerge:NO];
        _userPassword.text = [AppContext getPreferenceByKey:kUserPassword needMerge:NO];
    }

    
    [self layoutSubviews];
}

- (void)initializeNavBar

{
    
    // 1.取出设置主题的对象
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    
    
    // 2.设置导航栏的背景图片
    
    NSString *navBarBg = nil;
    
    if (IOSVersion>=7.0) { // iOS7
        
        navBarBg = @"NavBar64";
        
        
        
        // 设置导航栏的渐变色为白色（iOS7中返回箭头的颜色变为这个颜色：白色）
        
        navBar.tintColor = [UIColor whiteColor];
        
    } else { // 非iOS7
        
        navBarBg = @"NavBar";
        
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
        
        // 设置导航栏按钮的背景图片
        
        [barItem setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [barItem setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
        
        
        // 设置导航栏返回按钮的背景图片
        
        [barItem setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        
        [barItem setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
        
    }
    
    
    
    [navBar setBackgroundImage:[UIImage imageNamed:navBarBg] forBarMetrics:UIBarMetricsDefault];
    
    
    
    // 3.设置导航栏标题颜色为白色
    
    [navBar setTitleTextAttributes:@{UITextAttributeTextColor : [UIColor whiteColor]}];
    
    
    
    // 4.设置导航栏按钮文字颜色为白色
    
    [barItem setTitleTextAttributes:@{
                                      
                                      UITextAttributeTextColor : [UIColor whiteColor],
                                      
                                      UITextAttributeFont : [UIFont systemFontOfSize:17]
                                      
                                      }forState:UIControlStateNormal];
    
}


- (void)layoutSubviews
{
    if (IS_IPHONE_4) {

        _registerButton.frame = CGRectMake(kDeviceWidth-100, KDeviceHeight-110, 82, 37);
        _loginButton.frame = CGRectMake(10, _registerButton.top-72, kDeviceWidth-20, 37);
        if (IOSVersion<7.0) {
            _registerButton.frame = CGRectMake(kDeviceWidth-100, KDeviceHeight-110-20, 82, 37);
            _loginButton.frame = CGRectMake(10, _registerButton.top-62, kDeviceWidth-20, 37);
            
        }
        _userName.frame = CGRectMake(37, _loginButton.top-135, kDeviceWidth-74, 31);
        _userPassword.frame = CGRectMake(37, _userName.bottom+8, kDeviceWidth-74, 31);
        _rememberMe.frame = CGRectMake(120, _userPassword.bottom+8, 100, 40);

    }
}

- (void)buttonClick:(UIButton *)button
{
    switch (button.tag) {
        case loginButton:
            [self postToServer];
            break;
        case registerButton:
            [self registerNewCustom];
            
        default:
            break;
    }
}

- (void) rememberMeSwitch:(id)sender{
    [self dismissKeyboard:sender];
    
    if (_rememberMe.isOn) {
        [AppContext setPreferenceByKey:kRememberUser value:kBoolYesFlag];
    }else {
        [AppContext setPreferenceByKey:kRememberUser value:kBoolNoFlag];
    }
}

- (void)postToServer
{
    NSLog(@"postToServer---");
    if (![AppContext checkInput:_userName comment:NSLocalizedString(@"请输入用户名", nil)]) {
        return;
    }
    if (![AppContext checkInput:_userPassword comment:NSLocalizedString(@"请输入密码", nil)]) {
        return;
    }
    
    HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    HUD.labelText = @"正在登录...";
    
    NSString *kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserLoginUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSLog(@"---- kRequestURLPath %@", kRequestURLPath);
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    //NSLog(@"%@",_userName.text);
    //NSLog(@"%@",_userPassword.text);
    [postDict setObject:@"login" forKey:kPostContentTypeSelect];
    [postDict setObject:_userName.text forKey:kPostContentTypeUsername];
    [postDict setObject:_userPassword.text forKey:kPostContentTypePassword];
    [postDict setObject:[AppContext getTempContextValueByKey:kUniqueGlobalDeviceIdentifierKey] forKey:@"uuid"];
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    _rData = [[NSMutableData alloc] init];
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [connection start];
        [AppContext didStartNetworking];
        
    }else {
        [AppContext alertContent:error];
    }
}

#pragma mark - Button Action
- (void)registerNewCustom
{
    //    TTNavigator* navigator = [TTNavigator navigator];
    //    [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://newcustom"]];
    EBRegisterViewController *child = [[EBRegisterViewController alloc]init];
    [self.navigationController pushViewController:child animated:NO];
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = YES;
    animation.subtype = @"fromTop"; //过渡方向
    animation.type = @"cube";
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
}

#pragma mark - connection delegate

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [HUD hide:YES];
    [AppContext didStopNetworking];
     NSDictionary *dict = [AppContext nsDataToObject:_rData encoding:NSUTF8StringEncoding];
    NSLog(@"dict=%@",dict);
    if (![AppContext checkResponse:dict]) {
        return;
    }
    
    // 保存临时用户信息
    [AppContext setTempContextValueByKey:kTempKeyUserId value:[dict objectForKey:@"user_id"]];
    [AppContext setTempContextValueByKey:kTempKeyUserName value:[dict objectForKey:@"user_name"]];
    [AppContext setTempContextValueByKey:kTempKeyUserType value:[dict objectForKey:@"user_type"]];

    // 保存登陆信息
    [AppContext setPreferenceByKey:kUsername value:_userName.text];
    [AppContext setPreferenceByKey:kUserPassword value:_userPassword.text];

    // 根据用户类型 进入页面
    NSString *type = [dict objectForKey:@"user_type"];
    if (![type isEqualToString:@"2"]) {
        EBCarListViewController *vc1 = [[EBCarListViewController alloc] init];
        [self.navigationController pushViewController:vc1 animated:YES];

    }else {
        EBSearchViewController *vc2 = [[EBSearchViewController alloc] initWithNibName:@"EBSearchViewController" bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vc2 animated:YES];
    }
    
}

- (void) dismissKeyboard:(id)sender{
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.userName resignFirstResponder];
    [self.userPassword resignFirstResponder];
}


#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _userPassword || textField == _userName)
    {
        if (IS_IPHONE_4)
        {
            [_scrollView setContentOffset:CGPointMake(0, 100) animated:YES];
        }
        else if (IS_IPHONE_5)
        {
            [_scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == _userName)
    {
        [_userPassword becomeFirstResponder];
    }
    else
    {
        [self dismissKeyboard:nil];
        [self postToServer];
    }
    
    return YES;
}

@end
