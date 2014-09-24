//
//  EBCarListModel.m
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-19.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarListModel.h"

@implementation EBCarListModel

- (id)initWithArray:(NSArray *)dataArray
{
    self = [super initWithArray:dataArray];
    if (self) {
        _vehicleId = [dataArray objectAtIndex:0];
        _plateNo = [dataArray objectAtIndex:1];
        _carOwner = [dataArray objectAtIndex:2];
        _engineNo = [dataArray objectAtIndex:3];
        _vinCode = [dataArray objectAtIndex:3];

        
    }
    return self;
}


@end
