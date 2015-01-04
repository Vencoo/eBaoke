//
//  EBClaimRecordCell.h
//  eBaoke
//
//  Created by EvenTouch on 14-12-31.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@interface EBClaimRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *claimNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *claimTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *happenTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dealTimeLabel;

@property (nonatomic) EBClaimsRecordModel *cModel;

@end
