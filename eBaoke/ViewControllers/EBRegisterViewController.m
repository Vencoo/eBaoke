//
//  EBRegisterViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBRegisterViewController.h"
#import "MBProgressHUD.h"
#import "EBCarTypeViewController.h"

#define numOfRows 4
#define sendMsgTime 60
#define ksendTypeFinishRegister  @"finishRegister"
#define ksendTypeUploadInfo  @"uploadInfo"
#define ksendTypeUserNameCheck  @"userNameCheck"
#define ksendTypeEmailCheck  @"emailCheck"
#define ksendTypePhoneCheck  @"phoneCheck"
#define ksendTypeOwnerIdCheck  @"ownerIdCheck"
#define ksendTypeReSMS  @"ReSMS"

#define kCarDataRequest 1002

@interface EBRegisterViewController ()<UITextFieldDelegate,UIAlertViewDelegate>
{
    int current_page;
    int total_page;
    int k;
    int reSendCount;
    UIBarButtonItem *lastPage;
    UIBarButtonItem *nextPage;
    UIBarButtonItem *backBtn;
    UIBarButtonItem *finishBtn;
    NSTimer *time;
    int second;
    UIButton *resendBtn;
    NSArray *infoArray;
    NSArray *registerArray;
    UIButton *carTypeBtn;
    NSString *sendType;
    BOOL existErr;
    BOOL isNewCarBtnTouched;
    UIImageView *isNewCarImage;
    
    UIView *affirmInfoView;
    //车主姓名
    NSString *owner_name;
    //车主身份证号码
    NSString *owner_id_num;
    //发动机号码
    NSString *car_engine_num;
    //车牌号码
    NSString *car_plate_num;
    //车牌号码种类
    NSString *car_plate_category;
    //车架号
    NSString *vinCode;
    
    UILabel *name_label;
    UILabel *engineNo_label;
    UILabel *vinCode_label;
    
    NSString *selected_plate_type;
    
    //标记请求类型
    int requestTag;
}
@end

@implementation EBRegisterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.text = @"免费注册";
    self.navigationItem.titleView = titleLabel;

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Background.png"]];
    
    if (current_page == 2) {
        if ([AppContext getTempContextValueByKey:@"car_type"]) {
            [carTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [carTypeBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
            [carTypeBtn setTitle:[AppContext getTempContextValueByKey:@"car_type"] forState:UIControlStateNormal];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (IOSVersion>=7.0) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
        self.navigationController.navigationBar.translucent = NO;
    }
    
    isNewCarBtnTouched=NO;
    
    total_page = 3;
    current_page = 1;
    k = 0;
    sendType = @"";
    [self.navigationController.navigationBar setHidden:NO];
    lastPage = [[UIBarButtonItem alloc]initWithTitle:@"上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(lastToPage)];
    nextPage = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextToPage)];
    backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];                                        //UIBarButtonItemStylePlain
    finishBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishRegister)];
    
    lastPage.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    nextPage.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    backBtn.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    finishBtn.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = nextPage;
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
    infoArray = [[NSArray alloc]initWithObjects:@"用户名 (3-16个字符)",@"手机号码 (11位数字)",@"电子邮箱",@"密码 (6位以上)",@"确认密码",@"车主姓名",@"身份证号码 (15位或18位)",@"号牌号码",@"号牌类型", nil];
    registerArray = [[NSArray alloc]initWithObjects:@"username",@"tel_no",@"email",@"password",@"surepassword",@"car_owner",@"id",@"plate_no",@"plate_type", nil];
    
    [self reloadView];


}

#pragma mark - Button Action
- (void)back
{
    CATransition *animation = [CATransition animation];
    animation.delegate = self;
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = YES;
    animation.subtype = @"fromBottom"; //过渡方向
    animation.type = @"cube";
    [self.navigationController.view.layer addAnimation:animation forKey:@"animation"];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)lastToPage{
    if (current_page == 3) {
        k = 0;
    }
    UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
    [UIView beginAnimations:@"animationID" context:nil];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationDidStopSelector:@selector(lastAnimationDidStop)];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:lastView cache:YES];
    [UIView commitAnimations];
}


-(void)nextToPage{
    
    if (![self judgeInfoIncurrentPage:current_page]) {
        return;
    }
    
    if (current_page == 1) {
        for (int i = 0; i < 5; i ++) {
            UITextField *texts = (UITextField *)[self.view viewWithTag:101 + i];
            if (![AppContext getPreferenceByKey:[registerArray objectAtIndex:i] needMerge:NO]) {
                [AppContext setPreferenceByKey:[registerArray objectAtIndex:i] value:texts.text];
                k++;
            }else{
                if (![[AppContext getPreferenceByKey:[registerArray objectAtIndex: i] needMerge:NO]isEqualToString:texts.text]) {
                    [AppContext setPreferenceByKey:[registerArray objectAtIndex: i] value:texts.text];
                    k ++;
                }
            }
                    [AppContext setPreferenceByKey:[registerArray objectAtIndex:i] value:texts.text];
        }
        UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(nextAnimationDidStop)];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
        [UIView commitAnimations];
    }
    
    if (current_page == 2) {
        [self getCarData];
    }
    
    if (current_page == 3) {
        
        UITextField *texts = (UITextField *)[self.view viewWithTag:301];
        if ([texts.text isEqualToString:@""])
        {
            [self alertShowWithMessage:@"请输入短信验证码"];
            return;
        }
        else
        {
            sendType = ksendTypeFinishRegister;
            [self postToServer];
        }
    }
}

