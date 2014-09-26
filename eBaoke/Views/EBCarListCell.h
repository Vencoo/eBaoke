//
//  EBCarListCell.h
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-18.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Globals.h"

@protocol  carListCellButtonDelegate;

@interface EBCarListCell : UITableViewCell

@property (strong, nonatomic) EBCarListModel *carModel;

@property (strong, nonatomic) IBOutlet UILabel *plateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownLabel;
@property (strong, nonatomic) IBOutlet UILabel *ebgineLabel;
@property (strong, nonatomic) IBOutlet UILabel *VINLabel;

@property (strong, nonatomic) IBOutlet UIButton *insuranceButton;
@property (strong, nonatomic) IBOutlet UIButton *PremiumButton;
@property (strong, nonatomic) IBOutlet UIButton *violationButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteSignButton;

@property(nonatomic)id<carListCellButtonDelegate>delegate;

// 设置删除状态
- (void)setDeleteStatus:(BOOL)status;

@end

@protocol  carListCellButtonDelegate <NSObject>

- (void)cellInsuranceAction:(EBCarListCell *)cell;
- (void)cellPremiumBAction:(EBCarListCell *)cell;
- (void)cellViolationAction:(EBCarListCell *)cell;
- (void)cellDeleteAction:(EBCarListCell *)cell;

@end
