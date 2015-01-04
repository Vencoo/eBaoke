//
//  EBClaimsRecordModel.h
//  eBaoke
//
//  Created by Vencoo on 14-10-10.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBClaimsRecordModel : EBBaseModel

@property (nonatomic) NSString *caseId;

@property (nonatomic) NSString *reportNo;

@property (nonatomic) NSString *happenTime;

@property (nonatomic) NSString *casePayDate;

@property (nonatomic) NSString *caseStatus;

@property (nonatomic) NSString *caseType;

@property (nonatomic) NSString *claimType;

- (id)initWithDic:(NSDictionary *)dic1;


@end