-(void)finishRegister
{
    if (![self judgeInfoIncurrentPage:current_page])
    {
        return;
    }
    sendType = ksendTypeFinishRegister;
    [self postToServer];
}

-(void)tap:(UITapGestureRecognizer*)send
{
    UIView * pageView = [self.view viewWithTag:1002];
    UITextField * textField = (UITextField *)[pageView viewWithTag:203];
    if (isNewCarBtnTouched==NO) {
        isNewCarBtnTouched=YES;
        isNewCarImage.hidden=NO;
        carTypeBtn.hidden=YES;
        textField.placeholder = @"发动机号";
    }else
    {
        isNewCarImage.hidden=YES;
        carTypeBtn.hidden=NO;
        isNewCarBtnTouched =NO;
        textField.placeholder = @"号牌号码";
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
    
}


-(void)reloadView
{
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneTap)];
    tapView.numberOfTapsRequired = 1;
    
    UIView *pageView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 379)];
    UIImageView *page = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 379)];
    page.image = [UIImage imageNamed:[NSString stringWithFormat:@"Register_%d.png",current_page]];
    page.userInteractionEnabled = YES;
    pageView.tag = 1000 + current_page;
    [page addGestureRecognizer:tapView];
    [pageView addSubview:page];
    if (current_page == 1) {
        for (int i = 0; i < 5; i ++) {
            UITextField *infoText = [[UITextField alloc]initWithFrame:CGRectMake(23, 99 + 37 * i, kDeviceWidth-23, 23)];
            infoText.tag = 101 + i;
            infoText.delegate = self;
            infoText.borderStyle = UITextBorderStyleNone;
            infoText.clearButtonMode = UITextFieldViewModeWhileEditing;
            infoText.placeholder = [infoArray objectAtIndex:i];
//            if ([AppContext getPreferenceByKey:[registerArray objectAtIndex:i] needMerge:NO]) { // || ![[AppContext getPreferenceByKey:[registerArray objectAtIndex:i] needMerge:NO]isEqualToString:@""]
//                infoText.text = [AppContext getPreferenceByKey:[registerArray objectAtIndex:i]needMerge:NO];
//            }else{
//                infoText.text = @"";
//            }
             infoText.text = @"";
            if (i == 3) {
                infoText.secureTextEntry = YES;
                infoText.keyboardType = UIKeyboardTypeDefault;
                infoText.returnKeyType = UIReturnKeyNext;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }else if (i == 4) {
                infoText.secureTextEntry = YES;
                infoText.keyboardType = UIKeyboardTypeDefault;
                infoText.returnKeyType = UIReturnKeyDone;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }else if(i == 1){
                infoText.keyboardType = UIKeyboardTypeNumberPad;
                infoText.returnKeyType = UIReturnKeyNext;
            }else if(i == 2){
                infoText.keyboardType = UIKeyboardTypeEmailAddress;
                infoText.returnKeyType = UIReturnKeyNext;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }else{
                infoText.keyboardType = UIKeyboardTypeDefault;
                infoText.returnKeyType = UIReturnKeyNext;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }
            [pageView addSubview:infoText];

        }
    }
    if (current_page == 2){
        for (int i = 0; i < 4; i ++){
            if (i == 3) {
                carTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [carTypeBtn setFrame:CGRectMake(20, 126 + 37 * i, 280, 31)];
                [carTypeBtn setBackgroundImage:[UIImage imageNamed:@"cell_backgd.png"] forState:UIControlStateNormal];
                [carTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [carTypeBtn.titleLabel setTextAlignment:NSTextAlignmentLeft];
                if ([AppContext getTempContextValueByKey:@"car_type"]) {
                    [carTypeBtn setTitle:[AppContext getTempContextValueByKey:@"car_type"] forState:UIControlStateNormal];
                }else{
                    [carTypeBtn setTitle:@"请选择号牌类型" forState:UIControlStateNormal];
                }
                [carTypeBtn addTarget:self action:@selector(switchCarType) forControlEvents:UIControlEventTouchUpInside];
                [pageView addSubview:carTypeBtn];
                continue;
            }
            UITextField *infoText = [[UITextField alloc]initWithFrame:CGRectMake(23, 110 + 37 * i, 280, 31)];
            infoText.tag = 201 + i;
            infoText.delegate = self;
            infoText.clearButtonMode = UITextFieldViewModeWhileEditing;
            infoText.placeholder = [infoArray objectAtIndex:5 + i];
            infoText.borderStyle = UITextBorderStyleNone;
            infoText.text = @"";
//            if ([AppContext getPreferenceByKey:[registerArray objectAtIndex:i] needMerge:NO]) {
//                infoText.text = [AppContext getPreferenceByKey:[registerArray objectAtIndex:5 + i]needMerge:NO];
//            }else{
//                infoText.text = @"";
//            }
            if (i == 2) {
                infoText.returnKeyType = UIReturnKeyDone;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }else{
                infoText.returnKeyType = UIReturnKeyNext;
                infoText.autocapitalizationType = UITextAutocapitalizationTypeNone;
            }
            //添加是否是新车
            
            UIView *tapView = [[UIView alloc]initWithFrame:CGRectMake(18, 83, 40, 30)];
            UIImageView *backImageView =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remeberButton.png"]];
            backImageView.frame =CGRectMake(10, 10, 11, 11);
            [tapView addSubview:backImageView];
            [pageView addSubview:tapView];
            backImageView.userInteractionEnabled=YES;
            
            isNewCarImage =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"remeberYes.png"]];
            isNewCarImage.frame =CGRectMake(0.5,0.5, 10, 10);
            isNewCarImage.hidden=YES;
            [backImageView addSubview:isNewCarImage];

            UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
            [tapView addGestureRecognizer:tap];
 
            UIImageView *isNewCar =[[UIImageView alloc]initWithFrame:CGRectMake(40, 93, 60, 11)];
            [isNewCar setImage:[UIImage imageNamed:@"新增车辆-6.png"]];
            [pageView addSubview:infoText];
            [pageView addSubview:isNewCar];
        }
    }
    if (current_page == 3) {
        UITextField *sendMsg = [[UITextField alloc]initWithFrame:CGRectMake(23, 132, 280, 31)];
        sendMsg.borderStyle = UITextBorderStyleNone;
        sendMsg.clearButtonMode = UITextFieldViewModeWhileEditing;
        sendMsg.delegate = self;
        sendMsg.returnKeyType = UIReturnKeyDone;
        sendMsg.autocapitalizationType = UITextAutocapitalizationTypeNone;
        sendMsg.keyboardType = UIKeyboardTypeNumberPad;
        sendMsg.tag = 301;
        sendMsg.text = @"";
        sendMsg.placeholder = @"短信验证码";
        [pageView addSubview:sendMsg];
        second = sendMsgTime;
        resendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [resendBtn setFrame:CGRectMake(26,194,269,37)];
        [resendBtn setBackgroundImage:[UIImage imageNamed:@"SendSMS.png"] forState:UIControlStateNormal];
        [resendBtn setTitle:[NSString stringWithFormat:@"重新发送短信验证码（%d）",second] forState:UIControlStateNormal ];
        [resendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [resendBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];
        resendBtn.userInteractionEnabled = NO;
        [resendBtn addTarget:self action:@selector(sendMSG) forControlEvents:UIControlEventTouchUpInside];
        [pageView addSubview:resendBtn];

        time =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
    [self.view addSubview:pageView];
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
}

-(void)changeTime{
    second --;
   
    if (second == 0) {
        [resendBtn setTitle:@"重新发送短信验证码" forState:UIControlStateNormal ];
        [resendBtn setTitleColor:[UIColor colorWithRed:56/255.0 green:143/255.0 blue:205/255.0 alpha:1.0] forState:UIControlStateNormal];
        resendBtn.userInteractionEnabled = YES;
        [time invalidate];
    }else{
        NSString *timeNum = [NSString stringWithFormat:@"重新发送短信验证码(%d)",second];
        [resendBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [resendBtn setTitle:timeNum forState:UIControlStateNormal ];
        resendBtn.userInteractionEnabled = NO;

    }
    
}

-(void)switchCarType{
    EBCarTypeViewController *carTypeVC = [[EBCarTypeViewController alloc]init];
    [self.navigationController pushViewController:carTypeVC animated:YES];
}


-(void)oneTap{
    if (current_page == 1) {
        UITextField *textFields = (UITextField *)[self.view viewWithTag:101];
        [textFields becomeFirstResponder];
        [textFields resignFirstResponder];
    }
    if (current_page == 2) {
        UITextField *textFields = (UITextField *)[self.view viewWithTag:201];
        [textFields becomeFirstResponder];
        [textFields resignFirstResponder];
    }
    if (current_page == 3) {
        UITextField *textFields = (UITextField *)[self.view viewWithTag:301];
        [textFields resignFirstResponder];
    }
    
}

#pragma mark - getData
- (void)getCarData {
    NSLog(@"getCarData");
    UITextField *texts = (UITextField *)[self.view viewWithTag:201];
    owner_name = texts.text;
    NSLog(@"text == %@",texts.text);
    
    texts = (UITextField *)[self.view viewWithTag:202];
    
    owner_id_num = texts.text;
    NSLog(@"text == %@",texts.text);
    
    texts = (UITextField *)[self.view viewWithTag:203];
    if (isNewCarBtnTouched)
    {
        car_engine_num = texts.text;
    }
    else
    {
        car_plate_num = texts.text;
    }
    NSLog(@"text == %@",texts.text);
    
    car_plate_category = carTypeBtn.titleLabel.text;
    
    
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    
    [postDict setObject:owner_name forKey:@"car_owner"];
    [postDict setObject:owner_id_num forKey:@"id"];
    [postDict setObject:@"3" forKey:@"process_flag"];
    
    [postDict setObject:@"registration" forKey:kPostContentTypeSelect];
    
    if (isNewCarBtnTouched)
    {
        [postDict setObject:car_engine_num forKey:@"engine_no"];
    }
    else
    {
        [postDict setObject:car_plate_num forKey:@"plate_no"];
        
        //测试
        //        [postDict setObject:@"02" forKey:@"plate_type"];
        
        NSString *plate_type = [[NSUserDefaults standardUserDefaults]objectForKey:@"selected_plate_type"];
        
        if (plate_type&&plate_type.length>0) {
            selected_plate_type = [plate_type copy];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selected_plate_type"];
        }
        //[postDict setObject:selected_plate_type forKey:@"plate_type"];
    }
    
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserRegistrationUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];

    NSLog(@"%@",postContent);
    NSLog(@"---- kRequestURLPath == %@", kRequestURLPath);
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        requestTag = kCarDataRequest;
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [AppContext didStartNetworking];
        
    }else {
        [AppContext alertContent:error];
    }

}

