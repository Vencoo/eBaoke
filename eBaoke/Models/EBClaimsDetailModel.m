//
//  EBClaimsDetailModel.m
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsDetailModel.h"

@implementation EBClaimsDetailModel

- (id) init
{
    self = [super init];
    if (self) {
        _policyNo = @"";
        _reparationAmount = @"";
        _reportDate = @"";
        _happenTime = @"";
        _caseStartTime = @"";
        _closedTime = @"";
        _caseType = @"";
        _caseStatus = @"";
        _refusePayReason = @"";
        _driverName = @"";
        _happenLocation = @"";
        _course = @"";
        _resDivision = @"";
    }
    return self;
}

- (id)initWithArray:(NSArray *)dataArray
{
    self = [self init];
    if (self) {
       
        _policyNo = [dataArray objectAtIndex:0];
        _reparationAmount = [dataArray objectAtIndex:1];
        _reportDate = [dataArray objectAtIndex:2];
        _happenTime = [dataArray objectAtIndex:3];
        _caseStartTime = [dataArray objectAtIndex:4];
        _closedTime = [dataArray objectAtIndex:5];
        _caseType = [dataArray objectAtIndex:6];
        _caseStatus = [dataArray objectAtIndex:7];
        _refusePayReason = [dataArray objectAtIndex:8];
        _driverName = [dataArray objectAtIndex:9];
        _happenLocation = [dataArray objectAtIndex:10];
        _course = [dataArray objectAtIndex:11];
        _resDivision = [dataArray objectAtIndex:12];
    }
    return self;
}
@end
