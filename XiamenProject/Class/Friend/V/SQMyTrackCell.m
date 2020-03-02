//
//  SQMyTrackCell.m
//  XiamenProject
//
//  Created by mac on 2019/7/3.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQMyTrackCell.h"
#import "MacroDefinition.h"
@interface SQMyTrackCell ()

@property (weak, nonatomic) IBOutlet UILabel *finish;
@property (weak, nonatomic) IBOutlet UILabel *orderId;
@property (weak, nonatomic) IBOutlet UILabel *start;
@property (weak, nonatomic) IBOutlet UILabel *end;
@property (weak, nonatomic) IBOutlet UILabel *startAddress;
@property (weak, nonatomic) IBOutlet UILabel *endAddress;


@end

@implementation SQMyTrackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(trackModel *)model
{
    _orderId.text = model.trackNo;
    _start.text = model.startTime;
    _end.text = model.endDate;
    _startAddress.text = model.startAdress;
    _endAddress.text = model.endAdress;
    if (kIsEmptyStr(model.endDate)) {
        _finish.text = @"进行中";
        _finish.textColor = kBlue;
    }
    else
    {
        _finish.text = @"已完成";
        _finish.textColor = [UIColor colorWithHexStr:@"#434343"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