- (void)postToServer
{
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    
    if ([sendType isEqualToString:ksendTypeUploadInfo])
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"请稍后...";
        kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserRegistrationUrl"]];
        [postDict setObject:@"registration" forKey:kPostContentTypeSelect];//process_flag
        [postDict setObject:@"2" forKey:@"process_flag"];
        
        [postDict setObject:engineNo_label.text forKey:@"engine_no"];
        
        if (isNewCarBtnTouched) {
            //如果是新车，plate_no传两个空格，若不传则会出错
            [postDict setObject:@"  " forKey:@"plate_no"];
        }
        
        for (int i = 0; i < [registerArray count]; i ++)
        {
            if (i != 4)
            {
                NSLog(@"coun == %lu,current == %d,key == %@",(unsigned long)[registerArray count],i,[registerArray objectAtIndex:i]);
                id value = [AppContext getPreferenceByKey:[registerArray objectAtIndex:i] needMerge:NO];
                
                if (value) {
                    [postDict setObject:value forKey:[registerArray objectAtIndex:i]];
                }
            }
        }
    }
    else if ([sendType isEqualToString:ksendTypeFinishRegister])
    {
        HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        HUD.labelText = @"请稍后...";
        UITextField *msgText = (UITextField *)[self.view viewWithTag:301];
        kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserSMSValidateUrl"]];
        [postDict setObject:@"smsvalidate" forKey:kPostContentTypeSelect];
        //        [postDict setObject:@"2" forKey:@"process_flag"];
        [postDict setObject:[AppContext getPreferenceByKey:@"registration_id" needMerge:NO] forKey:@"registration_id"];
        [postDict setObject:msgText.text forKey:@"code"];
    }
    else
    {
        UITextField *textField;
        
        if ([sendType isEqualToString:ksendTypeUserNameCheck])
        {
            textField = (UITextField *)[self.view viewWithTag:101];
            [postDict setObject:textField.text forKey:@"username"];
        }
        
        if ([sendType isEqualToString:ksendTypePhoneCheck])
        {
            textField = (UITextField *)[self.view viewWithTag:102];
            [postDict setObject:textField.text forKey:@"tel_no"];
        }
        
        if ([sendType isEqualToString:ksendTypeEmailCheck])
        {
            textField = (UITextField *)[self.view viewWithTag:103];
            [postDict setObject:textField.text forKey:@"email"];
        }
        
        if ([sendType isEqualToString:ksendTypeOwnerIdCheck])
        {
            textField = (UITextField *)[self.view viewWithTag:202];
            [postDict setObject:textField.text forKey:@"id"];
        }
        
        kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserRegistrationUrl"]];
        [postDict setObject:@"registration" forKey:kPostContentTypeSelect];
        [postDict setObject:@"1" forKey:@"process_flag"];
    }
    
    
    //判断是否标记为新车，如果是，则不向服务器发送号牌号码和号牌类型   -jack
    if (isNewCarBtnTouched)
    {
        //        [postDict setObject:@"  " forKey:@"plate_no"];
        [postDict removeObjectForKey:@"plate_no"];
        
        [postDict removeObjectForKey:@"plate_type"];
    }
    
    NSLog(@"---- postDict %@", postDict);
    NSLog(@"---- kRequestURLPath == %@", kRequestURLPath);
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];

    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [AppContext didStartNetworking];
        
    }else {
        [AppContext alertContent:error];
    }
}

