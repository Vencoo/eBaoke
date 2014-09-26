//
//  EBCarListCell.m
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-18.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import "EBCarListCell.h"


@implementation EBCarListCell

- (void)awakeFromNib {
    
    [self bringSubviewToFront:_deleteButton];
    [self bringSubviewToFront:_insuranceButton];
    [self bringSubviewToFront:_violationButton];
    [self bringSubviewToFront:_PremiumButton];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCarModel:(EBCarListModel *)carModel
{
    _carModel = carModel;
    
    self.plateLabel.text = _carModel.plateNo;
    self.ownLabel.text = _carModel.carOwner;
    self.ebgineLabel.text = _carModel.engineNo;
    self.VINLabel.text = _carModel.vinCode;
}

- (void)setDeleteStatus:(BOOL)status
{
    [_deleteButton setHidden:!status];
    [_deleteSignButton setHidden:!status];
    
}

- (IBAction)insuranceButton:(UIButton*)button {
    // 承保信息
    
    if (_delegate) {
        [_delegate cellInsuranceAction:self];
    }
}
- (IBAction)premiumButton:(UIButton*)sender {
    // 保费试算
    if (_delegate) {
        [_delegate cellPremiumBAction:self];
    }

}
- (IBAction)violationButton:(id)sender {
    // 违章记录
    if (_delegate) {
        [_delegate cellViolationAction:self];
    }

}
- (IBAction)deleteAction:(id)sender {
    // 删除
    if (_delegate) {
        [_delegate cellDeleteAction:self];
    }
}

@end
