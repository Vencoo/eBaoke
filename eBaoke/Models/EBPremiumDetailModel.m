//
//  EBPremiumDetailModel.m
//  eBaoke
//
//  Created by Vencoo on 14-10-9.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumDetailModel.h"

@implementation EBPremiumDetailModel

- (id)initWithArray:(NSArray *)dataArray
{
    self = [super initWithArray:dataArray];
    if (self) {
        _policyNo = [dataArray objectAtIndex:0];
        _policyStatus = [dataArray objectAtIndex:1];
        _startDate = [dataArray objectAtIndex:2];
        _endDate = [dataArray objectAtIndex:3];
        _standardPremium = [dataArray objectAtIndex:4];
        _basedPremium = [dataArray objectAtIndex:5];
        _limitAmount = [dataArray objectAtIndex:6];
        _useType = [dataArray objectAtIndex:7];
        _carOwner = [dataArray objectAtIndex:8];
        _policyHolder = [dataArray objectAtIndex:9];
        _insured = [dataArray objectAtIndex:10];
        _signDate = [dataArray objectAtIndex:11];
        _comfirmSequenceNo = [dataArray objectAtIndex:12];
        
    }
    return self;
}


@end