-(void)sendMSG
{
    
    if (reSendCount == 2)
    {
        [self alertShowWithMessage:@"短信验证码只能重发两次!"];
        return;
    }
    
    second = sendMsgTime;
    time =  [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    [resendBtn setTitle:[NSString stringWithFormat:@"重新发送短信验证码（%d）",second] forState:UIControlStateNormal ];
    
    reSendCount ++;
    sendType = ksendTypeReSMS;
    NSString *kRequestURLPath;
    NSString *error;
    NSMutableDictionary *postDict = [[NSMutableDictionary alloc] init];
    kRequestURLPath = [NSString stringWithFormat:@"%@",[AppContext getServiceUrl:@"CircUserReSMSUrl"]];
    NSURL *url = [NSURL URLWithString:kRequestURLPath];
    [postDict setObject:@"resms" forKey:kPostContentTypeSelect];
    [postDict setObject:[AppContext getPreferenceByKey:@"registration_id" needMerge:NO] forKey:@"registration_id"];
    NSLog(@"---- postDict %@", postDict);
    NSLog(@"---- kRequestURLPath %@", kRequestURLPath);
    NSString *postContent = [AppContext dictionaryToXml:postDict error:&error];
    
    if (!error) {
        NSLog(@"---- content %@", postContent);
        
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        NSLog(@"url=%@",url);
        [request setHTTPMethod:@"POST"];
        request.HTTPBody = [postContent dataUsingEncoding:NSUTF8StringEncoding];
        [request setValue:kHTTPHeader forHTTPHeaderField:@"content-type"];//请求头
        NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        [AppContext didStartNetworking];
        
    }else {
        [AppContext alertContent:error];
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
}



#pragma mark - connection delegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([sendType isEqualToString:ksendTypeUploadInfo] || [sendType isEqualToString:ksendTypeFinishRegister])
    {
        [HUD hide:YES];
    }
    [AppContext didStopNetworking];
    [AppContext alertContent:NSLocalizedString(@"连接错误,请重试", nil)];
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if ([sendType isEqualToString:ksendTypeUploadInfo] || [sendType isEqualToString:ksendTypeFinishRegister] || [sendType isEqualToString:ksendTypeReSMS])
    {
        [HUD hide:YES];
    }
    
    [AppContext didStopNetworking];
    
    NSDictionary *dict = [AppContext nsDataToObject:data encoding:NSUTF8StringEncoding];
    NSLog(@"sss%@",dict);
    
    if ( requestTag == 1002)
    {
//        NSLog(@"car_owner == %@",[dict objectForKey:@"faces"]);
        NSLog(@"car_owner == %@",[dict objectForKey:@"car_owner"]);
        NSLog(@"engine_no == %@",[dict objectForKey:@"engine_no"]);
        NSLog(@"vin_code == %@",[dict objectForKey:@"vin_code"]);
        
        NSString *car_owner = [dict objectForKey:@"car_owner"];
        
        if (car_owner.length == 0) {
            
            [[[UIAlertView alloc] initWithTitle:@"提示" message:@"没有匹配的车辆信息" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil] show];
            
            current_page = 2;
            
            return;
        }
        
        [self showAffirmInfoView];
        
        name_label.text = [dict objectForKey:@"car_owner"];
        engineNo_label.text = [dict objectForKey:@"engine_no"];
        vinCode_label.text = [dict objectForKey:@"vin_code"];
        
        return;
    }
    
    if (![AppContext checkResponse:dict])
    {
        if ([sendType isEqualToString:ksendTypeUploadInfo] || [sendType isEqualToString:ksendTypeFinishRegister])
        {
            existErr = YES;
        }
        else
        {
            UITextField *textField;
            
            if ([sendType isEqualToString:ksendTypeUserNameCheck])
            {
                textField = (UITextField *)[self.view viewWithTag:101];
            }
            
            if ([sendType isEqualToString:ksendTypePhoneCheck])
            {
                textField = (UITextField *)[self.view viewWithTag:102];
            }
            
            if ([sendType isEqualToString:ksendTypeEmailCheck])
            {
                textField = (UITextField *)[self.view viewWithTag:103];
            }
            
            if ([sendType isEqualToString:ksendTypeOwnerIdCheck])
            {
                textField = (UITextField *)[self.view viewWithTag:202];
            }
            
            if ([sendType isEqualToString:ksendTypeReSMS])
            {
                return;
            }
            textField.text = @"";
        }
        return;
    }
    
    if ([sendType isEqualToString:ksendTypeReSMS])
    {
        [self alertShowWithMessage:@"验证码重发成功，请注意查收"];
        return;
    }
    
    if ([sendType isEqualToString:ksendTypeUploadInfo])
    {
        if (!existErr)
        {
            reSendCount = 0;
            UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(nextAnimationDidStop)];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
            [UIView commitAnimations];
            [AppContext setPreferenceByKey:@"registration_id" value:[dict objectForKey:@"registration_id"]];
            NSLog(@"registration_ = %@",[dict objectForKey:@"registration_id"]);
        }
    }
    
    if ([sendType isEqualToString:ksendTypeFinishRegister]) {
        [AppContext setPreferenceByKey:kTempKeyUserId value:[dict objectForKey:@"user_id"]];
        [AppContext setPreferenceByKey:@"_user_password" value:[AppContext getPreferenceByKey:[registerArray objectAtIndex:3] needMerge:NO]];
        [self alertShowWithMessage:@"注册成功，现在您可以登陆主页面了！"];
        [self back];
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];

    
}

