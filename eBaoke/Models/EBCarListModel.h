//
//  EBCarListModel.h
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-19.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBBaseModel.h"

@interface EBCarListModel : EBBaseModel
// 车辆所有人
@property (nonatomic) NSString *carOwner;
// 车辆ID
@property (nonatomic) NSString *vehicleId;
// 发动机号
@property (nonatomic) NSString *engineNo;
// 车架号
@property (nonatomic) NSString *vinCode;
// 车辆类型
@property (nonatomic) NSString *plateType;
// 车牌号
@property (nonatomic) NSString *plateNo;
// 车辆和人的绑定ID
@property (nonatomic) NSString *userCarId;
// 是否新车
@property (nonatomic) BOOL isNewCar;

- (id)initWithArray1_10:(NSArray *)dataArray;


@end
