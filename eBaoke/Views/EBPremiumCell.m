//
//  EBPremiumCell.m
//  eBaoke
//
//  Created by Vencoo on 14-9-26.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBPremiumCell.h"

@implementation EBPremiumCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

- (void)setPModel:(EBPremiumModel *)pModel
{
    _pModel = pModel;
    
    _insuranceCompanyLabel.text = _pModel.insuranceCompany;
    _policyNoLabel.text = _pModel.policyNo;
    _startTimeLabel.text = _pModel.startDate;
    _endTimeLabel.text = _pModel.endDate;
}
- (IBAction)claimRecordAction:(id)sender {
    if (_delegate) {
        [_delegate cellClaimsRecordAction:self];
    }
    
}

@end