- (void)showAffirmInfoView {
    [self oneTap];
    
    affirmInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    affirmInfoView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:affirmInfoView];
    
    UIView *bg_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, affirmInfoView.frame.size.width, affirmInfoView.frame.size.height)];
    bg_view.backgroundColor = [UIColor blackColor];
    bg_view.alpha = 0.3;
    [affirmInfoView addSubview:bg_view];
    
    UIView *info_view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 265, 288)];
    [affirmInfoView addSubview:info_view];
    info_view.center = affirmInfoView.center;
    
    UIImageView *bg_image_view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 265, 288)];
    bg_image_view.image = [UIImage imageNamed:@"车辆绑定信息确认-2"];
    [info_view addSubview:bg_image_view];
    
    UIImageView *topimage = [[UIImageView alloc]initWithFrame:CGRectMake((265-110)/2, 25, 110, 18)];
    topimage.image = [UIImage imageNamed:@"车辆绑定信息确认-8"];
    [info_view addSubview:topimage];
    
    UIImageView *ownerInfo = [[UIImageView alloc]initWithFrame:CGRectMake(13, 60, 73, 119)];
    ownerInfo.image = [UIImage imageNamed:@"车辆绑定信息确认-3"];
    [info_view addSubview:ownerInfo];
    
    name_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMinY(ownerInfo.frame), 150, 17)];
    name_label.font = [UIFont systemFontOfSize:15];
    name_label.textColor = [UIColor grayColor];
    [info_view addSubview:name_label];
    
    engineNo_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMaxY(name_label.frame)+33, 150, 17)];
    engineNo_label.font = [UIFont systemFontOfSize:15];
    engineNo_label.textColor = [UIColor grayColor];
    [info_view addSubview:engineNo_label];
    
    vinCode_label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(ownerInfo.frame)+5, CGRectGetMaxY(engineNo_label.frame)+36, 150, 17)];
    vinCode_label.font = [UIFont systemFontOfSize:15];
    vinCode_label.textColor = [UIColor grayColor];
    [info_view addSubview:vinCode_label];
    
    
    UIButton *affirmButton = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(ownerInfo.frame)+40, 63, 25)];
    [affirmButton setImage:[UIImage imageNamed:@"车辆绑定信息确认-17"] forState:UIControlStateNormal];
    [affirmButton addTarget:self action:@selector(affirmAction) forControlEvents:UIControlEventTouchDown];
    [info_view addSubview:affirmButton];
    
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(info_view.frame)-63-60, CGRectGetMaxY(ownerInfo.frame)+40, 63, 25)];
    [cancelButton setImage:[UIImage imageNamed:@"车辆绑定信息确认-7"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchDown];
    [info_view addSubview:cancelButton];
}

