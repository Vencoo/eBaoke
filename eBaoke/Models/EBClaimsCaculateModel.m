//
//  EBClaimsCaculateModel.m
//  eBaoke
//
//  Created by Vencoo on 14-10-11.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsCaculateModel.h"

#import "EBViolationModel.h"

@implementation EBClaimsCaculateModel

- (id)initWithArray:(NSArray *)dataArray
{
    self = [super init];
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

- (id)initWithDic:(NSDictionary *)dic1
{
    self = [super init];
    if (self) {
        NSDictionary *dic = [[dic1 objectForKey:@"calculateInfo"] firstObject];
        if (dic) {
            _accidentAdjustModulus = [dic objectForKey:@"accidentAdjustModulus"];
            _basePremium = [dic objectForKey:@"basePremium"];
            _endDate = [dic objectForKey:@"endDate"];
            _engineNo = [dic objectForKey:@"engineNo"];
            _limitPremium = [dic objectForKey:@"limitPremium"];
            _natureUse = [dic objectForKey:@"natureUse"];
            _payAmount = [dic objectForKey:@"payAmount"];
            _plateNo = [dic objectForKey:@"plateNo"];
            _policyQueryNo = [dic objectForKey:@"policyQueryNo"];
            _premiumFormula = [dic objectForKey:@"premiumFormula"];
            _startDate = [dic objectForKey:@"startDate"];
            _trafficAdjustModulus = [dic objectForKey:@"trafficAdjustModulus"];
            _trafficLimitLiability = [dic objectForKey:@"trafficLimitLiability"];
            _travelTax = [dic objectForKey:@"travelTax"];
            _vehicleType = [dic objectForKey:@"vehicleType"];
            _vinCode = [dic objectForKey:@"vinCode"];
        }
      
        
        NSArray *array1 = [dic1 objectForKey:@"cliamInfo"];
        _cliamArray = [[NSMutableArray alloc] init];
        if ([array1 isKindOfClass:[NSArray class]]) {
            
        }
        
        NSArray *array2 = [dic1 objectForKey:@"violationInfo"];
        _violationArray = [[NSMutableArray alloc] init];
        
        if ([array2 isKindOfClass:[NSArray class]]) {

            for (NSDictionary *dic2 in array2) {
                EBViolationModel *model = [[EBViolationModel alloc] initWithDic:dic2];
                [_violationArray addObject:model];
            }
        }

    }
    return self;
}

@end
