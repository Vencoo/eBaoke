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

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (IBAction)insuranceButton:(UIButton*)button {
    switch (button.tag) {
        case 0:
        {
            [_delegate pushToInsuranceViewControllerWithTag:button.tag];
        }
            break;
        case 1:
            NSLog(@"insuranceButton1");
            break;
        case 2:
            NSLog(@"insuranceButton2");
            break;
        default:
            break;
    }
}
- (IBAction)premiumButton:(UIButton*)sender {
    NSLog(@"premiumButton");

}
- (IBAction)violationButton:(id)sender {
    NSLog(@"premiumButton");

}

@end
