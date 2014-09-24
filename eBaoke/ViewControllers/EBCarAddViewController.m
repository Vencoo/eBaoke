//
//  EBCarAddViewController.m
//  eBaoke
//
//  Created by evenTouch on 14-9-15.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarAddViewController.h"

#import "EBCarTypeViewController.h"

@interface EBCarAddViewController ()<UITextFieldDelegate>
{
    
    UIBarButtonItem *_leftButtonItem;
    
    UIBarButtonItem *_rightButtonItem;
    
    UIView *_contentView;
    
    UIButton *_isNewCarBtn;
    
    UIImageView *_isNewCheckImageView;
    
    UITextField *_nameTextField;
    
    UITextField *_idTextField;
    
    UITextField *_numberTextField;
    
    UIButton *_cateButton;
    
    BOOL _isNewCar;
    
    NSString *_carType;
    
}
@end

@implementation EBCarAddViewController

- (void)loadView
{
    [super loadView];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
    [self.view addSubview:_contentView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTaped:)];
    [_contentView addGestureRecognizer:tap];
   
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480-64)];
    bgView.image = [UIImage imageNamed:@"Register2.png"];
    [_contentView addSubview:bgView];
    
    _isNewCarBtn = [[UIButton alloc] initWithFrame:CGRectMake(29, 80, 15, 15)];
    [_isNewCarBtn setImage:[UIImage imageNamed:@"remeberButton.png"] forState:UIControlStateNormal];
    [_isNewCarBtn addTarget:self action:@selector(isNewCarAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_isNewCarBtn];
    
    _isNewCheckImageView = [[UIImageView alloc] initWithFrame:CGRectMake(29, 80, 15, 15)];
    _isNewCheckImageView.image = [UIImage imageNamed:@"remeberYes.png"];
    _isNewCheckImageView.hidden = YES;
    [_contentView addSubview:_isNewCheckImageView];
    
    UIImageView *isNewCarImg = [[UIImageView alloc] initWithFrame:CGRectMake(55, 82, 60, 11)];
    isNewCarImg.image = [UIImage imageNamed:@"新增车辆-6.png"];
    [_contentView addSubview:isNewCarImg];

    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 115, 280, 20)];
    _nameTextField.placeholder = @"车主姓名";
    _nameTextField.tag = 101;
    _nameTextField.font = [UIFont systemFontOfSize:13];
    _nameTextField.delegate = self;
    [_contentView addSubview:_nameTextField];
    
    _idTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 155, 280, 20)];
    _idTextField.placeholder = @"身份证号码（15-18位）";
    _idTextField.tag = 102;
    _idTextField.font = [UIFont systemFontOfSize:13];
    _idTextField.delegate = self;
    [_contentView addSubview:_idTextField];
    
    _numberTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 195, 280, 20)];
    _numberTextField.placeholder = @"号牌号码";
    _numberTextField.tag = 103;
    _numberTextField.font = [UIFont systemFontOfSize:13];
    _numberTextField.delegate = self;
    [_contentView addSubview:_numberTextField];
    
    _cateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _cateButton.frame = CGRectMake(20, 240, 280, 40);
    [_cateButton setBackgroundImage:[UIImage imageNamed:@"cell_backgd.png"] forState:UIControlStateNormal];
    //[_cateButton setTitle:@"无号牌" forState:UIControlStateNormal];
    [_cateButton addTarget:self action:@selector(cateAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cateButton];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [AppContext setTempContextValueByKey:@"car_type" value:@"号牌类型"];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    titleLabel.font = [UIFont systemFontOfSize:17];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"新增车辆";
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
    // 退出
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightButtonItem:(UIBarButtonItem *)buttonItem
{
    // 退出
    //[self.navigationController popViewControllerAnimated:YES];
    
}

- (void)bgTaped:(UITapGestureRecognizer *)tap
{
    [_nameTextField resignFirstResponder];
    [_idTextField resignFirstResponder];
    [_numberTextField resignFirstResponder];
    
    _contentView.center = CGPointMake(160, 416/2);
}

- (void)cateAction:(UIButton *)btn
{
    // 进入选择号牌类型的页面
    EBCarTypeViewController *ctvc = [[EBCarTypeViewController alloc] init];

    [self.navigationController pushViewController:ctvc animated:YES];
    
}

- (void)isNewCarAction:(UIButton *)btn
{
    _isNewCar = !_isNewCar;
    
    if (_isNewCar) {
        _isNewCheckImageView.hidden = NO;
        _numberTextField.text = @"";
        _numberTextField.placeholder = @"发动机编号";
        _cateButton.hidden = YES;
    }else {
        _isNewCheckImageView.hidden = YES;
        _numberTextField.text = @"";
        _numberTextField.placeholder = @"号牌号码";
        _cateButton.hidden = NO;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (IS_IPHONE_4) {
        
        if (textField.tag == 102) {
            _contentView.center = CGPointMake(160, 416/2-50);
        }
        if (textField.tag == 103) {
            _contentView.center = CGPointMake(160, 416/2-100);
        }
        
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    _contentView.center = CGPointMake(160, 416/2);
    
    return YES;
}

@end
