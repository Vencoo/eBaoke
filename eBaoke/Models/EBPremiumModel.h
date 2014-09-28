//
//  EBPremiumModel.h
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBPremiumModel : EBBaseModel

// 保单号
@property (nonatomic) NSString *policyNo;

/* 保单状态
 	0--保单有效；1--投保查询未确认;2--保单失效;3--退保失效;4-直接投保未确认;5-撤件失效;6-上海:平台退保失效 北京:平台抢单处理;7-上海:投保预确认;8-上海:保单缴费
 */
@property (nonatomic) NSInteger policyStatus;

// 保险公司
@property (nonatomic) NSString *insuranceCompany;

// 保险开始日期
@property (nonatomic) NSString *startTime;

// 保险到期时间
@property (nonatomic) NSString *endTime;

// 保单类型
@property (nonatomic) NSInteger policyType;

// 保单ID
@property (nonatomic) NSInteger policyId;





@end
