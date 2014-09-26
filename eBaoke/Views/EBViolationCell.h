//
//  EBViolationCell.h
//  eBaoke
//
//  Created by Vencoo on 14-9-24.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface EBViolationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateHourLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *locateLabel;
@property (weak, nonatomic) IBOutlet UILabel *actionLabel;

@property (strong, nonatomic) EBCarListModel *carModel;

@end
