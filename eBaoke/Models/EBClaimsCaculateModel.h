//
//  EBClaimsCaculateModel.h
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBClaimsCaculateModel : EBBaseModel

@property (nonatomic) NSString *policyQueryNo;

@property (nonatomic) NSString *plateNo;

@property (nonatomic) NSString *vinCode;

@property (nonatomic) NSString *vehicleType;

@property (nonatomic) NSString *natureUse;

@property (nonatomic) NSString *trafficLimitLiability;

@property (nonatomic) NSString *startDate;

@property (nonatomic) NSString *endDate;

@property (nonatomic) NSString *basePremium;

@property (nonatomic) NSString *limitPremium;

@property (nonatomic) NSString *trafficAdjustModulus;

@property (nonatomic) NSString *accidentAdjustModulus;

@property (nonatomic) NSString *premiumFormula;

@property (nonatomic) NSString *travelTax;

@property (nonatomic) NSString *payAmount;

@property (nonatomic) NSString *engineNo;


@property (nonatomic) NSMutableArray *cliamArray;

@property (nonatomic) NSMutableArray *violationArray;

@property (nonatomic) NSString *taxStatus;

- (id)initWithDic:(NSDictionary *)dic;

@end
