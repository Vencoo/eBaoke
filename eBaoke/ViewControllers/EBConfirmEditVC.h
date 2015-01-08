//
//  EBConfirmEditVC.h
//  eBaoke
//
//  Created by Vencoo on 14-9-23.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//
/**********
 新增确认 不再使用
 **********/
#import "EBBaseViewController.h"

@interface EBConfirmEditVC : EBBaseViewController

@property (nonatomic) EBCarListModel *carModel;

// 如果只是修改为真 为假时做新增操作
@property (nonatomic) BOOL isEditAction;

@property (nonatomic) int vcType;

@property (nonatomic, weak) EBBaseViewController *addVC;

@end
