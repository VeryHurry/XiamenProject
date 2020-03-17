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

- (void)setLawData:(LawListModel *)model
{
    self.titleLbl.text = model.content;
    
}

- (void)setCompanyData:(CompanyModel *)model
{
    self.titleLbl.text = model.name;
}

- (void)setData:(NSString *)str
{
    self.titleLbl.text = str;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
