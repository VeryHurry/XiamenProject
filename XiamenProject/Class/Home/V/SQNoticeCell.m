//
//  SQNoticeCell.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/9.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "SQNoticeCell.h"
#import "UIImageView+WebCache.h"

@interface SQNoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation SQNoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setData:(NSDictionary *)dic
{
    _title.text = dic[@"title"];
    _content.text = dic[@"content"];
//    [_image sd_setImageWithURL:[NSURL URLWithString:dic[@"url"]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