- (void)affirmAction {
    [affirmInfoView removeFromSuperview];
    requestTag = 0;
    [self toPage3];
}

- (void)cancelAction {
    current_page = 2;
    [affirmInfoView removeFromSuperview];
}

- (void)toPage3 {
    
    existErr = NO;
    for (int i = 0; i < 3; i ++)
    {
        UITextField *texts = (UITextField *)[self.view viewWithTag:201 + i];
        if (![AppContext getPreferenceByKey:[registerArray objectAtIndex:5 + i] needMerge:NO])
        {
            [AppContext setPreferenceByKey:[registerArray objectAtIndex:5 + i] value:texts.text];
            k++;
        }
        else
        {
            if (![[AppContext getPreferenceByKey:[registerArray objectAtIndex:5 + i] needMerge:NO]isEqualToString:texts.text])
            {
                [AppContext setPreferenceByKey:[registerArray objectAtIndex:5 + i] value:texts.text];
                k ++;
            }
        }
    }
    
    if (k == 0)
    {
        UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:0.5f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(nextAnimationDidStop)];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:lastView cache:YES];
        [UIView commitAnimations];
    }
    else
    {
        NSLog(@"ksendTypeUploadInfo");
        sendType = ksendTypeUploadInfo;
        [self postToServer];
    }
    
}

