//
//  SQViolationsCell.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/21.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQViolationsCell.h"
#import "ColorMacro.h"

@interface SQViolationsCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *lawType;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *line;

@end

@implementation SQViolationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(ViolationsListModel *)model
{
    _orderNo.text = model.orderNo;
    _lawType.text = model.law;
    
    _status.text = model.status == 0||model.status == 1 ? @"未处理":@"已处理";
    _status.textColor = model.status == 0||model.status == 1 ? kBlue : kGreen;
    _line.backgroundColor = model.status == 0||model.status == 1 ? kBlue : kGreen;
    _time.text = model.createTime;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
