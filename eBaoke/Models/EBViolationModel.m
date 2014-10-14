//
//  EBViolationModel.m
//  eBaoke
//
//  Created by Vencoo on 14-9-25.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBViolationModel.h"

@implementation EBViolationModel

- (id)initWithArray:(NSArray *)dataArray
{
    self = [super initWithArray:dataArray];
    if (self) {
        _peccancyPlace = [dataArray objectAtIndex:0];
        _peccancyDes = [dataArray objectAtIndex:1];
        _peccancyTime = [dataArray objectAtIndex:2];
        _acceptDate = [dataArray objectAtIndex:3];
    }
    
    return self;
}

- (id)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _peccancyPlace = [dic objectForKey:@"peccancyPlace"];
        _peccancyDes = [dic objectForKey:@"peccancyDes"];
        _peccancyTime = [dic objectForKey:@"peccancyTime"];
        _acceptDate = [dic objectForKey:@"acceptDate"];
    }
    
    return self;
}

@end
