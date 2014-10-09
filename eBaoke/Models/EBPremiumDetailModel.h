//
//  EBPremiumDetailModel.h
//  eBaoke
//
//  Created by Vencoo on 14-10-9.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBPremiumDetailModel : EBBaseModel

// 保单号
@property (nonatomic) NSString *policyNo;

/* 保单状态
 0--保单有效；1--投保查询未确认;2--保单失效;3--退保失效;4-直接投保未确认;5-撤件失效;6-上海:平台退保失效 北京:平台抢单处理;7-上海:投保预确认;8-上海:保单缴费
 */
@property (nonatomic) NSString *policyStatus;

// 保险开始日期
@property (nonatomic) NSString *startDate;

// 保险到期时间
@property (nonatomic) NSString *endDate;

// 标准保费
@property (nonatomic) NSString *standardPremium;

// 固定保费
@property (nonatomic) NSString *basedPremium;

// 赔偿限额
@property (nonatomic) NSString *limitAmount;

// 车辆使用性质
@property (nonatomic) NSString *useType;

// 机动车车主
@property (nonatomic) NSString *carOwner;

// 投保人
@property (nonatomic) NSString *policyHolder;

// 被保险人
@property (nonatomic) NSString *insured;

// 签单日期
@property (nonatomic) NSString *signDate;

// 投保确认码
@property (nonatomic) NSString *comfirmSequenceNo;

@end