- (void)reSetTopButton {
    lastPage = [[UIBarButtonItem alloc]initWithTitle:@"上一步" style:UIBarButtonItemStyleBordered target:self action:@selector(lastToPage)];
    nextPage = [[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(nextToPage)];
    backBtn = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(back)];                                        //UIBarButtonItemStylePlain
    finishBtn = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(finishRegister)];
    
    lastPage.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    nextPage.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    backBtn.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    finishBtn.tintColor = [UIColor colorWithRed:69.0/255 green:155.0/255 blue:206.0/255 alpha:1.0];
    
    self.navigationItem.rightBarButtonItem = nextPage;
    
    self.navigationItem.leftBarButtonItem = backBtn;
    
}

-(void)lastAnimationDidStop{
    UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
    //[lastView removeAllSubviews];
    [lastView removeFromSuperview];
    if (current_page == total_page && second > 0) {
        [time invalidate];
    }
    current_page --;
    if (current_page == 1) {
        self.navigationItem.leftBarButtonItem = backBtn;
    }else{
        self.navigationItem.leftBarButtonItem = lastPage;
    }
    self.navigationItem.rightBarButtonItem = nextPage;
    [self reloadView];
    
}

-(void)nextAnimationDidStop{
    UIView *lastView = (UIView *)[self.view viewWithTag:1000 + current_page];
    //[lastView removeAllSubviews];
    [lastView removeFromSuperview];
    current_page ++;
    
    if (current_page == total_page) {
        self.navigationItem.rightBarButtonItem = finishBtn;
    }else{
        self.navigationItem.rightBarButtonItem = nextPage;
    }
    self.navigationItem.leftBarButtonItem = lastPage;
    [self reloadView];
    
}

-(void)alertShowWithMessage:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

-(BOOL)validateEmail:(NSString *)candidate{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailText = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",emailRegex];
    return [emailText evaluateWithObject:candidate];
}

-(BOOL)stringHaveSpace:(NSString *)textString{
    for (int i = 0; i < [textString length]; i ++) {
        if ([[textString substringWithRange:NSMakeRange(i, 1)]isEqualToString:@" "]) {
            return  YES;
        }
    }
    return NO;
}

//对比用户资料
-(BOOL)judgeInfoIncurrentPage:(int)currentPage{
    if (currentPage == 1) {
        /***********************资料填写是否完整***********************/
        for (int i = 0; i < 4; i ++)
        {
            UITextField *texts = (UITextField *)[self.view viewWithTag:101 + i];
            if ([texts.text isEqualToString:@""]) {
                [self alertShowWithMessage:@"资料还没填写完整呢"];
                return NO;
            }
            if ([self stringHaveSpace:texts.text]) {
                [self alertShowWithMessage:[NSString stringWithFormat:@"%@不能有空格的，检查一下吧",[infoArray objectAtIndex:i]]];
                texts.text = @"";
                return NO;;
            }
            
        }
        
        /***********************密码规则判断***********************/
        UITextField *passedWord = (UITextField *)[self.view viewWithTag:104];
        UITextField *sure_passedWord = (UITextField *)[self.view viewWithTag:105];
        if (![passedWord.text isEqualToString:sure_passedWord.text] || [passedWord.text length] < 6) {
            [self alertShowWithMessage:@"密码不一致或者密码长度小于6位了"];
            passedWord.text = @"";
            sure_passedWord.text = @"";
            return NO;;
            
        }
        
        /***********************用户名规则判断***********************/
        UITextField *userName = (UITextField *)[self.view viewWithTag:101];
        if ([userName.text length] <= 2 || [userName.text length] >= 16) {
            [self alertShowWithMessage:@"用户名应该是3-16个字符"];
            return NO;;
        }
        
        /***********************邮箱规则判断**********************/
        UITextField *email = (UITextField *)[self.view viewWithTag:103];
        if (![self validateEmail:email.text]) {
            [self alertShowWithMessage:@"Email地址格式好像不对哦"];
            email.text =@"";
            return NO;;
        }
        
        /***********************手机规则判断**********************/
        UITextField *mobile = (UITextField *)[self.view viewWithTag:102];
        if ([mobile.text length] != 11) {
            [self alertShowWithMessage:@"不对吧，手机号码应该为11位"];
            mobile.text = @"";
            return NO;;
        }
        
    }
    
    if (currentPage == 3) {
        UITextField *sendMsg = (UITextField *)[self.view viewWithTag:301];
        if ([sendMsg.text isEqualToString:@""]) {
            [self alertShowWithMessage:@"短信校验码还没填呢"];
            return NO;;
            
        }
    }
    
    if (currentPage == 2) {
        for (int i = 0; i < 3; i ++) {
            UITextField *texts = (UITextField *)[self.view viewWithTag:201 + i];
            if ([texts.text isEqualToString:@""]) {
                [self alertShowWithMessage:@"资料还没填写完整呢"];
                return NO;;
            }
            if (i == 1) {
                if (texts.text.length != 15 && texts.text.length != 18) {
                    [self alertShowWithMessage:@"所输入身份证号码长度不为15或者18位，请重新填写！"];
                    return NO;;
                }
            }
        }
//        //原型
//        if ([carTypeBtn.titleLabel.text isEqualToString:@"请选择号牌类型"]||[carTypeBtn.titleLabel.text isEqualToString:@"全部"]) {
//                [self alertShowWithMessage:@"请选择具体的车辆类型再提交！"];
//                return NO;
//            }else{
//        
//                [AppContext setPreferenceByKey:[registerArray objectAtIndex:8] value:[AppContext getTempContextValueByKey:@"car_type"]];
//                }
        
        //myChange 修改后
        if (isNewCarImage.hidden==YES) {
            if ([carTypeBtn.titleLabel.text isEqualToString:@"请选择号牌类型"]||[carTypeBtn.titleLabel.text isEqualToString:@"全部"]) {
                [self alertShowWithMessage:@"请选择具体的车辆类型再提交！"];
                return NO;
            }else{
                
                [AppContext setPreferenceByKey:[registerArray objectAtIndex:8] value:[AppContext getTempContextValueByKey:@"car_type"]];
            }
        }
    }
    return YES;
}

