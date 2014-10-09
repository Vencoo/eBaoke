//
//  EBViolationCell.m
//  eBaoke
//
//  Created by Vencoo on 14-9-24.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBViolationCell.h"

@implementation EBViolationCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVModel:(EBViolationModel *)vModel
{
    _vModel = vModel;
    
    NSString *vDate = vModel.peccancyTime;
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy/mm/dd hh:MM"];
    NSDate *dateTime = [format dateFromString:vDate];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [cal components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit fromDate:dateTime];
    //int year = (int)[dateComps year];
    int month = (int)[dateComps month];
    int day = (int)[dateComps day];
    int hour = (int)[dateComps hour];
    int minute = (int)[dateComps minute];
    //int second = (int)[dateComps second];

    _dateMonthLabel.text = [NSString stringWithFormat:@"%d月",month];
    _dateDayLabel.text = [NSString stringWithFormat:@"%2d",day];
    _dateHourLabel.text = [NSString stringWithFormat:@"%2d:%2d",hour,minute];
    
    _dateLabel.text = _vModel.acceptDate;
    
    _locateLabel.text = _vModel.peccancyPlace;
    
    _actionLabel.text = _vModel.peccancyDes;
}

@end
