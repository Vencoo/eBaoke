//
//  EBCarListModel.m
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-19.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarListModel.h"

@implementation EBCarListModel

- (id) init
{
    self = [super init];
    if (self) {
        _carOwner = @"";
        _vehicleId = @"";
        _engineNo = @"";
        _vinCode = @"";
        _plateNo = @"";
        _plateType = @"";
        _userCarId = @"";
        
    }
    return self;
}

- (id)initWithArray:(NSArray *)dataArray
{
    self = [self init];
    if (self) {
        _userCarId = [dataArray objectAtIndex:0];
        _plateNo = [dataArray objectAtIndex:6];
        _carOwner = [dataArray objectAtIndex:2];
        _engineNo = [dataArray objectAtIndex:3];
        _vinCode = [dataArray objectAtIndex:4];
        _plateType = [dataArray objectAtIndex:5];
        
    }
    return self;
}


@end
