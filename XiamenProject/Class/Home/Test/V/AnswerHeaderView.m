//
//  AnswerHeaderView.m
//  XiamenProject
//
//  Created by MacStudent on 2019/5/14.
//  Copyright © 2019 MacStudent. All rights reserved.
//

#import "AnswerHeaderView.h"
#import "YYKit.h"
#import "NSString+StringSize.h"
#import "ColorMacro.h"

#define LeftMargin 5
#define TopMargin 5

@interface AnswerHeaderView ()

@property (nonatomic,strong) YYTextView *textView;

@property (nonatomic,strong) UILabel *typeLabel;

@end

@implementation AnswerHeaderView

- (UILabel *)typeLabel {
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = kBlue;
        _typeLabel.textAlignment = NSTextAlignmentCenter;
        _typeLabel.font = [UIFont systemFontOfSize:13];
//        _typeLabel.layer.borderColor = kBlue.CGColor;
//        _typeLabel.layer.borderWidth = 0.5;
    }
    return _typeLabel;
}

- (YYTextView *)textView {
    if (!_textView) {
        _textView = [[YYTextView alloc] init];
        _textView.userInteractionEnabled = NO;
        [self addSubview:_textView];
//        _textView.delegate = self;
        _textView.font = [UIFont systemFontOfSize:14];
    }
    return _textView;
}

- (void)setModel:(AnswerDetailModel *)model {
    _model = model;
   
    if (model.type == 1) {
        self.typeLabel.text = @"(单选题)";
    }
    else
    {
        self.typeLabel.text = @"(多选题)";
    }
    
    CGSize size = [self.typeLabel.text sizeWithpreferHeight:MAXFLOAT font:self.typeLabel.font];
    self.typeLabel.frame = CGRectMake(0, 0, size.width, size.height);
    
    self.textView.frame = CGRectMake(LeftMargin, 0, [UIScreen mainScreen].bounds.size.width - LeftMargin, 0);
    NSMutableAttributedString *muatt = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *labelatt = [NSMutableAttributedString attachmentStringWithContent:self.typeLabel contentMode:(UIViewContentModeCenter) attachmentSize:(self.typeLabel.size) alignToFont:self.textView.font alignment:YYTextVerticalAlignmentTop];
    [muatt appendAttributedString:labelatt];
    
    NSString *tempStr = [NSString stringWithFormat:@"  %@[%ld分]",model.title,(long)model.score];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:tempStr];
    [muatt appendAttributedString:str];
    [muatt addAttribute:NSFontAttributeName value:self.textView.font range:NSMakeRange(0, muatt.length)];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 3; //设置行间距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    // 行间距设置
    [muatt addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, muatt.length)];
    
    
    self.textView.attributedText = muatt;
    
    [self updateFrame];
}

- (void)updateFrame {
    self.textView.frame = CGRectMake(LeftMargin, TopMargin, [UIScreen mainScreen].bounds.size.width - LeftMargin, self.textView.contentSize.height);
    self.headerHeight = self.textView.contentSize.height + TopMargin * 2;
}

@end