#pragma -mark UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    //    textField.placeholder = @"";
    UIView *currentView = (UIView *)[self.view viewWithTag:1000 + current_page];
    if (current_page == 1) {
        if ( textField.tag > 102 )
        {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [currentView setFrame:CGRectMake(0, - 37 * (textField.tag - 102), self.view.frame.size.width, 379)];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [currentView setFrame:CGRectMake(0, 0, self.view.frame.size.width, 379)];
            [UIView commitAnimations];
        }
    }
    if (current_page == 2)
    {
        if (textField.tag  == 203)
        {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [currentView setFrame:CGRectMake(0,- 37 , self.view.frame.size.width, self.view.frame.size.height)];
            [UIView commitAnimations];
        }
        else
        {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [currentView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            [UIView commitAnimations];
        }
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
}
//
//
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        if (textField.tag > 100 && textField.tag < 200) {
            textField.placeholder = [infoArray objectAtIndex:textField.tag - 101];
        }
        if (textField.tag > 200 && textField.tag < 300) {
            textField.placeholder = [infoArray objectAtIndex:5 + textField.tag - 201];
        }
        if (textField.tag == 301) {
            textField.placeholder = @"短信验证码";
        }
        
    }else{
        if (textField.tag == 101) {
            sendType = ksendTypeUserNameCheck;
            [self postToServer];
        }
        if (textField.tag == 102) {
            sendType = ksendTypePhoneCheck;
            [self postToServer];
        }
        if (textField.tag == 103) {
            sendType = ksendTypeEmailCheck;
            [self postToServer];
        }
        if (textField.tag == 202) {
            sendType = ksendTypeOwnerIdCheck;
            [self postToServer];
        }
        
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    UIView *currentView = (UIView *)[self.view viewWithTag:1000 + current_page];
    if (textField.returnKeyType == UIReturnKeyNext)
    {
        UITextField *nextText = (UITextField *)[self.view viewWithTag:textField.tag + 1];
        if (current_page == 1) {
            if (textField.tag + 1 > 102) {
                [UIView beginAnimations:@"animationID" context:nil];
                [UIView setAnimationDuration:0.5f];
                [currentView setFrame:CGRectMake(0,- 37 * (textField.tag - 101), self.view.frame.size.width, 379)];
                [UIView commitAnimations];
            }
        }
        if (current_page == 2) {
            if (textField.tag + 1 == 203) {
                [UIView beginAnimations:@"animationID" context:nil];
                [UIView setAnimationDuration:0.5f];
                [currentView setFrame:CGRectMake(0,- 37 , self.view.frame.size.width, 379)];
                [UIView commitAnimations];
            }
        }
        
        [nextText becomeFirstResponder];
    }else{
        if (current_page == 1 || current_page == 2) {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:0.5f];
            [currentView setFrame:CGRectMake(0,0, self.view.frame.size.width, 379)];
            [UIView commitAnimations];
        }
        [textField resignFirstResponder];
        [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
        
        return YES;
    }
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
    
    return NO;
}

#pragma -mark UIAlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self performSelector:@selector(reSetTopButton) withObject:nil afterDelay:0.1];
}


@end
