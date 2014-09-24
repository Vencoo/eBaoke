//
//  EBConfirmEditVC.m
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBConfirmEditVC.h"

@interface EBConfirmEditVC ()
{
 
    IBOutlet UILabel *_nameLabel;
    IBOutlet UILabel *_engineLabel;
    IBOutlet UILabel *_frameLabel;
}

@end

@implementation EBConfirmEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)confirmAction:(id)sender {
    
}
- (IBAction)cancelAction:(id)sender {
    
}

@end
