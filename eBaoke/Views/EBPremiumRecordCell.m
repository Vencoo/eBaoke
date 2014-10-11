//
//  EBPremiumRecordCell.m
//  eBaoke
//
//  Created by Vencoo on 14-9-26.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumRecordCell.h"

@implementation EBPremiumRecordCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCModel:(EBClaimsRecordModel *)cModel
{
    _cModel = cModel;
    
    _numberLabel.text = _cModel.reportNo;
    _dateLabel.text = _cModel.happenTime;
}

@end
