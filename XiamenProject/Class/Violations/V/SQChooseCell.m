//
//  SQChooseCell.m
//  XiamenProject
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQChooseCell.h"

@interface SQChooseCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;


@end

@implementation SQChooseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(LawListModel *)model
{
    self.titleLbl.text = model.content;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
