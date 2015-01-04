//
//  EBClaimRecordCell.m
//  eBaoke
//
//  Created by EvenTouch on 14-12-31.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBClaimRecordCell.h"

@implementation EBClaimRecordCell

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
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CaseStatus" ofType:@"plist"];
    NSDictionary *dict =[[NSDictionary alloc] initWithContentsOfFile:path];
    
    if (_cModel.caseType == nil || [_cModel.caseType isEqualToString:@""]) {
        _claimTypeLabel.text = @"未知类型";
    }else {
        _claimTypeLabel.text = [dict objectForKey:_cModel.caseType];
        
    }    
    _claimNumberLabel.text = _cModel.reportNo;
    _happenTimeLabel.text = _cModel.happenTime;
    _dealTimeLabel.text = _cModel.casePayDate;
}


@end
