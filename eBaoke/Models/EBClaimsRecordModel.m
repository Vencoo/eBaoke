//
//  EBClaimsRecordModel.m
//  eBaoke
//
//  Created by Vencoo on 14-10-10.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimsRecordModel.h"

@implementation EBClaimsRecordModel

- (id) init
{
    self = [super init];
    if (self) {
        _caseId = @"";
        _reportNo  = @"";
        _happenTime = @"";
        _caseStatus = @"";
        _caseType = @"";
        _claimType = @"";
        
    }
    return self;
}

- (id)initWithArray:(NSArray *)dataArray
{
    self = [self init];
    if (self) {
        _caseId = [dataArray objectAtIndex:0];
        _reportNo = [dataArray objectAtIndex:1];
        _happenTime = [dataArray objectAtIndex:2];
        _caseStatus = [dataArray objectAtIndex:3];
        _caseType = [dataArray objectAtIndex:4];
        _claimType = [dataArray objectAtIndex:5];
        
    }
    return self;
}


@end
