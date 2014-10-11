//
//  EBClaimsCaculateModel.m
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsCaculateModel.h"

@implementation EBClaimsCaculateModel

- (id) init
{
    self = [super init];
    if (self) {
        _policyQueryNo = @"";
        _plateNo = @"";
        _vinCode = @"";
        _vehicleType = @"";
        _natureUse = @"";
        //_trafficLimitLiability = @"";
        _startDate = @"";
        _endDate = @"";
        //_basePremium = @"";
        //_limitPremium = @"";
        _trafficAdjustModulus = @"";
        _accidentAdjustModulus = @"";
        _premiumFormula = @"";
        //_travelTax = @"";
        //_payAmount = @"";
        
    }
    return self;
}

- (id)initWithArray:(NSArray *)dataArray
{
    self = [self init];
    if (self) {
        _policyQueryNo = [dataArray objectAtIndex:0];
        _plateNo = [dataArray objectAtIndex:1];
        _vinCode = [dataArray objectAtIndex:2];
        _vehicleType = [dataArray objectAtIndex:3];
        _natureUse = [dataArray objectAtIndex:4];
        _trafficLimitLiability = [dataArray objectAtIndex:5];
        
        NSDate *sString = [dataArray objectAtIndex:6];
        NSDate *eString = [dataArray objectAtIndex:7];
        
        NSDateFormatter *format1 = [[NSDateFormatter alloc] init];
        [format1 setDateFormat:@"yyyy-MM-dd"];
        
        _startDate = [format1 stringFromDate:sString];
        _endDate = [format1 stringFromDate:eString];
        
        _basePremium = [dataArray objectAtIndex:8];
        _limitPremium = [dataArray objectAtIndex:9];
        _trafficAdjustModulus = [dataArray objectAtIndex:10];
        _accidentAdjustModulus = [dataArray objectAtIndex:11];
        _premiumFormula = [dataArray objectAtIndex:12];
        _travelTax = [dataArray objectAtIndex:13];
        _payAmount = [dataArray objectAtIndex:14];
        
    }
    return self;
}

@end
