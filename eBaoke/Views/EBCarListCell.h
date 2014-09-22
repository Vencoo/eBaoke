//
//  EBCarListCell.h
//  eBaoke
//
//  Created by Vencoo-Mac1 on 14-9-18.
//  Copyright (c) 2014年 vencoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  carListCellButtonDelegate <NSObject>

- (void)pushToInsuranceViewControllerWithTag:(NSInteger)tag;

@end

@interface EBCarListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *plateLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownLabel;
@property (strong, nonatomic) IBOutlet UILabel *ebgineLabel;
@property (strong, nonatomic) IBOutlet UILabel *VINLabel;

@property (strong, nonatomic) IBOutlet UIButton *insuranceButton;
@property (strong, nonatomic) IBOutlet UIButton *PremiumButton;
@property (strong, nonatomic) IBOutlet UIButton *violationButton;

@property(nonatomic)id<carListCellButtonDelegate>delegate;

@end
