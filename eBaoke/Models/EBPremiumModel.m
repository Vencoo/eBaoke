//
//  EBPremiumModel.m
//  eBaoke
//
//  Created by Vencoo on 14-9-28.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumModel.h"

@implementation EBPremiumModel

- (id)initWithArray:(NSArray *)dataArray
{
    self = [super initWithArray:dataArray];
    if (self) {
        if ([dataArray count] != 7) {
            return self;
        }
        _policyNo = [dataArray objectAtIndex:2];
        _policyStatus = [dataArray objectAtIndex:5];
        _insuranceCompany = [dataArray objectAtIndex:1];
        _startDate = [dataArray objectAtIndex:3];
        _endDate = [dataArray objectAtIndex:4];
        _policyType = [dataArray objectAtIndex:6];
        _policyId = [dataArray objectAtIndex:0];
    }
    return self;
}

@end
