//
//  EBPremiumCell.h
//  eBaoke
//
//  Created by Vencoo on 14-9-26.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"
@protocol  premiumCellButtonDelegate;

@interface EBPremiumCell : UITableViewCell

@property (nonatomic, strong) EBPremiumModel *pModel;
@property (nonatomic, assign) id<premiumCellButtonDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *insuranceCompanyLabel;
@property (weak, nonatomic) IBOutlet UILabel *policyNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end

@protocol  premiumCellButtonDelegate <NSObject>

- (void)cellClaimsRecordAction:(EBPremiumCell *)cell;

@end