//
//  SQMyGarageCell.m
//  XiamenProject
//
//  Created by MacStudent on 2019/6/26.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQMyGarageCell.h"
#import "UIColor+Hex.h"

@interface SQMyGarageCell ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *vehice;
@property (weak, nonatomic) IBOutlet UILabel *no;

@end

@implementation SQMyGarageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"%@",NSStringFromCGRect(_bgView.frame));
 
//    _bgView.layer.masksToBounds = YES;
    [_bgView.layer addSublayer:[UIColor setGradualChangingColor:_bgView fromColor:@"2467EE" toColor:@"699BF9"]];
}


//- (void)layoutSubviews
//{
//    NSLog(@"%@",NSStringFromCGRect(_bgView.frame));
//    [_bgView.layer addSublayer:[UIColor setGradualChangingColor:_bgView fromColor:@"2467EE" toColor:@"699BF9"]];
//}

- (void)setData:(result *)model
{
    _vehice.text = model.imeiNo;
    _no.text = model.headingCode;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
